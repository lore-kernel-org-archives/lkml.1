Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYISMh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYISMh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYISMht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:37:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:33564 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYISMht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E7i51CUcH6PEFoUCfQio7sVNbzAOVStpb9MuQHa/H54n12sanxxTGpPhN0yAq7Qv2Q
         Z/CfGnPHZvoAyCohGWSwS3r4BKzUWWqi8oxD2N7YoA4RnWKob3k33f1Nhx2dIVNYwiDZ
         06/aO5iUfQTL6YESWeSB2ALNRlIjuZmSn1IJ0=
Message-ID: <b647ffbd0809190537w18cc4d5fo4ce1a9c0390405d9@mail.gmail.com>
Date: Fri, 19 Sep 2008 14:37:48 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to microcode_intel.c.
Cc: "Arjan van de Ven" <arjan@infradead.org>, cate@debian.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48D3942B.1050901@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080728164411.490752571@amd.com>
	 <20080728164448.492961653@amd.com>
	 <20080907120823.59f8fa47@infradead.org> <48CA586C.2010104@amd.com>
	 <20080912063517.783b7f85@infradead.org> <48D3942B.1050901@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/19 Peter Oruba <peter.oruba@amd.com>:
> Some additonal words regarding the current user space issues:
>
> IMHO the most convenient way to update microcode is through the firmware loading
> interface instead of microcode_ctl. This reduces user-space responsibilities to
> loading the correct module at boot time and to place the microcode patch file at
> the right location via package installation. The problems mentioned in this
> thread would then probably disappear as well. What do you guys think?

It'd still require changes for all the setups that currently rely on
the 'microcode_ctl' interface. Moreover, Arjan's setup failed not due
to the 'microcode_ctl' per se but due to the altered kernel module
name. After all, we can't break the established interface this way.

We can either reserve 'microcode' as a legacy name for intel cpus (==
microcode_intel), or maybe we can use request_module() from
microcode.ko to load a proper arch-specific module (I guess, it's not
ok for !KMOD-enabled kernels).


>
> Thanks,
> Peter
>

-- 
Best regards,
Dmitry Adamushko
