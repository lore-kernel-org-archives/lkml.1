Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXDVS13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXDVS13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbXDVS13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:27:29 -0400
Received: from fed1rmmtao107.cox.net ([68.230.241.39]:33084 "EHLO
	fed1rmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbXDVS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:27:28 -0400
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
Date: Sun, 22 Apr 2007 11:27:27 -0700
In-Reply-To: <alpine.LFD.0.98.0704221422250.28339@xanadu.home> (Nicolas
	Pitre's message of "Sun, 22 Apr 2007 14:25:14 -0400 (EDT)")
Message-ID: <7vejmcnu28.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@cam.org> writes:

> On Sun, 22 Apr 2007, Junio C Hamano wrote:
>
>> With recent glibc, mkstemp() creates 0400 file.  Updated
>> pack-objects uses it in pack/idx writing without fixing this,
>> hence this problem.
>
> Oops.  I guess I'm guilty for this.  I didn't bother looking at the 
> permission on the pack for git-pack-objects since git-repack seemed to 
> take care of that.  But it only _remove_ write permissions.

Ok, then probably we can change the 0444 in my "quickfix" patch
to 0644.  That should also let the 5300 test pass.

