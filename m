Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZCKDl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZCKDl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 23:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZCKDkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 23:40:39 -0400
Received: from n6.bullet.mud.yahoo.com ([216.252.100.57]:41331 "HELO
	n6.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755905AbZCKDkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 23:40:37 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2009 23:40:37 EDT
X-Yahoo-Newman-Id: 97622.29548.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SH+7Tk42LMdbbzNq23YPlz6Kw73zqrTxBnPA1KTBuFzr4vsEk4f7fPM3aDfgczvOliG6MzLPJ8cJQLEQ/yvfsi/ArmJbnyCVEobB8hppi/Z3Bx1tSTf3HDjgJC1KRIMVjln8z3Xka9MedTh/lfOsnIyHqc3OdAAStyTV2YxVBeE=  ;
X-YMail-OSG: uETykqYVM1kqZ1Yu9QM_.Zz7beIpbAgwpNz9WRH5.VZuEQGWidaC6HqUtlloy8eVQgXxh5aD7luZwSdrBvjmKIV.tdZm2KzUEMLBQrtIe17JQcb3bFgsN0oMYpJdXycJ5HHs2BU7Vm_Wekuo0.h.lTJO
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when resuming
Date: Tue, 10 Mar 2009 19:33:50 -0800
User-Agent: KMail/1.9.10
Cc: Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?utf-8?q?=EA=B9=80=EA=B7=9C=EC=9B=90?= <q1.kim@samsung.com>,
       =?utf-8?q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com> <4d34a0a70902222141y345a7bc3g314e6de5df156f2d@mail.gmail.com> <49A258A2.2020408@nokia.com>
In-Reply-To: <49A258A2.2020408@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903102033.51026.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Adrian Hunter wrote:
> Although I have not tested it, I very much doubt
> dual-voltage cards work.  That is because VMMC1_185V
> is zero, which has the side-effect of turning the
> regulator off (see arch/arm/mach-omap2/mmc-twl4030.c)

And a second reason to know they don't quite work ... in
the file drivers/mmc/host/omap_hsmmc.c, omap_mmc_set_ios()
sets the voltage for MMC_POWER_OFF (0) or MMC_POWER_UP (1_,
which gives the initial setting -- e.g. 3.15 Volts, so it
can enumerate at the high range.

But after enumerating the card at that voltage, checking
the OCR values, and concluding that the slot and card can
both run at 1.85V ... the MMC_POWER_ON (2) code is used.
But the driver completely ignores it ... the low voltage
(more power-efficient!) voltage range never kicks in.

It'd be nice to have a nice unambiguous set_voltage()
request from the MMC core.  The set_ios() thing has
always been confusing.

- Dave


