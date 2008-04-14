Return-Path: <linux-kernel-owner+w=401wt.eu-S1763257AbYDNRTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763257AbYDNRTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbYDNRTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:19:25 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.17]:55858 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762648AbYDNRTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:19:21 -0400
Date: Mon, 14 Apr 2008 19:19:04 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: Again... DMA speed too slow
Message-ID: <48039208.H1ySWf8m1sXKYjHZ%Joerg.Schilling@fokus.fraunhofer.de>
References: <48038c3e.P3RWjRNXsDrhjIX7%Joerg.Schilling@fokus.fraunhofer.de>
 <20080414175636.4ea815dc@core>
In-Reply-To: <20080414175636.4ea815dc@core>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Apr 2008 17:19:03.0952 (UTC) FILETIME=[A350E100:01C89E53]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Mon, 14 Apr 2008 18:54:22 +0200
> Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling) wrote:
>
> > >Which controller are you on?  I bet the recording itself will work fine
> > >on 48x.  It's probably that READ/WRITE BUFFERs are executed using PIO
> > >for compatibility reasons. 
> > 
> > If this happens inside Linux, Linux should be changed...
>
> The cases Linux falls back to PIO are the cases where the hardware isn't
> up to it, or reliably handling some DMA commands. Lots of that about in
> the PC world.

OK, I know that a few drives give wrong DMA speed test results on Solaris,
so the behavior for these drives seems to be unrelated to the OS.

Cdrecord is under constant development and for this reason, there are 
workareounds for these drives.

> > 2.01.01a38 is the latest. Install cdrecord suid root
>
> Remarkably brave ;)

I am not sure why you mention the term "brave", is it because all known Linux 
distributions still require suid root? In this case, I encourage you to inform 
yourself about the code quality of cdrecord. There was no known security problem 
during the past 4 years. Try to compare with other software ,-)



If you have problems with drives that implement no DMA with read buffer, just 
call:

CDR_FORCESPEED=any cdrecord ......

Another way to deal with the problem is to create a file /etc/default/cdrecord
and to configure to use burnfree by default for the related drive.

e.g. by using a line:

optiarc=          1,0,0	-1	-1	burnfree

and call "cdrecord dev=optiarc ..."

If there is interest in having a way to force any speed without swiching on 
burnfree, I may add an option that may be used in /etc/default/cdrecord with the
same effect as CDR_FORCESPEED=any



Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
