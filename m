Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXDVSwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXDVSwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXDVSwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:52:09 -0400
Received: from fed1rmmtao102.cox.net ([68.230.241.44]:51158 "EHLO
	fed1rmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbXDVSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:52:08 -0400
From: Junio C Hamano <junkio@cox.net>
To: Nicolas Pitre <nico@cam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Today's 'master' leaves .idx/.pack in 0400
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net>
	<7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
	<7vvefonvdz.fsf@assigned-by-dhcp.cox.net>
	<7vmz10nv1h.fsf_-_@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221422250.28339@xanadu.home>
	<7vejmcnu28.fsf@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221431430.28339@xanadu.home>
	<alpine.LFD.0.98.0704221443070.28339@xanadu.home>
Date: Sun, 22 Apr 2007 11:52:05 -0700
In-Reply-To: <alpine.LFD.0.98.0704221443070.28339@xanadu.home> (Nicolas
	Pitre's message of "Sun, 22 Apr 2007 14:47:13 -0400 (EDT)")
Message-ID: <7v3b2snsx6.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@cam.org> writes:

> On Sun, 22 Apr 2007, Nicolas Pitre wrote:
>
>> On Sun, 22 Apr 2007, Junio C Hamano wrote:
>> 
>> > Nicolas Pitre <nico@cam.org> writes:
>> > 
>> > > On Sun, 22 Apr 2007, Junio C Hamano wrote:
>> > >
>> > >> With recent glibc, mkstemp() creates 0400 file.  Updated
>> > >> pack-objects uses it in pack/idx writing without fixing this,
>> > >> hence this problem.
>> > >
>> > > Oops.  I guess I'm guilty for this.  I didn't bother looking at the 
>> > > permission on the pack for git-pack-objects since git-repack seemed to 
>> > > take care of that.  But it only _remove_ write permissions.
>> > 
>> > Ok, then probably we can change the 0444 in my "quickfix" patch
>> > to 0644.  That should also let the 5300 test pass.
>> 
>> Well, actually there is no point making pack files writable.  If they're 
>> modified, they get corrupted.
>
> OK there are those test cases.
>
> Well...  Either we chmod to 0644, or we fix the tests to 'chmod +w' like 
> it is already done in t5302.
>
> In any case I wouldn't die() but only error() on a failure to chmod().  
> It is sure inconvenient if the pack isn't world readable, but it is not 
> a "fatal" problem for the repack.

If it DIED, I would not have to have been embarrassed in public
like this!

Grumble.

