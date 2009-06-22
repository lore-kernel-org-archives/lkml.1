Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZFVGup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZFVGup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZFVGuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:50:37 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:36315 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZFVGug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:references:in-reply-to:subject:date
         :mime-version:content-type:content-transfer-encoding:x-priority
         :x-msmail-priority:x-mailer:x-mimeole;
        b=LbQ8HrM52l4BBaGi2wE5Eiguh5qSgtyMj3BzcamTXzLQAjMHDPW3IWeTc48KS6UOdR
         vVc4bxJknSQ23u9K1aCc+PImV/d6OGjA5NwcTipf6cmiERwA9Hpia5dldTG/ao0w7GMy
         9pprpuIVtFL7snfDNSI/Af0ioJ6vlqHJRupmY=
Message-ID: <5AA89A0287224699B8E5C0526CE0EA41@Lanx8664>
From: "Jay Lan" <jay.zen.lan@gmail.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "Haren Myneni" <hbabu@us.ibm.com>, <kexec@lists.infradead.org>,
       "Vivek Goyal" <vgoyal@redhat.com>
References: <4A39E247.4030908@jp.fujitsu.com>
In-Reply-To: <4A39E247.4030908@jp.fujitsu.com>
Subject: Re: [PATCH 0/7] Patches for kdump vs. INIT
Date: Sun, 21 Jun 2009 23:31:13 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6002.18005
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6002.18005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kdump with INIT on IPF worked on SGI's IA64 servers when i left SGI last 
December.
Is this problem something new to you after .27?

SGI folks should test this patchset to ensure no surprise is introduced to 
their servers.

Cheers,
jay

----- Original Message ----- 
From: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
To: <linux-ia64@vger.kernel.org>; <linux-kernel@vger.kernel.org>
Cc: "Haren Myneni" <hbabu@us.ibm.com>; <kexec@lists.infradead.org>; "Vivek 
Goyal" <vgoyal@redhat.com>
Sent: Wednesday, June 17, 2009 11:44 PM
Subject: [PATCH 0/7] Patches for kdump vs. INIT


> Hi Tony-san, and kdump folks,
>
> I got some trouble on kdump on IPF with INIT, and my investigation
> proves there are some bugs and races in startup of kdump.
> Here are fixes based on .30, for issues I found.
>
> Since it must be serious problem for (likely big) IPF servers if we
> could fail to retrieve crashdump via kdump, so I believe these patches
> should be applied asap.
>
>
> Thanks,
> H.Seto
>
> ===
>
> Hidetoshi Seto (7):
>      ia64, kdump: Mask MCA/INIT on freezing cpus
>      ia64, kexec: Make INIT safe while kdump/kexec
>      ia64, kexec: Unregister MCA handler before kexec
>      ia64, kdump: Don't offline APs
>      ia64, kdump: Mask INIT first in panic-kdump path
>      ia64, kdump: Try INIT regardless of kdump_on_init
>      ia64, kdump: Short path to freeze CPUs
>
> arch/ia64/kernel/crash.c         |   85 
> ++++++++++++++++++++++++++------------
> arch/ia64/kernel/machine_kexec.c |   17 ++++++++
> arch/ia64/kernel/mca.c           |   15 ++++++-
> arch/ia64/kernel/mca_asm.S       |   47 +++++++++++++++++++++
> 4 files changed, 136 insertions(+), 28 deletions(-)
>
>
>
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 

