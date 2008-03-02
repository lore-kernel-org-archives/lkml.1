Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbYCBBk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbYCBBk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 20:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYCBBkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 20:40:19 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:5427 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYCBBkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 20:40:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WIaqZld8K2W48QWMLCyp/ElJSCXCJmLGf7D/sQNHsxEPktIktUviaGQZi5/UKP+3r+K5Tp60kThEbclWKWIzygHgWBF2qyEAYNmcfZbwdxVaB2wtWSbl60JfsQSH/d3DfTY+q/oFdLKF56yEQMmPTcZK1lAIEru/gvdP8k99vAw=
Message-ID: <4306ae870803011740k39d0769cy7fd6413b10146f74@mail.gmail.com>
Date: Sun, 2 Mar 2008 09:40:14 +0800
From: "Gang He" <hegang.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: OOPS: how to hook system_call_table in redhat es5.1 on x86_64 platform
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as you know, Linux kernel (>2.6.18) set some pages read-only, we can
not hook system_call_table directly like before, the new source code
on i386 is

#ifdef CONFIG_DEBUG_RODATA
     // fix kernel perms
    change_page_attr(virt_to_page(syscall_table), 1, PAGE_KERNEL);
    global_flush_tlb();
#endif

    // hook syscall_table, change some system call to your function
   syscall_table[__NR_open] = my_sys_open;

#ifdef CONFIG_DEBUG_RODATA
     // fix kernel perms
    change_page_attr(virt_to_page(syscall_table), 1, PAGE_KERNEL_RO);
    global_flush_tlb();
#endif

but I use the source code above to redhat es5.1 on x86_64, this will
bring Linux crash, who can help me  to hook system_call_table in
redhat es5.1 on x86_64 platform.

Thanks
Gang
