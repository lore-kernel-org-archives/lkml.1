Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYEMRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYEMRcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYEMRcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:32:11 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56447 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYEMRcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:32:10 -0400
Message-ID: <4829D0E5.8050905@keyaccess.nl>
Date: Tue, 13 May 2008 19:33:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Takashi Iwai <tiwai@suse.de>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl>	<s5hzlr0105c.wl%tiwai@suse.de>	<200805131059.32911.bjorn.helgaas@hp.com> <20080513180107.1a3893f1@core>
In-Reply-To: <20080513180107.1a3893f1@core>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-05-08 19:01, Alan Cox wrote:

> On Tue, 13 May 2008 10:59:32 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
>> On Friday 09 May 2008 12:06:55 am Takashi Iwai wrote:
>>> Thanks for catching it.  Yeah, the patch looks buggy.  We had an
>>> implicit assumption that dev = NULL for ISA devices that require 24bit
>>> DMA.
>> Naive question #1:  Why don't we have a struct device for these
>> ISA devices?  PNP builds a struct device with DMA_24BIT_MASK
>> for ISAPNP devices.
> 
> Because nobody has done the needed work to get all the old ISA drivers
> converted. I guess isa_device would actually be a platform_device
> wrapper ?

No, isa_device is its own thing, on its own isa_bus (*). It has a struct 
device * readily available though...

Rene

(*) drivers/base/isa.c, and explanatory changelog at:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a5117ba7da37deb09df5eb802dace229b3fb1e9f
