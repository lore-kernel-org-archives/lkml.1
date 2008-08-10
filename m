Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbYHJJer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbYHJJer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 05:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYHJJej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 05:34:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:34843 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYHJJei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 05:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i1KDM3E4r7uG0PBNhCQGazmRnTkibuB5XGDnIHAc8JKYTwfZhyPQL8/hTB+fcC570Y
         ql5Uv9/9zGINe9rbVyO56Xw4BJbOf3v3gbmwmrIoYy8k3DtE+d2PGYdu5cgl9zC2pMqP
         1rmrd/xmlJJ6OBApGCJ1QY5TxJEuz0Ibwt9H8=
Message-ID: <95c340a40808100234u14bb1c23x7941c2a7ead1eb7@mail.gmail.com>
Date: Sun, 10 Aug 2008 15:04:36 +0530
From: "Jaswinder Singh" <jaswinderdavinci@gmail.com>
To: "Kevin Hilman" <khilman@deeprootsystems.com>
Subject: Re: [PATCH v2 02/13] ARM:DaVinci: base address for dm6467
Cc: "Sudhakar Rajashekhara" <sudhakar.raj@ti.com>,
       davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <87proke7gf.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218098155-11999-1-git-send-email-sudhakar.raj@ti.com>
	 <87proke7gf.fsf@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Fri, Aug 8, 2008 at 4:52 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Sudhakar Rajashekhara <sudhakar.raj@ti.com> writes:
>
>> Source: Texas Instruments Inc.
>> Type: Enhancement
>> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
>> Description:
>> Defines the base addresses and LPSC assignments for dm6467.
>> ---
>>  include/asm-arm/arch-davinci/hardware.h        |    2 +
>>  include/asm-arm/arch-davinci/hardware_dm6467.h |   90 ++++++++++++++++++++++++
>>  2 files changed, 92 insertions(+), 0 deletions(-)
>>  create mode 100644 include/asm-arm/arch-davinci/hardware_dm6467.h
>>
>> diff --git a/include/asm-arm/arch-davinci/hardware.h b/include/asm-arm/arch-davinci/hardware.h
>> index a2e8969..1f88572 100644
>> --- a/include/asm-arm/arch-davinci/hardware.h
>> +++ b/include/asm-arm/arch-davinci/hardware.h
>> @@ -11,6 +11,8 @@
>>  #ifndef __ASM_ARCH_HARDWARE_H
>>  #define __ASM_ARCH_HARDWARE_H
>>
>> +#include <asm/arch/hardware_dm6467.h>
>> +
>
> Yes, Like that this is a separate file.  However, lets just call it dm6467.h
>

I do not understand what is the point of adding dm6467.h without
#ifdef CONFIG_ARCH_DAVINCI_DM646x. If I have 6446 why should I add
6467. This make sense if I have board with multiple chips like dm6446
chip and dm6467 chips. Can you please explain.

I can understand you are trying to follow omap model but some other
nice models are also available for example SH model we can take
advantage of those.

I like this approach in SH that they are growing in multiple-direction
as they added supports for cpus, boards and drivers. They did their
porting in such a way that it is easy to add more boards and more cpus
by just copying paste and change your settings as per your hardware.

Currently we are assuming 6446 chip as common. I think 6446 part
should also come in ifdef  CONFIG_ARCH_DAVINCI_DM646x. If I am using
DM355 why should I need 6446.

And Currently arch-davinci is based only on TI EVM board. There are
different kinds of boards available in market. To add them in linux
tree we should move current EVM to CONFIG_MACH_DAVINCI_TIEVM. So I
think we also need to revise our directory sturcture to grow our
family.

I am also CCing to LKML and Paul Mundt to get feedbacks.

>> +#define DAVINCI_DM646X_DMA_3PTC2_BASE             (0x01C10800)
>> +#define DAVINCI_DM646X_DMA_3PTC3_BASE             (0x01C10C00)
>> +#define DAVINCI_DM646X_VIDEO_PORT_BASE            (0x01C12000)
>> +#define DAVINCI_DM646X_VDCE_BASE                  (0x01C12800)
>> +#define DAVINCI_DM646X_TSIF0_BASE                 (0x01C13000)
>> +#define DAVINCI_DM646X_TSIF1_BASE                 (0x01C13400)
>> +#define DAVINCI_DM646X_PCI_CTL_BASE               (0x01C1A000)
>> +#define DAVINCI_DM646X_CRGEN0_BASE                (0x01C26000)

Sudhakar, why you are using space key, I think you should use tab key
for spacing.

Thank you,

Jaswinder Singh.
