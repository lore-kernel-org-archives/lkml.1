Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbYHIBoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbYHIBoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbYHIBn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:43:56 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33589 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752202AbYHIBnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:43:55 -0400
Date: Fri, 8 Aug 2008 21:43:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080809014348.GC9967@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <20080808215625.GC9038@one.firstfloor.org> <20080809011905.GB9967@mit.edu> <20080809012322.GF9038@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809012322.GF9038@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 03:23:22AM +0200, Andi Kleen wrote:
> > In theory, if the elevator was smart enough, it could actually help
> > read seekiness; there are two copies of the metadata, and it shouldn't
> 
> That assumes the elevator actually knows what is nearby? I thought
> that wasn't that easy with modern disks with multiple spindles
> and invisible remapping, not even talking about RAID
> arrays looking like disks.

RAID is the big problem, yeah.  In general, though, we are already
making an assumption in the elevator code and in filesystem code that
block numbers which are numerically closer together are "close" from
the perspective of disks.  There has been talk about trying to make
filesystems smarter about allocating blocks by giving them visibility
to the RAID parameters; in theory the elevator algorithm could also be
made smarter as well using the same information.  I'm really not sure
if the complexity is worth it, though....

						- Ted
