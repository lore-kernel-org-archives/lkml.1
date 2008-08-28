Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYH1CpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYH1CpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 22:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbYH1CpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 22:45:04 -0400
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:39019 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbYH1CpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 22:45:03 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 22:45:02 EDT
Date: Wed, 27 Aug 2008 19:39:58 -0700
From: Jason Uhlenkott <juhlenko@akamai.com>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, johnpol@2ka.mipt.ru, dada1@cosmosbay.com,
       denys@visp.net.lb, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080828023958.GB21395@juhlenko-desk.sanmateo.corp.akamai.com>
References: <48B46B48.7030609@cosmosbay.com> <20080826205158.GA15266@2ka.mipt.ru> <87vdxmr53f.fsf@basil.nowhere.org> <20080827.143401.76242975.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827.143401.76242975.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 14:34:01 -0700, David Miller wrote:
> By the time you get to the socket, it might be eons (relatively
> speaking) later, decreasing the usefulness of the timestamp.

It's a *socket* option.  It's named SO_TIMESTAMP.  Users of it ought
to *expect* that it records the time the packet hits the socket, not
the time the frame hits the device.

If banks want to know when frames are hitting their devices, that's
fine, but setsockopt() is the wrong layer for controlling that sort of
thing.  An interface flag would make a lot more sense.


> I find it amusing that nobody it talking about fixing the tools
> that are creating the timestamp requests when they have no real
> reason for having them in the first place.

I don't agree that the tools are broken.  Some of them may have
frivolous reasons for wanting timestamps, but they're asking for
something at the socket layer, with the scope of a single socket, and
it's hardly their fault that we respond to that by doing something
expensive and global at a much lower level.
