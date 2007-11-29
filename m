Return-Path: <linux-kernel-owner+w=401wt.eu-S934476AbXK2XG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbXK2XG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbXK2XGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:06:45 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:13462 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbXK2XGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=nOOgtisbzcKDcOav6j69De2TVvrPkBKYjuIYl6zYo78SxEkIziQNymYxq69vtVlonUOJVfi1mGgNEcnrMMsKatXRIWCbhr1tMr53OUe10zrN0jMwTxvqUEtcmx5+dwTgGFI0w+mKxDkOlDHq42KGMQZrekKQywAFINf84sV1Cz8=
Message-ID: <a2e38900711291506l216fe3a0lb5b173939770139a@mail.gmail.com>
Date: Fri, 30 Nov 2007 00:06:42 +0100
From: "Alejandro Homs Puron" <ahoms@users.sourceforge.net>
To: linux-kernel@vger.kernel.org
Subject: alloc_page_vma: should be called from a module? (not exported in x86_64)
Cc: ahoms@esrf.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: ef208a9448a8f2bf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've developed a driver for an image acquisition card, which maps
kernel alloc'ed buffers into user space vma's. We use alloc_page +
remap_pfn_range in the driver mmap file_operation.

After looking at alloc_page_vma, I thought that it might be more
appropiate than alloc_page in this context. However, if CONFIG_NUMA=y
(x86_64), this function is not visible to modules.

Is this limitation intentional?

We alloc RAM in a page-by-page basis. Is vm_insert_page more
appropiate than remap_pfn_range?

Thanks a lot for your help.

Alejandro
