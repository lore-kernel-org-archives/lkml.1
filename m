Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYEMNzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYEMNzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbYEMNzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:55:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:39153 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbYEMNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UumypDVMnlyVU36rA5sG4KpOclE1vzFJEl2+Qq34oB3qqjSZRIVwBaliA/GsS+2qIPKCgAj7XvhH0okdvDFCjXluAm+26gbrCc6FJpQzSG5wEJwmvQbF0iRvlJDRn430aIDOUDuPwjZD6M82BlQ9dZWKp6cJf+WC3do7z8C1nyU=
Message-ID: <7e0dd21a0805130655xd8b1c8ap9a329943e25fe6fb@mail.gmail.com>
Date: Tue, 13 May 2008 15:55:29 +0200
From: "Johann Baudy" <johaahn@gmail.com>
To: hjk@linutronix.de, gregkh@suse.de
Subject: UIO: phys_mem_access_prot() miss?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans, Greg,

I need some help on UIO driver.
I have to add this below workaround (in uio.c) to be able to access
phys memory from user space.
I'm currently using PPC arch.
Am I wrong? or Is it a miss?

static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
{

...
	switch (idev->info->mem[mi].memtype) {
		case UIO_MEM_PHYS:
+       	vma->vm_page_prot = phys_mem_access_prot(filep,
+            idev->info->mem[mi].addr >> PAGE_SHIFT,
+						 vma->vm_end - vma->vm_start,
+						 vma->vm_page_prot);
			return uio_mmap_physical(vma);
		case UIO_MEM_LOGICAL:
...

}

FYI: I've copied those lines from mem char driver in mmap_mem().

Thanks in advance,
Johann
