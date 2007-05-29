Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbXE2NTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbXE2NTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759563AbXE2NTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:19:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481AbXE2NTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:19:05 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michael-Luke Jones <mike.luke.jones@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <465C15D9.3070905@gmail.com>
References: <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
	 <3ae72650705282355j40a0b03bt96661bc1263efc35@mail.gmail.com>
	 <200705291400.46707.rjw@sisk.pl>  <465C15D9.3070905@gmail.com>
Content-Type: text/plain
Date: Tue, 29 May 2007 15:15:55 +0200
Message-Id: <1180444555.3205.2.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/KAL4dEVVWFXL1tvhZRtdJbAR5y0oibtzI8gf
 L5aninF2IKWKDxMzPsRwjvp5BIpfcS3WcHygqSVMXLVCBtvwZH
 p+EtAVEHOwB1tWh0ChDLTHCsm62L+Qj
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 13:00 +0100, Michael-Luke Jones wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday, 29 May 2007 08:55, Kay Sievers wrote:
> >> The shiny userspace firmware loading causes problems since it exists,
> >> every second box has problems with it, in all sorts of situations. If
> >> people are still sold to the idea of userspace firmware loading, why
> >> don't we keep the data in the driver, instead of immediately
> >> discarding it after the first upload? Not to waste a few hundred
> >> kilobytes? That doesn't sound like a convincing deal, after all the
> >> years people try to work around the issues it causes.
> > 
> > Agreed.
> > 
> > Rafael
> 
> Rather than most drivers being told to make this step, can this be added 
> to the firmware_class such that firmware objects are cached in RAM and 
> subsequent calls to request_firmware() don't have to query userspace.
> 
> This seems the least intrusive solution to this problem.

Who is going to keep track of the data hiding in the firmware_class? On
driver unbind, module unload, you want to release the data.

Kay

