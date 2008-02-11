Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYBKGm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYBKGm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 01:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYBKGmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 01:42:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:59930 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYBKGmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 01:42:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VOcZa919SaFHD/yjFMuzlL/MhDNmCl/n3xbOTecD4ApNesyjYZivbOuznOKtGuutXfKD+r8hgYslmlOJpbtlpMGI7jLBM7sTief1jQOCm2QFL5REqJlZjTVgMZSiEDReJdynEiSRhuPMhqqFBmnYJ64iGOsPGLIw1kaNVf+dnfs=
Message-ID: <86802c440802102242g2d871a1bwea088eda86be5c9@mail.gmail.com>
Date: Sun, 10 Feb 2008 22:42:14 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: kvm: no hardware support
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I enable vmx and svm option for KVM in .config

on amd SVM enable system

vmx get tried at first

and get
kvm: no hardware support

Calling initcall 0xffffffff80c2d465: vmx_init+0x0/0x119()
kvm: no hardware support
initcall 0xffffffff80c2d465: vmx_init+0x0/0x119() returned -95.
initcall 0xffffffff80c2d465 ran for 2 msecs: vmx_init+0x0/0x119()
initcall at 0xffffffff80c2d465: vmx_init+0x0/0x119(): returned with
error code -95

Calling initcall 0xffffffff80c2d57e: svm_init+0x0/0x13()
initcall 0xffffffff80c2d57e: svm_init+0x0/0x13() returned 0.
initcall 0xffffffff80c2d57e ran for 0 msecs: svm_init+0x0/0x13()

suggest you add .name in ops like "vmx" or "svm"

and that message can become
kvm: no hardware support for vmx
or
kvm: no hardware support for svm

or just remove that line.
        }

        if (!ops->cpu_has_kvm_support()) {
-                printk(KERN_ERR "kvm: no hardware support\n");
                r = -EOPNOTSUPP;
                goto out;
        }


YH
