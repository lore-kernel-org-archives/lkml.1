Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbYJaL1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbYJaL1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYJaL1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:27:01 -0400
Received: from lazybastard.de ([212.112.238.170]:60430 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYJaL1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:27:00 -0400
Date: Fri, 31 Oct 2008 12:26:51 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031112651.GD18182@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225449314.3535.23.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 11:35:14 +0100, Johannes Berg wrote:
> 
> [looks like this hitting LWN means everyone suddenly found it...]

It did?

> > The one aspect where my implementation is actually nice is in allowing
> > variable key length.  Btree keys are interpreted as an array of unsigned
> > long.  So by passing the correct geometry to the core functions, it is
> > possible to handle 32bit, 64bit or 128bit btrees, which logfs uses.  If
> > so desired, any other weird data format can be used as well (Zach, are
> > you reading this?).
> 
> Would there be an easy way to use 48-bit keys? Or variable length keys?

Variable as in one implementation for several trees with different
sizes, yes.  Variable as in one tree with differently sized keys, no.

With the existing code, 48bit keys would need to be expressed as an
array of longs, thereby growing to 64bit.  Alternatively one could
replace the longset/longcmp/longcpy with memset/memcmp/memcpy.

> > So would something like this be merged once some users are identified?
> > Would it be useful for anything but logfs?  Or am I plain nuts?
> 
> I could imagine using it instead of the hash-table for stations and APs
> in the wireless code, stations are identified by the MAC address (48
> bit) and APs (BSSs) are identified by their BSSID+SSID (or mesh ID), so
> variable length. Currently we use a hash table with 256 slots which is
> quite large for the typical case of mostly less than a hundred entries.

MAC address wouldn't be a problem.  For BSSID+SSID one could just keep
the hashing and use the btree as an 'implementation detail' of the
'hashtable'.  Beware that I don't allow two identical keys.  The
implications of that make my toenails curl up.

> > This implementation is extremely simple.  It splits nodes when they
> > overflow.  It does not move elements to neighboring nodes.  It does not
> > try fancy 2:3 splits.  It does not even merge nodes when they shrink,
> > making degenerate cases possible.  And it requires callers to do
> > tree-global locking.  In effect, it will be hard to find anything less
> > sophisticated.
> 
> I think the wireless case would probably want to have real shrinking
> because it's well possible that you're moving, with your laptop, from an
> area with a large number of APs to say your home out in the countryside
> that only has your single AP.

Indeed.

Jörn

-- 
Joern's library part 7:
http://www.usenix.org/publications/library/proceedings/neworl/full_papers/mckusick.a
