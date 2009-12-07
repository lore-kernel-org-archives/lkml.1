Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbZLGDXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbZLGDXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933043AbZLGDXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:23:30 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:1430 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030AbZLGDX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:23:29 -0500
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.47,351,1257138000"; 
   d="scan'208";a="9991160"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Uclinux-dist-devel] [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize program header parsing
Date: Mon, 7 Dec 2009 11:27:40 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA0534B43B@chinexm1.ad.analog.com>
In-Reply-To: <4B19A92A.5030804@analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Uclinux-dist-devel] [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize program header parsing
Thread-Index: Acp1RKC5k8OXJsXTTcKtf20T5swnswBqBZ8A
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org><14959.1259948697@redhat.com> <4B19A92A.5030804@analog.com>
To: "Jie Zhang" <jie.zhang@analog.com>, "David Howells" <dhowells@redhat.com>
CC: <uclinux-dist-devel@blackfin.uclinux.org>,
       "Greg Ungerer" <gerg@uclinux.org>,
       "uClinux development list" <uclinux-dev@uclinux.org>,
       "David McCullough" <davidm@snapgear.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Dec 2009 03:23:33.0260 (UTC) FILETIME=[A7C5D4C0:01CA76EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No. The sram device can not be accessed by any user space application.
The applications can only do malloc/free via system call.

Sonic 

-----Original Message-----
From: uclinux-dist-devel-bounces@blackfin.uclinux.org
[mailto:uclinux-dist-devel-bounces@blackfin.uclinux.org] On Behalf Of
Jie Zhang
Sent: Saturday, December 05, 2009 8:28 AM
To: David Howells
Cc: uclinux-dist-devel@blackfin.uclinux.org; Greg Ungerer; uClinux
development list; David McCullough; linux-kernel@vger.kernel.org
Subject: Re: [Uclinux-dist-devel] [uClinux-dev] [PATCH/RFC] FDPIC: add
hook for arches to customize program header parsing

On 12/05/2009 01:44 AM, David Howells wrote:
> Mike Frysinger<vapier@gentoo.org>  wrote:
>
>> The Blackfin port has custom program header flags/addresses for 
>> automatically loading regions into the dedicated on-chip SRAM.  So 
>> add a hook for ports to leverage.
>
> Now that I've ACK'd this, I feel I'm going to have to NAK it.  I'm not

> against the general concept, but:
>
>> +		do_munmap(mm, *maddr, phdr->p_memsz + *disp);
>
> There needs to be a mapping covering the SRAM region for the purposes 
> of the

Our GDB is still lack of the feature to debug applications using SRAM. 
So this part of code was not got exercised. So if we remove this line,
can this patch got merged?

> debugger.  Do you have a chardev covering the SRAM device?  Perhaps 
> through MTD?
>
Sorry, I don't know the answer to these two questions.


Jie


_______________________________________________
Uclinux-dist-devel mailing list
Uclinux-dist-devel@blackfin.uclinux.org
https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel
