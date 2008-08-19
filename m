Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYHSXUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYHSXUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYHSXUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:20:03 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:48104 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbYHSXUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:20:01 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48AB551D.6010708@citrix.com>
Date: Wed, 20 Aug 2008 00:19:57 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: Change the default value of nr_irqs from 32 to NR_IRQs
References: <48AAFAE4.7070409@citrix.com>	 <86802c440808191044h74871ba1u62330dae18599436@mail.gmail.com>	 <0E902970173AF84089673FA54B7FE78A2CA11D@lonpexch01.citrite.net>	 <86802c440808191124v39ce2aa9rb548d3bdd75ca25c@mail.gmail.com>	 <48AB11A3.4060102@citrix.com>	 <86802c440808191200u364ffd86h49af661e58d20ea3@mail.gmail.com>	 <48AB241A.4030706@citrix.com> <86802c440808191352g75c99737kcb8c9c20d59c8f7b@mail.gmail.com>
In-Reply-To: <86802c440808191352g75c99737kcb8c9c20d59c8f7b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> when !CONFIG_HAVE_SPARSE_IRQ, with dyn_array, could allocate irq_desc
> and etc as less as possible.
> when CONFIG_HAVE_SPARESE_IRQ, no actually meaning for nr_irqs.
> 
> YH

So I believe the only case this affects is !CONFIG_HAVE_SPARSE_IRQ

The worry is that with CONFIG_HAVE_DYN_ARRAY we may waste memory by 
pre-allocating more irq_descs than may be necessary (NR_IRQs vs 32)?

With !CONFIG_HAVE_DYN_ARRAY however, a static array of size NR_IRQS is 
allocated instead - so doesn't defaulting nr_irqs back to NR_IRQS just 
revert to the old behaviour (with the exception of the irq_descs being 
allocated in pre_alloc_dyn_array instead)?

- Alex
