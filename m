Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYJQHH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYJQHH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 03:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYJQHHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 03:07:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:26395 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYJQHHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 03:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hMWSZpxmDh5eNARVkKBFPY9ZeYmzfBv0t+g/PAMCSOqDkfm6q61C53jctMmEuIpqWe
         lLROY3OD2ijqcyz7Z/f4F5lDCzv4eeHPwpvlEM/Sq6BrkMwO1vmzIURfjXeQZQLPJvNX
         MNgkoY/J75dcAkK7EAIf2sn+8L9yBo2bdxlWU=
Message-ID: <804dabb00810170007hacb0e97rdbd251664bb06de4@mail.gmail.com>
Date: Fri, 17 Oct 2008 15:07:13 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: How to get the PTE pointer for a linear address?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I allocate kernel memory via alloc_page(GFP_KERNEL),  and convert
that struct page pointer to linear address via page_address(), how do
I derive the PTE pointer of that page?

Following the source code, I did the following:

        pgd_t *pgd = pgd_offset_k(address);

        if (pgd_none(*pgd)) {
                printk("no pgd ");
                return 0;
        }
        pud = pud_offset(pgd, address);
        if (pud_none(*pud)) {
                printk("no pud ");
                return 0;
        }
        pmd = pmd_offset(pud, address);
        if (pmd_none(*pmd)) {
                printk("no pmd ");
                return 0;
        }

        pte = pte_offset_map(pmd, address);

===============> and in between here, the PTE pointer is returned
(from pte_offset_map())?   And so the PTE structure (pte_t) should be
*pte?

        pte_unmap(pte);

I suspect something is not right?

Thanks.
-- 
Regards,
Peter Teoh
