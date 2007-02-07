Return-Path: <linux-kernel-owner+w=401wt.eu-S1422628AbXBGSY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422628AbXBGSY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422644AbXBGSYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:24:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:12809 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422628AbXBGSYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:24:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z5yMfe77qs0ot0fbcL4XlsJX760DLuU2shRDitStEND6xBmFszMlsBgyuOSS/sXEf80A0mSlapOanwmqDLb28ljwaHFu2cP91Z1TZHMdsjnS/UCjJIrfCHyQVUXpgffe4kbpggNBHJs91BPCE+ivnjI86Dtq8outIy68MawEADY=
Message-ID: <a8f16e2b0702071024s10625997s1bca1f2f52290c44@mail.gmail.com>
Date: Wed, 7 Feb 2007 21:24:20 +0300
From: Asgard <dubalom@gmail.com>
To: "Martyn Welch" <martyn.welch@radstone.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: alloc_bootmem - Kernel panic
In-Reply-To: <F38DEABE0E171746B133C1ABBD142D9706325502@radmail.Radstone.Local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <F38DEABE0E171746B133C1ABBD142D9706325502@radmail.Radstone.Local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Martyn Welch <martyn.welch@radstone.co.uk> wrote:
>
> Which leads me to the question: what is the best method to reserve a large (~4MB) coherent buffer for DMA transfers?
>

May be you should to use alloc_pages with __GFP_DMA flag, and then use
page_address to get address of first allocated page.

> Is there any way of using alloc_bootmem from a driver (compiled into the kernel) without delving further into kernel code?

yes, i think:

-> (~/devel/learn/src/kernels/linux-2.6.19)
[asgard@midgard]$ find drivers/ -name "*" | xargs grep alloc_bootmem
drivers/char/vt.c:        vc_cons[currcons].d = vc =
alloc_bootmem(sizeof(struct vc_data));
drivers/char/vt.c:        vc->vc_screenbuf = (unsigned short
*)alloc_bootmem(vc->vc_screenbuf_size);
Binary file drivers/char/vt.o matches
Binary file drivers/char/built-in.o matches
Binary file drivers/firmware/dmi_scan.o matches
Binary file drivers/firmware/built-in.o matches
drivers/macintosh/smu.c:    smu = alloc_bootmem(sizeof(struct smu_device));
drivers/s390/char/con3215.c:        req = (struct raw3215_req *)
alloc_bootmem_low(sizeof(struct raw3215_req));
drivers/s390/char/con3215.c:        alloc_bootmem_low(sizeof(struct
raw3215_info));
drivers/s390/char/con3215.c:    raw->buffer = (char *)
alloc_bootmem_low(RAW3215_BUFFER_SIZE);
drivers/s390/char/con3215.c:    raw->inbuf = (char *)
alloc_bootmem_low(RAW3215_INBUF_SIZE);
drivers/s390/char/con3270.c:    condev = (struct con3270 *)
alloc_bootmem_low(sizeof(struct con3270));
drivers/s390/char/con3270.c:    condev->read = raw3270_request_alloc_bootmem(0);
drivers/s390/char/con3270.c:
raw3270_request_alloc_bootmem(CON3270_OUTPUT_BUFFER_SIZE);
drivers/s390/char/con3270.c:    condev->kreset =
raw3270_request_alloc_bootmem(1);
drivers/s390/char/con3270.c:        cbuf = (void *)
alloc_bootmem_low_pages(PAGE_SIZE);
drivers/s390/char/raw3270.c:raw3270_request_alloc_bootmem(size_t size)
drivers/s390/char/raw3270.c:    rq = alloc_bootmem_low(sizeof(struct raw3270));
drivers/s390/char/raw3270.c:        rq->buffer = alloc_bootmem_low(size);
drivers/s390/char/raw3270.c:    rp = (struct raw3270 *)
alloc_bootmem_low(sizeof(struct raw3270));
drivers/s390/char/raw3270.c:    ascebc = (char *) alloc_bootmem(256);
drivers/s390/char/raw3270.h:struct raw3270_request
*raw3270_request_alloc_bootmem(size_t size);
drivers/s390/char/sclp_con.c:        page = alloc_bootmem_low_pages(PAGE_SIZE);
drivers/s390/char/sclp_vt220.c:            page =
alloc_bootmem_low_pages(PAGE_SIZE);
drivers/serial/cpm_uart/cpm_uart_cpm2.c:        mem_addr = alloc_bootmem(memsz);
drivers/video/console/vgacon.c:    vgacon_scrollback =
alloc_bootmem(CONFIG_VGACON_SOFT_SCROLLBACK_SIZE
Binary file drivers/video/console/vgacon.o matches
Binary file drivers/video/console/built-in.o matches
Binary file drivers/video/built-in.o matches
Binary file drivers/built-in.o matches

> Martyn
>
> ________________________________________________________________________
> This e-mail has been scanned for all viruses by Star.The service is powered by MessageLabs.
> ________________________________________________________________________
>
