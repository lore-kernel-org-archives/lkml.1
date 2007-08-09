Return-Path: <linux-kernel-owner+w=401wt.eu-S964919AbXHIFgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919AbXHIFgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbXHIFgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:36:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:57231 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbXHIFgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Q6MVu0B3Jy/JngH7VB934IF6B2evbgzdtPJ7mGRngVQpd7qpW5WfCtUitD2ERNLJWkXynREX1ObgPNCIF1QEYgE2hcP49Omu8GdMgguuZsklqiPUGjGY4gvrwA/sOnAEKDYBjD45JNaDQ3G0yawPfohOfBdCFpuWOf4ZGG6B0K0=
Message-ID: <4104961b0708082236if0c1199l2bbc468e9d582a08@mail.gmail.com>
Date: Thu, 9 Aug 2007 13:36:45 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question on IS_ERR
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I saw we call IS_ERR(ptr) after executing kthread_run() each time.
But we don't need to call IS_ERR(ptr) after kmalloc().

My understanding is,
the kernel pointer ptr for IS_ERR to check should be page aligned, so
its kernel address should be less than 0xfffff000(or 0xffff ffff ffff
f000, 64bits),

kthread_run returns a struct task_struct pointer,which is always page aligned,
however the pointer returned by kmalloc() might not be page aligned,
so we cannot use IS_ERR to check.

Is my understanding correct?

Thanks
Jason
