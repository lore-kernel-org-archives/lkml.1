Return-Path: <linux-kernel-owner+w=401wt.eu-S965080AbXAWONe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbXAWONe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965144AbXAWONe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:13:34 -0500
Received: from thccv19.oz.nthu.edu.tw ([140.114.63.219]:49989 "EHLO
	thccv19.oz.nthu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080AbXAWONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:13:33 -0500
From: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
To: "'Anton Altaparmakov'" <aia21@cam.ac.uk>
Cc: <linux-kernel@vger.kernel.org>
References: <030701c73eef$0b4d0010$0100a8c0@sslabmayasky> <1169557944.4475.8.camel@imp.csi.cam.ac.uk>
Subject: RE: Could convert a buffer that allocated by vmalloc to pages?
Date: Tue, 23 Jan 2007 22:15:33 +0800
Message-ID: <030801c73ef8$f2198a00$0100a8c0@sslabmayasky>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1169557944.4475.8.camel@imp.csi.cam.ac.uk>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: Acc+8Eq4/6ojF8PqSsWNOIpUOvkLWAABmbeQ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,
	Thanks for r your answer.
I tried vmalloc_to_page() and I have some question.
I print the "pages" in vm_struct structure of the buffer to compare the
address get from vmalloc_to_page(), result as follows:

//===source code====
L2cache=vmalloc(L2SIZE);// L2SIZE=40960
printk(KERN_INFO "find_vm_struct OK:%x
addr:%xnr_pages:%d\n",L2vm,L2vm->addr,L2vm->nr_pages);
for(i=0;i<L2vm->nr_pages;i++)
 {
      if(L2vm->pages[i])
         printk("page allocated:%x\n",page_address(L2vm->pages[i]));
 }
tpage=vmalloc_to_page(L2cache);
printk(KERN_INFO "vmalloc_to_page tpage :%x\n",tpage);
//===========info of dmesg==================
[ 1561.768471] page allocated:73d65000
[ 1561.768474] page allocated:781e9000
[ 1561.768476] page allocated:6203f000
[ 1561.768478] page allocated:57fdf000
[ 1561.768481] page allocated:56ed4000
[ 1561.768483] page allocated:56ed5000
[ 1561.768485] page allocated:64ab6000
[ 1561.768488] page allocated:7cc1e000
[ 1561.768490] page allocated:60ea8000
[ 1561.768492] page allocated:60ea9000
[ 1561.768497] vmalloc_to_page tpage :7fcf7e18

Why the page address get from vmalloc_to_page is different with the first
page address of the vm_struct (73d65000)?

THX
-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Anton Altaparmakov
Sent: Tuesday, January 23, 2007 9:12 PM
To: Yu-Chen Wu
Cc: linux-kernel@vger.kernel.org
Subject: Re: Could convert a buffer that allocated by vmalloc to pages?

On Tue, 2007-01-23 at 21:04 +0800, Yu-Chen Wu wrote:
> Hi,
> I write a driver have a big buffer (16MB,allocated by vmalloc).
> I want to use the buffer to do DMA transmission so I need getting the
pages
> of the buffer.
> Have any kernel API can do this?
> My platform is x86_64 and 2GB RAM

vmalloc_to_page()...

See mm/memory.c for the function and how to use it.

Best regards,

        Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

