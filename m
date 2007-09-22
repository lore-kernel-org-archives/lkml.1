Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbXIVVTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbXIVVTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 17:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXIVVTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 17:19:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:59968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXIVVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 17:19:41 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Unfortunate infinite make recursion
To: Jan Engelhardt <jengelh@computergmbh.de>, sam@ravnborg.org,
       zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 22 Sep 2007 23:19:30 +0200
References: <96blF-29e-27@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IZCNu-0000ai-Rt@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+QAhIjV07/R5afgXmkkDQ8alD//OcWVkxpaLG
 QEQ+GtW1Udyu6Et8cZYpPd2d95O22FmM9M9yarojgyJTi+Js3x
 7LvWoeBPBuU3vJiGx+Sdw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> wrote:

> You can cause a recursion in kbuild/make with the following:
> 
> make O=$PWD kernel/time.o
> make mrproper
> 
> Of course no one would use O=$PWD (that's just the testcase),
> but this happened too often:
> 
> /ws/linux/linux-2.6.23$ make O=/ws/linux/linux-2.6.23 kernel/time.o
> (Oops - should have been O=/ws/linux/obj-2.6.23!)
> 
> The make O=$PWD truncates the Makefile, making it necessary to run `git
> checkout Makefile` - should you have git; or reextract the tarball
> (should you /still/ have it). Well, can we catch this case somehow?

You can test for the existence of MAINTAINERS in the build dir and abort
if it's there.
-- 
My computer isn't that nervous...it's just a bit ANSI. 

Friﬂ, Spammer: Z9asY@K.7eggert.dyndns.org nwJ@ACle6hUq.7eggert.dyndns.org
 l@zjuq.-z.7eggert.dyndns.org pjy.jbJ@rpodmsnk.7eggert.dyndns.org
