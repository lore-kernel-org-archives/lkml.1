Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYF3GfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYF3GfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYF3Gex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:34:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:20356 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYF3Gew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iG1pGd1rPb3YmEYXyaKAiVOInBl/BiLugm92Tqs1FKXcZ+oATdEpQaHU+1D0ec/H6X
         IMYDc+/8T/WPZ5Rs34hhkaAmMAmMgorDXaTr4FLOfcrRs3KVS6qr7gZuTu+JuiYRbNar
         1lJ+8PpIGaSUKGpgNqzRIQYLpg0ufdBccBPXQ=
Message-ID: <ca0148c30806292334ka5a1f24sa9f880008033589d@mail.gmail.com>
Date: Mon, 30 Jun 2008 09:34:50 +0300
From: "Matti Linnanvuori" <mattilinn@gmail.com>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: [patch] x86: add compilation checks to pci_unmap_ macros
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0806291450170.6280@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca0148c30806282322u51cf8ecct700f442466b58ee4@mail.gmail.com>
	 <alpine.LNX.1.10.0806291450170.6280@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/29 Jan Engelhardt <jengelh@medozas.de>:
>
> On Sunday 2008-06-29 08:22, Matti Linnanvuori wrote:
>>+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)     dma_addr_t ADDR_NAME[0];
>>+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)       unsigned LEN_NAME[0];
>>+#define pci_unmap_addr(PTR, ADDR_NAME)        sizeof((PTR)->ADDR_NAME)
>>+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
>>+      do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
>
> Mh. If addr_name happens to be non-0 for some reason (like, a typo),
> then this just introduces a lockup.
> (Better to have a no-op with a typo than a sudden lockup.

No, it does not lock up because there is a break statement in the do block.

> Given
> that these are no-ops means they are deprecated, is not it the case?)

I don't think they are deprecated. There is no text about the
deprecation in kernel documents.
