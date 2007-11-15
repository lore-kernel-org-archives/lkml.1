Return-Path: <linux-kernel-owner+w=401wt.eu-S1761088AbXKOIcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761088AbXKOIcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbXKOIco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:32:44 -0500
Received: from smtp25.orange.fr ([193.252.22.21]:29359 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbXKOIcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:32:43 -0500
X-ME-UUID: 20071115083240617.96C371C00086@mwinf2542.orange.fr
Date: Thu, 15 Nov 2007 09:27:46 +0100
From: Philippe Elie <phil.el@wanadoo.fr>
To: Russell Leighton <russ@elegant-software.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: OT: Does Linux have any "Perfect Code"
Message-ID: <20071115082746.GA2885@zaniah>
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 at 20:21 +0000, Russell Leighton wrote:

> 
> Bryan Cantrill of Sun (ala DTrace) has a notion of perfect code:
> 
> 	http://blogs.sun.com/bmc/entry/on_i_dreaming_in_code
> 
> He also has some examples (from bottom comment section of above):
> 
> >
> >
> >Can you list a small number of examples of "software perfection"?
> >
> >Posted by Russell Leighton on November 14, 2007 at 04:02 AM PST #
> >
> >Russell,
> >
> >My canonical small example of perfection in Solaris would be Jeff  
> >Bonwick's mod-by-a-billion code in hrt2ts():
> >
> >http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/ 
> >common/os/timers.c#875
> >
> >Solaris of course has lots of bigger, more complicated examples. Now  
> >on the one hand, one wants to refrain from pointing to thousands of  
> >lines of code and saying that there are no bugs therein, but on the  
> >other, there are many subsystems that have been in place and in heavy  
> >use for years without defect or modification. At the risk of being  
> >egocentric, the cyclic subsystem (which is executed at least 100 times  
> >per second on every Solaris system) had its last substantial fix over  
> >six years ago, and its last fix of any flavor over three years ago:
> >
> >http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/ 
> >common/os/cyclic.c
> >
> >Modesty (and the lack, of course, of a proof of its correctness)  
> >prevents me from calling the cyclic subsystem perfect -- but such as  
> >unknown defects remain, there are damn few of them, and we can say  
> >that they must be a result of highly usual (or at least, heretofore  
> >unseen) circumstances.
> >
> >A non-Solaris example -- and one that I've been known to use as the  
> >canonical example of the persistence of software -- is Super Mario  
> >Kart. This is a game that was developed (to its completion) fifteen  
> >years ago for the Super Nintendo console. Source code, to the best of  
> >my knowledge, is not publicly available and may indeed be lost -- but  
> >the binaries persist and (if my coworkers are any indication) remain  
> >in active use. Given the longevity of, say, Homer's Odyssey, there is  
> >reason to believe that Super Mario Kart will survive in perpetuity --  
> >that thousands of years from now, twenty-somethings somewhere will be  
> >using the software exactly as it is used today. Is this perfection?  
> >Perhaps not -- but it also might not be discernible from perfection...
> >
> >Posted by Bryan Cantrill on November 14, 2007 at 07:51 AM PST #
> 
> Does Linux have any such examples true software perfection?

This code is far to be perfect, some part is outdated, bcopy() use instead
of memcpy() for example. More annoying are the comment, the file is 3306
lines while there is only 1640 line of code, nothing bad per se but looking
some comments:

 		/*
 		 * Before we begin this operation, disable kernel preemption.
 		 */
 		kpreempt_disable();


uhh...

or 

 	if (cyclic->cy_pend != 0) {
		/*
 		 * The pend is non-zero; ...

I will never guessed that, w/o the comment :)

 		/*
 		 * We have both a left and a right child.  We need to compare
 		 * the expiration times of the children to determine which
 		 * expires earlier.
 		 */
 		if (cyclics[right].cy_expire < cyclics[left].cy_expire) {

writing array[index] in C is already a promise than index is in
[0-array size)

-- 
Phe

