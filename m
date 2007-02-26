Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbXBZQei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbXBZQei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030303AbXBZQeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:34:37 -0500
Received: from kanga.kvack.org ([66.96.29.28]:41754 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbXBZQeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:34:37 -0500
Date: Mon, 26 Feb 2007 11:34:29 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Uwe Bugla <uwe.bugla@gmx.de>,
       akpm@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <ak@suse.de>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be mounted without hanging up the whole system
Message-ID: <20070226163429.GL26583@kvack.org>
References: <20070224175424.176030@gmx.net> <45E2B88B.1090706@gmail.com> <45E2F8C5.3080905@gmail.com> <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 07:51:19AM -0800, Linus Torvalds wrote:
> > Commit: 2ff2d3d74705d34ab71b21f54634fcf50d57bdd5
> > Author: Stephane Eranian <eranian@hpl.hp.com> Tue, 13 Feb 2007 13:26:22 +0100
> > 
> >     [PATCH] i386: add idle notifier
> 
> Interesting. It doesn't touch floppy at all, but it *does* seem to play 
> around with irq state. 

Side note: this patch adds several function calls (4), several additional 
L1 cache touches and a generally inefficient code path to *every single 
interrupt that exits from the idle poll*, not to mention the extra (useless, 
as it doesn't get used on 99.9% of deployed systems) function call and cache 
touches to every single interrupt.  Keep in mind that systems acting as 
routers will often be sitting in the idle loop when processing interrupts.  
At the very least this overhead (which is noticable on profiles) should be 
configurable.  I don't think that my 586 class embedded routers really need 
this crap to be going into the kernel.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
