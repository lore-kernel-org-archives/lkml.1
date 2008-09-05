Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYIERD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYIERD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYIERDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:03:40 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:54435 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbYIERDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bzcnquo8zd2DSpvcLB9UPEKUYngiNVBXY2ebZ6quE+YwsqlhDhxIoRFB4eG7EXi8JZ
         hFsnC4T2vlWqHtjoLox47OtXYuUBs4jNgLCZDUcMv7O3WcvLKL8hWcpZIMO5qs423HpA
         d+GLP4/hQWOdl5ckkLm0aakOb6JqyrbHnzfRY=
Message-ID: <86802c440809051003o6829e7d5i2dd683f5e0dd0ae4@mail.gmail.com>
Date: Fri, 5 Sep 2008 10:03:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] error missed ifndef CONFIG_HAVE_SPARSE_IRQ
Cc: "Dean Nelson" <dcn@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080905144648.GA10292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080905140720.GA9393@sgi.com> <20080905144648.GA10292@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 7:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dean Nelson <dcn@sgi.com> wrote:
>
>> An error return from create_irq_nr() is 0, but an error return from
>> create_irq() is -1.
>>
>> Signed-off-by: Dean Nelson <dcn@sgi.com>
>
> applied to tip/irq/sparseirq - thanks Dean!
>
need to change irq to int too

diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 7c5aef1..468115d 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -109,7 +109,7 @@ int __ht_create_irq(struct pci_dev *dev, int idx,
ht_irq_update_t *update)
        u32 data;
        int max_irq;
        int pos;
-       unsigned int irq;
+       int irq;
        unsigned int irq_want;

        pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
