Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYKXSOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYKXSOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYKXSOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:14:04 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:54755 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYKXSOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:14:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GVJILwoALJxTlnRhAZX+jnNXGDm9YbW0vaFkBphJqK1wUvRLiSGWHMzrFYj19Mf7A7
         4RUA/iQTiyFIbpbRNxtnH5ThMn1RloFZvEgEAur6qZSis2IH0aHqfSWacnWN9PS7A7rG
         kiRNqEjjCvPcBt3WsSx6b9BK7mreQ/nKMUmq8=
Message-ID: <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com>
Date: Mon, 24 Nov 2008 21:14:01 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@elte.hu,
       venkatesh.pallipadi@intel.com, shaohua.li@intel.com
Subject: Re: 2.6.28-rc6: hpet: object is on stack, but not annotated
In-Reply-To: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Alexander Beregalov <a.beregalov@gmail.com>:
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> ODEBUG: object is on stack, but not annotated
> ------------[ cut here ]------------
> WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2a4/0x352()

Bisected down to 26afe5f2fbf06ea0765aaa316640c4dd472310c0
(x86: HPET_MSI Initialise per-cpu HPET timers)

Revert helps
