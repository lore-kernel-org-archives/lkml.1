Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYFWHSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYFWHSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYFWHR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:17:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:30394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYFWHR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:17:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,688,1204531200"; 
   d="scan'208";a="1209736"
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
	via linked list of setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
In-Reply-To: <20080623015326.bec9a75d.pj@sgi.com>
References: <1213155219.13392.2.camel@caritas-dev.intel.com>
	 <20080618114511.GB28838@elte.hu>
	 <1214200441.25753.5.camel@caritas-dev.intel.com>
	 <20080623015326.bec9a75d.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 23 Jun 2008 15:21:26 +0800
Message-Id: <1214205686.26437.18.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 23 Jun 2008 07:17:54.0758 (UTC) FILETIME=[41512660:01C8D501]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 01:53 -0500, Paul Jackson wrote:
> Huang Ying wrote:
> > With this patch, your previous patch:
> > 
> > x86 boot: add code to add BIOS provided EFI memory entries to kernel
> > 
> > is not necessary, so can be reversed.
> > 
> > What do you think about that?
> 
> ... the same thing I thought about it when you asked this question
> last month, in post http://lkml.org/lkml/2008/5/26/307.
> 
> Please see my reply in http://lkml.org/lkml/2008/5/28/59.
> It was lengthy and carefully researched, so I won't repeat
> it here.
> 
> In short, we still need it.  The key kernel routine that adds
> additional EFI entries to the existing E820 map is just 20 or so
> fairly easy lines.  We agree that it doesn't handle some of what your
> more extended work with a linked list of setup data handles (such as
> additional EDD entries), but it does handle additional memory map
> (node) entries using the existing data structure interface between
> the firmware and kernel.

EFI memmap based code versus E820 EXT based code:

1. Copying from EFI memory map to E820 map in kernel is not necessary,
because now it can be done in boot-loader with extended E820 memory map
via linked list of setup data.

2. EFI memmap based code only works when CONFIG_EFI is defined, that is
EFI runtime service is enabled. If you do not want to enable EFI runtime
services, you lose some memory map entries. Considering that kexec does
not support EFI runtime service so far.

3. EFI memmap based code is EFI specific, while E820 EXT based code is
general. It can be used for such as legacy BIOS, LinuxBIOS, kexec, etc.

4. Current EFI memmap based code does not work properly in all
situation, for example it can not works with kernel parameter:
"memmap=exactmap, memmap=<xxx>, ...", "mem=<xxx>" or "noefi".

So, I think it is better to remove "EFI memmap based code".

Best Regards,
Huang Ying

