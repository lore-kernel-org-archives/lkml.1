Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbYEUXel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbYEUXel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbYEUXed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:34:33 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:9884 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYEUXec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RNcP5RZze7ICK2cVk+kDLZK6uvN0ufYMesMPqqIRzcZVVQ4YMe2ap8PXMeazKZ+bdowD8/aiE/PxCBwu+B9LpEhZ+gqN1AwUiyOnnWMRr5/n6WwYFaTshrC0B507pQnYP4WbEb+fH2iOHoS12GlH/wEE2AObLfXzuCGCk1m5NYM=
Message-ID: <8bd0f97a0805211634r41cd2bafp94615fdfbdd4b7f7@mail.gmail.com>
Date: Wed, 21 May 2008 19:34:28 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>, michael.hennerich@analog.com
Subject: Re: + pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch added to -mm tree
Cc: akpm@linux-foundation.org,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
In-Reply-To: <386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805200608.m4K68d0N008092@imap1.linux-foundation.org>
	 <386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 3:51 AM, Bryan Wu <cooloney@kernel.org> wrote:
> On Tue, May 20, 2008 at 2:08 PM,  <akpm@linux-foundation.org> wrote:
>> +config BFIN_CFPCMCIA
>> +       tristate "Blackfin CompactFlash PCMCIA Driver"
>> +       depends on PCMCIA && BLACKFIN
>> +       help
>> +         Say Y here to support the CompactFlash PCMCIA driver for Blackfin.

please add a common statement that tells you the module name if the
user builds it as a module.

>> + * author: Michael Hennerich (hennerich@blackfin.uclinux.org)

shouldnt this be MODULE_AUTHOR() ?

>> +       u_int irq;
>> +       u_short cd_pfx;

u_int forms are weird ... i'd wonder why we have these variations
anywhere in the kernel

>> +static int __init bfin_cf_probe(struct platform_device *pdev)

should be __devinit

>> +       cd_pfx = platform_get_irq(pdev, 1);     /*Card Detect GPIO PIN */
>> +       if (cd_pfx > MAX_BLACKFIN_GPIOS)
>> +               return -EINVAL;
>> +
>> +       if (gpio_request(cd_pfx, "pcmcia: CD")) {

i dont think that MAX_BLACKFIN_GPIOS check is needed.  the
gpio_request() function should already be doing it.

>> +               printk(KERN_ERR
>> +                      "BF5xx flash: Failed ro request Card Detect GPIO_%d\n",

"BF5xx flash" ?

>> +       cf = kzalloc(sizeof *cf, GFP_KERNEL);
>> +       if (!cf)
>> +               return -ENOMEM;

we dont call gpio_free() here or in the fail0 case below.
-mike
