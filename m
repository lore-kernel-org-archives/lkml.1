Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYHPWRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYHPWRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYHPWRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:17:36 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:10703 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYHPWRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R/I5IwaeDrhQ7dF6TA15ydeybHEIMPvNHBHmGOWPmA/uGb/WBBxO1BM/7T6DDiNrH6
         hfkfrGUCNNPC4GxnX8Fwbfu7CWHfPeBQclU5RcPgieFSgRpQgCei2oTxNPKGcsCczemq
         e4hIRPWWonzdaU+UACiKfhRWAMlfZ8FTLg0vs=
Message-ID: <86802c440808161517y1eaa5a4eo817b8a1bf75945be@mail.gmail.com>
Date: Sat, 16 Aug 2008 15:17:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>
In-Reply-To: <1218919547.3940.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	 <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
	 <1218898238.3940.6.camel@localhost.localdomain>
	 <20080816163945.74d487e9@lxorguk.ukuu.org.uk>
	 <1218903209.3940.14.camel@localhost.localdomain>
	 <86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
	 <1218918341.3940.49.camel@localhost.localdomain>
	 <86802c440808161334q75a7d019ofade0b6cabf3f74d@mail.gmail.com>
	 <1218919547.3940.57.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 1:45 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>> > What I still don't quite get is the benefit of large IRQ spaces ...
>> > particularly if you encode things the system doesn't really need to know
>> > in them.
>>
>> then set nr_irqs = nr_cpu_ids * NR_VECTORS))
>> and count down for msi/msi-x?
>
> No, what I mean is that msis can trip directly to CPUs, so this is an
> affinity thing (that MSI is directly bound to that CPU now), so in the
> matrixed way we display this in show_interrupts() with the CPU along the
> top and the IRQ down the side, it doesn't make sense to me to encode IRQ
> affinity in the irq number again.   So it makes more sense to assign the
> vectors based on both the irq number and the CPU affinity so that if the
> PCI MSI for qla is assigned to CPU4 you can reassign it to CPU5 and so
> on.

msi-x entry index, cpu_vector, irq number...

you want to different cpus have same vector?

YH
