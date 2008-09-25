Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYIYRUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYIYRUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYIYRUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:20:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:25115 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbYIYRUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=P/oF1N8DU0M2dykm0wMzXHPvRiunmB7TH1K0nWBvZQo4/k2LR4LrtXwX/T/3dxyym9
         KAEQdoUMp0775yCNB4fvRnBHGEsDOPOksqQ9G6lvpU6CwtO1voNpAkos7W0Zy03F1T8P
         Z4LhdRLN8P29RAT3jqfy398ctbald+Usu4kTY=
Message-ID: <86802c440809251020h54d1e42ck67b542f17e928bd7@mail.gmail.com>
Date: Thu, 25 Sep 2008 10:20:21 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Len Brown" <lenb@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080925091211.GA4922@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080925084212.GE4519@elte.hu> <20080925091211.GA4922@elte.hu>
X-Google-Sender-Auth: 02af2957d62b8623
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 2:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>> > v2: fix hpet compiling
>
> still bad:
>
> arch/x86/kernel/hpet.c: In function 'hpet_late_init':
> arch/x86/kernel/hpet.c:828: error: 'dev' undeclared (first use in this function)
> arch/x86/kernel/hpet.c:828: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/hpet.c:828: error: for each function it appears in.)
>
> we've got some changes in this area (per cpu hpet).
>

looks there is some merge problem.

Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -467,6 +467,9 @@ static int hpet_setup_irq(struct hpet_de
        irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
        enable_irq(dev->irq);

+       printk(KERN_DEBUG "hpet: %s is using irq %#x aka %d for MSI\n",
+                        dev->name, dev->irq, dev->irq);
+
        return 0;
 }

the change should be in hpet_setup_irq instead of hpet_late_init

the patch can be applied to tip/master cleanly.

YH
