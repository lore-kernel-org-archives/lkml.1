Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbXJQRTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbXJQRTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763640AbXJQRTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:19:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:12082 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762979AbXJQRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nlCsWthIS/D+T6nqHY8h65jtAO1+rMWPFfyI5rw2bRowGI2kWMrUqDHUIX1qpAR+PwVEM23HiS4jPGjnLt2t0Dg+qgNNtFcw8Rq+x9iX24jhQLyB4JMkzR3l6ONZIYG6OCUo9Z33rDGDWyjatELMoZiNZKBPpbtxbxLH09zXhHY=
Message-ID: <12c511ca0710171019t35cb1670k9e1bdcfb3bf99793@mail.gmail.com>
Date: Wed, 17 Oct 2007 10:19:18 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [PATCH 0/3] vmcoreinfo support for dump filtering
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       kexec-ml <kexec@lists.infradead.org>,
       "Neil Horman" <nhorman@redhat.com>, "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Bernhard Walle" <bwalle@suse.de>, "Don Zickus" <dzickus@redhat.com>,
       "Dan Aloni" <da-x@monatomic.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
In-Reply-To: <20070822210838oomichi@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822210838oomichi@mail.jp.nec.com>
X-Google-Sender-Auth: 0027d0f99497328e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch set frees the restriction that makedumpfile users should
> install a vmlinux file (including the debugging information) into
> each system.

This patch went from Andrew to Linus last night, and looks at first
glance to be the reason why the ia64 build is broken this morning
when using the arch/ia64/configs/tiger_defconfig configuration.

Here are the error messages:
arch/ia64/kernel/machine_kexec.c: In function `arch_crash_save_vmcoreinfo':
arch/ia64/kernel/machine_kexec.c:131: error: `pgdat_list' undeclared
(first use in this function)
arch/ia64/kernel/machine_kexec.c:131: error: (Each undeclared
identifier is reported only once
arch/ia64/kernel/machine_kexec.c:131: error: for each function it appears in.)
arch/ia64/kernel/machine_kexec.c:134: error: `node_memblk' undeclared
(first use in this function)
arch/ia64/kernel/machine_kexec.c:135: error: `NR_NODE_MEMBLKS'
undeclared (first use in this function)
arch/ia64/kernel/machine_kexec.c:136: error: invalid application of
`sizeof' to incomplete type `node_memblk_s'
arch/ia64/kernel/machine_kexec.c:137: error: dereferencing pointer to
incomplete type
arch/ia64/kernel/machine_kexec.c:138: error: dereferencing pointer to
incomplete type
make[1]: *** [arch/ia64/kernel/machine_kexec.o] Error 1

-Tony
