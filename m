Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYFJOYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYFJOYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYFJOX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:23:59 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:56726 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYFJOX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:23:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Date: Tue, 10 Jun 2008 16:23:33 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
In-Reply-To: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101623.34082.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 16:09:37 Miles Lane wrote:
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155


It seems to crash at
 60 extern const struct dma_mapping_ops *dma_ops;
 61 
 62 static inline int dma_mapping_error(dma_addr_t dma_addr)
 63 {
 64         if (dma_ops->mapping_error)
 65                 return dma_ops->mapping_error(dma_addr);
 66 
 67         return (dma_addr == bad_dma_address);
 68 }

because dma_ops is a NULL pointer here.
Can you add a WARN_ON(!dma_ops); at the beginning of the function
inside of include/asm/x86/dma-mapping.h to confirm this?

-- 
Greetings Michael.
