Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbXKGASm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbXKGASm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXKGASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:18:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:21943 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbXKGASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:18:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qxjwBZfHP+ShRH5ZVqdIhs2awdYGS7EXnJUE23k9L9m+2eMWq89SSuuyV5/qGYiJ3h3nXXx4v0HaQk/KkBT8aSy8ADTzHG0MOOJCvY4WjdMg6m7ljsQpqP7irvM7v7QliB7epONo8IRN6KmwhNWBCK5wC+krBGUEk4fjqpiCcmw=
Message-ID: <86802c440711061618j5fdd7fbcv25be9a2065aa31eb@mail.gmail.com>
Date: Tue, 6 Nov 2007 16:18:32 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: pxeboot broken by commit "x86 setup: handle boot loaders which set up the stack incorrectly"
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6b6815c6d5d1dc209701d1661a7a0e09a295db2f
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Oct 25 16:11:33 2007 -0700

    x86 setup: handle boot loaders which set up the stack incorrectly

    Apparently some specific versions of LILO enter the kernel with a
    stack pointer that doesn't match the rest of the segments.  Make our
    best attempt at untangling the resulting mess.

    Signed-off-by: H. Peter Anvin <hpa@zytor.com>


with that commit:

Linux version 2.6.24-rc1-smp-g2655e2ce-dirty
(yhlu@mpk12-office-77-204) (gcc version 4.2.1 (SUSE Linux)) #15 SMP
Tue Nov 6 15:42:01 PST 2007
Command line: console=uart8250,io,0x3f8,9600n8
initrd=kernel.org/mydisk10.3_x86_64.gz rw root=/dev/ram0 debug
apic=debug acpi.debug_level=0x0000000f p

without the commit:
Linux version 2.6.24-rc1-smp-g2655e2ce-dirty
(yhlu@mpk12-office-77-204) (gcc version 4.2.1 (SUSE Linux)) #15 SMP
Tue Nov 6 15:42:01 PST 2007
Command line: console=uart8250,io,0x3f8,9600n8
initrd=kernel.org/mydisk10.3_x86_64.gz rw root=/dev/ram0 debug
apic=debug acpi.debug_level=0x0000000f pci=routeirq ip=dhcp
load_ramdisk=1 ramdisk_size=131072
BOOT_IMAGE=kernel.org/bzImage_2.6.24_k8.7

pxeboot entry:
label k
kernel kernel.org/bzImage_2.6.24_k8.7
append console=uart8250,io,0x3f8,9600n8
initrd=kernel.org/mydisk10.3_x86_64.gz rw root=/dev/ram0 debug
apic=debug acpi.debug_level=0x0000000f pci=routeirq ip=dhcp
load_ramdisk=1 ramdisk_size=131072

YH
