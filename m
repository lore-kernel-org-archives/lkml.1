Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbYFDLso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbYFDLso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYFDLsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:48:36 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35471 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYFDLsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:48:35 -0400
Message-ID: <4846810B.2030301@keyaccess.nl>
Date: Wed, 04 Jun 2008 13:48:27 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked
 list
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224934.357694359@ldl.fc.hp.com> <4845A217.3030701@keyaccess.nl> <4845D937.2000205@keyaccess.nl>
In-Reply-To: <4845D937.2000205@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-06-08 01:52, Rene Herman wrote:

Mmm. If you care for it:

> === 4 === quirk_ad1815_mpu_resources, ADS7151
> 
> These results are with the dependent cloning already removed locally.
> 
> * pre-quirk:
> 
> irq 5,7,2/9,11,12 High-Edge
> Dependent: 00 - Priority preferred
>   port 0x330-0x330, align 0x0, size 0x2, 10-bit address decoding
> Dependent: 01 - Priority acceptable
>   port 0x300-0x300, align 0x0, size 0x2, 10-bit address decoding
> Dependent: 02 - Priority functional
>   port 0x100-0x3fe, align 0x1, size 0x2, 10-bit address decoding
> 
> * post-quirk:
> 
> irq 5,7,2/9,11,12 High-Edge
> Dependent: 00 - Priority preferred
>   port 0x330-0x330, align 0x0, size 0x2, 10-bit address decoding
> Dependent: 01 - Priority acceptable
>   port 0x300-0x300, align 0x0, size 0x2, 10-bit address decoding
> Dependent: 02 - Priority functional
>   port 0x100-0x3fe, align 0x1, size 0x2, 10-bit address decoding
> 
> 
> See why that "(optional)" flag display is good? :-) I ofcourse tested 
> things and the flag works great...
> 
> 
> == 5 == quirk_add_irq_optional_dependent_sets, ADS7181
> 
> * pre-quirk:
> 
> Dependent: 00 - Priority preferred
>   irq 2/9 High-Edge
>   port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 01 - Priority acceptable
>   irq 2/9 High-Edge
>   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 02 - Priority functional
>   irq 2/9,10,11 High-Edge
>   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
> 
> * post-quirk:
> 
> Dependent: 00 - Priority preferred
>   irq 2/9 High-Edge
>   port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 01 - Priority acceptable
>   irq 2/9 High-Edge
>   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 02 - Priority functional
>   irq 2/9,10,11 High-Edge
>   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 03 - Priority functional
>   irq 2/9 High-Edge
>   port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 04 - Priority functional
>   irq 2/9 High-Edge
>   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 05 - Priority functional
>   irq 2/9,10,11 High-Edge
>   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding

ADS7181 in fact might as well delete the IRQ from the dependents and add
"irq 2/9,10,11 High-Edge Optinal" in front as an independent same as 
ADS7151. That way, all the cloning can go.

I'll probably place that on top if you don't, but you might already want 
to since it loses all that code. Only difference would be that if IRQ 9 
is taken and 10 free, the new situation would grab 330/10 while the old 
would've taken 300/10, but that's in fact better...

Rene.
