Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZAMTAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZAMTAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZAMS76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:59:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbZAMS76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:59:58 -0500
Date: Tue, 13 Jan 2009 10:59:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: handygewinnspiel@gmx.de
Cc: mchehab@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       HWerner4@gmx.de, rjw@sisk.pl
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
Message-Id: <20090113105947.9e774b69.akpm@linux-foundation.org>
In-Reply-To: <20090113184755.87720@gmx.net>
References: <20090112190420.51f75853@pedra.chehab.org>
	<20090112132130.6c932b85.akpm@linux-foundation.org>
	<20090112220624.4fbfee34@pedra.chehab.org>
	<20090112162337.318dd61d.akpm@linux-foundation.org>
	<20090113184755.87720@gmx.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 19:47:55 +0100 handygewinnspiel@gmx.de wrote:

> Dear all,
> 
> i was kindly asked to provide some bug report about findutils-4.1.20 in conjunction with linux-2.6.28, so here we are..
> 
> > On Mon, 12 Jan 2009 22:06:24 -0200
> > Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > 
> > > On Mon, 12 Jan 2009 13:21:30 -0800
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > (cc's added)
> > > > 
> > > > On Mon, 12 Jan 2009 19:04:20 -0200
> > > > Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > > 
> > > > > Do you know is there were any FS changes on 2.6.28 that could break
> > the find
> > > > > command? Maybe we have a regression here. At least, this user i
> > complaining
> > > > > that booting with findutils-4.1.20 and kernel 2.6.28 broke the
> > result of the
> > > > > find command.
> > > > 
> > > > Not known to me.
> > > > 
> > > > Please prepare a bug report and send it to
> > > > 
> > > > Andrew Morton <akpm@linux-foundation.org>
> > > > Al Viro <viro@zeniv.linux.org.uk>
> > > > linux-kernel@vger.kernel.org
> > > > linux-fsdevel@vger.kernel.org
> > > > 
> > > > Thanks.
> > > 
> > > OK. I'll ask the reporter for him to open a bugzilla.
> > > 
> > 
> > An emailed report would be preferred, please.  Some people handle bugzilla
> > OK.  Linux VFS developers are not amongst them ;)
> 
> 
> With kernel 2.6.28 and findutils-4.1.20 the "find" utility from this package fails with the error message
>  "Der Wert ist zu gro__ f__r den definierten Datentyp". It randomly fails on different folders, it works on some folders and fails on others.
> [code]
> find ../ -name *.c
> find: ../: Der Wert ist zu gro__ f__r den definierten Datentyp
> [/code]
> translation to English: "The value is too big for defined data type."
> 
> If i boot from any other kernel the find utility works again as expected. I tried the following kernels
> - 2.6.22.4 = OK
> - 2.6.23.1 = OK
> - 2.6.26.3 = OK
> - 2.6.27.9 = OK
> - 2.6.28 = Error
> 
> 2.6.27.9 and 2.6.28 used the same .config (copy and paste, make oldconfig, make menuconfig to be shure..)
> 
> root file system is xfs, system is 32Bit LinuxFromScratch, if this matters. By compiling findutils-4.4.0 i could solve the problem. But still there is the question what happens here and why older ones are broken.
> 
> btw: unfortunally i overwrote the old "find" while installing new findutils, but today i tried to re-compile it from old sources and retry and i see exactly the same error behaviour.
> 
> Is that something already known?
> 

It's the first such report I've seen.

Could you please generate the strace output for the failing command so
we can see which syscall is failing?

