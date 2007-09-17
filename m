Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbXIQNIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbXIQNIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXIQNIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:08:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:25409 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbXIQNIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VVTV+hGRUhS/T/b2lY55Vek0kkR+DFWioMF+dRW0VwOeFLxMDK0x7gMv0roZ4mj1tSOs5dMaUt2Z2Un/5cgj+9yPUgyOkNw7LbXwHfnamESw0uVtcA7GpA3qt1iTio3LqwmKav9T/aFu91a3QDN/P/iOMLoExa4EugDCv+grYvg=
Subject: Re: 2.6.22.1: Enabling IO-APIC = APIC error on CPU0: 40(40)
From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Reply-To: konstantin.sharlaimov@gmail.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707140758110.22713@p34.internal.lan>
References: <Pine.LNX.4.64.0707140758110.22713@p34.internal.lan>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 00:07:56 +1100
Message-Id: <1190034476.8152.8.camel@traveler>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am experiencing the similar problem on my Acer Aspire 5000 laptop -
once in a while a bunch of "APIC error on CPU0: 40(40)" messages are
showing up in dmesg.

After few experiments and a lot of googling, I identified a cause - it
was my built-in wireless card! Disabling IO-APIC helped, besides a
single "Spurious 8259A interrupt: IRQ7" message while booting up there
was nothing unusual.

A did some further experiments on various hardware and from my
experience I can tell that "APIC error" messages are entirely hardware
related.

Regards,
Konstantin

On Sat, 2007-07-14 at 08:09 -0400, Justin Piszcz wrote:
> I have an older MSI motherboard and when I enable the following option:
> 
> >From lshw:
>         description: Motherboard
>         product: MS-6730
> 
> [*]   IO-APIC support on uniprocessors
> 
> I get the following errors in dmesg:
> 
> [  247.177372] APIC error on CPU0: 00(40)
> [  247.556741] APIC error on CPU0: 40(40)
> [  262.010412] APIC error on CPU0: 40(40)
> [  262.765553] APIC error on CPU0: 40(40)
> [  263.876481] APIC error on CPU0: 40(40)
> [  264.191962] APIC error on CPU0: 40(40)
> [  265.040566] APIC error on CPU0: 40(40)
> [  267.959689] APIC error on CPU0: 40(40)
> [  269.446029] APIC error on CPU0: 40(40)
> [  269.853344] APIC error on CPU0: 40(40)
> [  271.122825] APIC error on CPU0: 40(40)
> [  271.287051] APIC error on CPU0: 40(40)
> [  273.825237] APIC error on CPU0: 40(40)
> [  274.373737] APIC error on CPU0: 40(40)
> [  275.355775] APIC error on CPU0: 40(40)
> [  275.982087] APIC error on CPU0: 40(40)
> [  276.101181] APIC error on CPU0: 40(40)
> [  276.173611] APIC error on CPU0: 40(40)
> [  276.970970] APIC error on CPU0: 40(40)
> [  277.561575] APIC error on CPU0: 40(40)
> [  278.694486] APIC error on CPU0: 40(40)
> [  279.353573] APIC error on CPU0: 40(40)
> [  281.779398] APIC error on CPU0: 40(40)
> [  283.625457] APIC error on CPU0: 40(40)
> [  284.749322] APIC error on CPU0: 40(40)
> [  284.983013] APIC error on CPU0: 40(40)
> [  285.126394] APIC error on CPU0: 40(40)
> 
> I normally do not use this option (which also gets rid of the errors*1), 
> but I am curious, why do these errors occur?  I remember them with the early
> 2.6.x series and they are still re-occurring in 2.6.22.1.
> 
> The weird part-- is when IO-APIC is disabled, I see this on boot:
> 
> IO-APIC DISABLED:
> 
> [   46.902712] XFS mounting filesystem md0
> [   47.017322] spurious 8259A interrupt: IRQ7.
> [   47.273009] Ending clean XFS mount for filesystem: md0
> 
> IO-APIC ENABLED:
> 
> [   46.851012] XFS mounting filesystem md0
> [   47.103066] Ending clean XFS mount for filesystem: md0
> 
> * 1 Anytime I see a spurious interrupt on (usually older hardware) 
> especially during file I/O this usually means corruption (from what I 
> have seen) that is why I don't really want to trust anything on this host.
> 
> Anyone have any idea what's going on here?
> 
> Justin.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

