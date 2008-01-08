Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYAHMyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYAHMyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 07:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYAHMyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 07:54:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYAHMyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 07:54:02 -0500
Date: Tue, 8 Jan 2008 13:51:47 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
In-Reply-To: <4782B515.3010008@keyaccess.nl>
Message-ID: <alpine.LSU.0.999.0801081333530.12636@be1.lrz>
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it>
 <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it>
 <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it>
 <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it>
 <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it>
 <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it>
 <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com>
 <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com>
 <alpine.LSU.0.999.0801072316440.16143@be1.lrz> <4782AED5.1060406@keyaccess.nl>
 <4782B4B9.2020608@zytor.com> <4782B515.3010008@keyaccess.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18Bmq5bbi/OawHOUp1G3/27HX7BfTzP8GUGVRd
 En64nALV5M0Pd5Ga9lViRwMH5YP+9GLAKi2ROgHfgpD1593OEM
 rbKQbTSPODfEEedSTcaeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Rene Herman wrote:
> On 08-01-08 00:24, H. Peter Anvin wrote:
> > Rene Herman wrote:

> > > Is this only about the ones then left for things like legacy PIC and PIT?
> > > Does anyone care about just sticking in a udelay(2) (or 1) there as a
> > > replacement and call it a day?
> > > 
> > 
> > PIT is problematic because the PIT may be necessary for udelay setup.
> 
> Yes, can initialise loops_per_jiffy conservatively. Just didn't quite get why
> you guys are talking about an ISA bus speed parameter.

If the ISA bus is below 8 MHz, we might need a longer delay. If we default
to the longer delay, the delay will be too long for more than 99,99 % of 
all systems, not counting i586+. Especially if the driver is fine-tuned to 
give maximum throughput, this may be bad.

OTOH, the DOS drivers I heared about use delays and would break on 
underclocked ISA busses if the n * ISA_HZ delay was needed. Maybe
somebody having a configurable ISA bus speed and some problematic
chips can test it ...

-- 
Fun things to slip into your budget
"I [Meow Cat] sliped in 'Legal fees for firing Jim (Jim's my [his] boss).'
Jim approved the budget and was fired when upper management saw the budget."
