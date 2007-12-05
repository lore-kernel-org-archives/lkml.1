Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbXLEBrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbXLEBrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 20:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXLEBrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 20:47:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbXLEBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 20:47:15 -0500
Date: Tue, 4 Dec 2007 17:46:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix for futex_wait signal stack corruption
In-Reply-To: <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org>
References: <1196801858.1645.37.camel@localhost.localdomain> <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org> <20071204213924.GA14915@goodmis.org> <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Dec 2007, Steven Rostedt wrote:
> 
> Since arg3 is out, which do you prefer? Creating an arg4 (and perhaps
> more) in the block or having a u64 arg?  Changing all the args to u64 may
> be the best.

I suspect that the best option is probably to make that thing a unnamed 
union of the actual different types the different restart cases needs, 
which also allows you to name things appropriately and not have any wasted 
space.

Leave the arg0-3 ones around as one of the unions, both to avoid having to 
change other things and to have a "generic" one for stuff that simply 
doesn't much care (in order to not have tons and tons of substructures to 
the union when most users really don't need any fancy types).

I think we already depend on recent-enough gcc's that unnamed unions are 
ok and we don't need to play games with naming.

		Linus
