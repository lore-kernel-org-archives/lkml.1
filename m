Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYE3WIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYE3WIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYE3WIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:08:32 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56746 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYE3WIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:08:31 -0400
Message-ID: <48407B99.4080209@keyaccess.nl>
Date: Sat, 31 May 2008 00:11:37 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl> <482B38D6.5030804@keyaccess.nl> <48406E8D.8050408@keyaccess.nl> <200805301543.42208.bjorn.helgaas@hp.com>
In-Reply-To: <200805301543.42208.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-05-08 23:43, Bjorn Helgaas wrote:

> On Friday 30 May 2008 03:15:57 pm Rene Herman wrote:

>> It gets uglier. ALSA ISA drivers (for cards that exist both as legacy 
>> and as ISAPnP at least) keep a merged legacy/isapnp model; PnP is used 
>> mostly for initializing global variables that the same old legacy probe 
>> routines then reference. This means that beyond that global resource 
>> init step the specific struct device is no longer available. Without 
>> restructuring too many things really only fixable through other hacks 
>> again such as a global dma_dev[] array or some such.
>>
>>  From the viewpoint of PnP itself setting the dma_mask for a pnp_card (a 
>> pnp_dev collection) makes isolated sense so if no objections, I'll 
>> submit the attached after all. From the ALSA side we'd then pass the 
>> card dev (which we'd also do for isa_dev) and keep in mind that we might 
>> want to get more specific if over time structure permits it.
>>
>> struct snd_pcm already has its own struct device * which would be the 
>> right one here but it's setting that which gets ugly...
> 
> Looks good to me.  It does sound like a lot of work and possibly
> more risk than it's worth to fix up some of this stuff.

Fairly invasive at least. The good thing though is that with the recent 
pnp_manual_config_dev() removal the PnP drivers have no actual need/use 
for this global variable model anymore and now I have a great excuse for 
rewriting them. That can happen one at a time though...

> I do still wonder whether any non-x86 architectures need similar
> fixes in dma_alloc_coherent(), i.e., check for dev==NULL and fall
> back to a 24-bit DMA mask.

Hrmmpf. Good question. In sound/isa, we've had a but of alpha spottyness 
over time but nothing which would seem to be related.

> Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Thanks. I'll assume Andrew picks it up from the CC...

Rene.
