Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXKGPG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXKGPG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXKGPGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:06:52 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:4986 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbXKGPGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RQSnvvo7T8reUWg8YlCZFih0WEONAqM0Hy0ycs1faq/DmkCGPhSZD+kH6dP1z6PXlpEoEpODvfg71W9PaqNcBKWFJ1ujBu90F2jb0lNDKTa9GLz5cd46ZVAwnggiIByiedhgH7ocvfNiIHXqby2S+AmdXQjXgByXPBV+wv7kIjk=
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc2 build fails: implicit declaration of function =?utf-8?q?=E2=80=98smp=5Fcall=5Ffunction=5Fmask=27?=
Date: Wed, 7 Nov 2007 16:06:41 +0100
User-Agent: KMail/1.9.7
References: <alpine.LFD.0.999.0711061601180.15101@woody.linux-foundation.org> <20071107095555.GB26962@traven>
In-Reply-To: <20071107095555.GB26962@traven>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711071606.41786.mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 10:55:55 Matthias Kaehlcke wrote:
>
> v2.6.24-rc2 fails to build on my box with the following error:
>
> CC [M]  drivers/kvm/kvm_main.o
> drivers/kvm/kvm_main.c: In function ???kvm_flush_remote_tlbs???:
> drivers/kvm/kvm_main.c:220: error: implicit declaration of function
> ???smp_call_function_mask???
> make[3]: *** [drivers/kvm/kvm_main.o] Error 1
> make[2]: *** [drivers/kvm] Error 2
> make[1]: *** [drivers] Error 2
> make[1]: Leaving directory `/data/kernel/linux-2.6.24-rc2'
> make: *** [debian/stamp-build-kernel] Error 2
>
> the .config file is attached

This patch should fix this error.

Signed-off-by: Miguel Boton <mboton@gmail.com>

Index: linux-2.6.24-rc2/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/kvm/kvm_main.c
+++ linux-2.6.24-rc2/drivers/kvm/kvm_main.c
@@ -217,7 +217,10 @@
 		if (cpu != -1 && cpu != raw_smp_processor_id())
 			cpu_set(cpu, cpus);
 	}
+
+#ifdef CONFIG_SMP
 	smp_call_function_mask(cpus, ack_flush, NULL, 1);
+#endif
 }
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)


-- 
	Miguel Botón
