Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYJGQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYJGQC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYJGQCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:02:21 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:40054 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752764AbYJGQCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:02:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H8LI31oe0gCyDAYl90yzf8VyEznadjHRJpfiMDkPcGVNwRBgm7iLeRkDyiXg6jhGnadIqEzq1Dbkj1//RG/DghZ6imKdwdmrTtWkU+mZinvxqFXIQ6xt3IdOZUBiiYSrhlEanc96DVdR5IQGSWKcd9UnikNKobx2IEGqIk3H0Pw=  ;
X-YMail-OSG: OBkHrvgVM1m8xwUyU5__WGXpues95RUrxyPA8JB5A0MHIQSC2_zT92zRWPZwsD47Ui201FDSiT9vW0RniAmoJPoENoRq7IInDonwcwUQcZsczrrZ4uzRtLz.N4NOYJP9_tz1S2LDoFGYIeYiJDKLpeDAbT92ow--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Thiago Lacerda" <thiagotbl@gmail.com>
Subject: Re: Questions about mmap
Date: Wed, 8 Oct 2008 03:02:11 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Stefan Richter" <stefanr@s5r6.in-berlin.de>
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com> <3fedcc3b0810070638u60681b6do8a7e94c4919f4a40@mail.gmail.com> <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com>
In-Reply-To: <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080302.11618.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 00:40, Thiago Lacerda wrote:
> Thank you Stefan.... by I'd something more concrete.
>
> I'm trying to do like this:
>
> //Code of the char device
> unsigned int **test;
> static int device_mmap(struct file *filp, struct vm_area_struct *vma) {
>       printk(KERN_INFO"Calling mmap\n");
>       vma->vm_flags |= VM_LOCKED;
>       if(remap_pfn_range(vma, vma->vm_start,
> virt_to_phys((void*)((unsigned long)test)) >> PAGE_SHIFT, vma->vm_end
> - vma->vm_start, PAGE_SHARED))

I guess it is more usual to use vma->vm_page_prot for the last argument.
Unless you really specifically want to override it.

>                 return -EAGAIN;
>       printk(KERN_INFO"mmap returned\n");
>       return 0;
> }
>
> static int __init testeInit(void) {
> /* after creating char device and registering it*/
> ...
> ....
> test = (unsigned int**) kmalloc(sizeof(unsigned int*)*1024, GFP_KERNEL);
> int i;
> for(i = 0; i < 1024; i++)
>      test[i] = NULL;
>
> unsigned int* temp1 = (unsigned int*) kmalloc(sizeof(unsigned int),
> GFP_KERNEL); (*temp1) = 9;
> test[0] = temp1;
> return 0;
> }

The idea seems strange because the userspace program will never be able
to dereference these pointers.


> and at user program:
>
> int main() {
>     int fd;
>
>     unsigned int **mptr;
>     size_t size = 1024*sizeof(unsigned int*);
>     fd = open("/dev/myDev", O_RDWR);
>     if( fd == -1) {
>         printf("open error...\n");
>         exit(0);
>     }
>
>     mptr = mmap(0, sizeof(unsigned int*)*1024, PROT_READ | PROT_WRITE,
> MAP_FILE | MAP_SHARED, fd, 0);
>     if(mptr == MAP_FAILED) {
>         printf("mmap() failed\n");
>         exit(1);
>     }
>     printf("teste[0]: %u\n", *mptr[0]);
>     munmap(mptr, size);
>     close(fd);
>     return 0;
> }
>
> It's not working, could you tell me what am I doing wrong? It is for
> my undergraduate thesis ans it is really driving me mad.
>
> I hope that you can help me.

What is not working? What is failing or going wrong for you?
Can't really help without knowing that.
