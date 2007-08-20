Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbXHTPYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbXHTPYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759216AbXHTPYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:24:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:23959 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759173AbXHTPYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Zldqll3KUGsOUoeh4Ld05o6DOUhMBiaM+nUzEkCns8x2N1sERMyPS16p5+FjpZwZOKLk3Mp+rKA0sBXB4usjLQeCnQhWrJa9R1PFDqHD5Nxb+F2fPRF5J2aGjZkE/xs2acScYkJk/ZigJSHT+tsbTJL7oGDKp3O0ZMUOgYIbEqU=
Message-ID: <76391b770708200824x22bea9e5me0b721257ff903d8@mail.gmail.com>
Date: Mon, 20 Aug 2007 23:24:38 +0800
From: "liang yuanen" <linux.kernel.liang@gmail.com>
To: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: code read question
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in 2.4.20 code, in comment say this clear BSS, i think this not only
clear the BSS and set other data ,them are not belong to BSS, such as
.data.init_task to zero

in file arch/i386/boot/compressed/head.S
/*
 * Clear BSS		
 */
	xorl %eax,%eax
	movl $ SYMBOL_NAME(_edata),%edi
	movl $ SYMBOL_NAME(_end),%ecx
	subl %edi,%ecx
	cld
	rep
	stosb

in file \arch\i386\vmlinux.lds

_edata = .;			/* End of data section */

  . = ALIGN(8192);		/* init_task */
  .data.init_task : { *(.data.init_task) }

  . = ALIGN(4096);		/* Init code and data */
  __init_begin = .;
  .text.init : { *(.text.init) }
  .data.init : { *(.data.init) }
  . = ALIGN(16);
  __setup_start = .;
  .setup.init : { *(.setup.init) }
  __setup_end = .;
  __initcall_start = .;
  .initcall.init : { *(.initcall.init) }
  __initcall_end = .;
  . = ALIGN(4096);
  __init_end = .;

  . = ALIGN(4096);
  .data.page_aligned : { *(.data.idt) }

  . = ALIGN(32);
  .data.cacheline_aligned : { *(.data.cacheline_aligned) }

  __bss_start = .;		/* BSS */
  .bss : {
	*(.bss)
	}
  _end = . ;


is it right?
