Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYFXBGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYFXBGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYFXBGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:06:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:36833 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYFXBGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,692,1204531200"; 
   d="scan'208";a="298756094"
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
	via linked list of setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
In-Reply-To: <20080623044813.d2fee3a0.pj@sgi.com>
References: <1213155219.13392.2.camel@caritas-dev.intel.com>
	 <20080618114511.GB28838@elte.hu>
	 <1214200441.25753.5.camel@caritas-dev.intel.com>
	 <20080623015326.bec9a75d.pj@sgi.com>
	 <1214205686.26437.18.camel@caritas-dev.intel.com>
	 <20080623034728.250c6fd1.pj@sgi.com>
	 <1214212441.27182.4.camel@caritas-dev.intel.com>
	 <20080623044813.d2fee3a0.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Jun 2008 09:09:34 +0800
Message-Id: <1214269774.31773.13.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 24 Jun 2008 01:06:03.0960 (UTC) FILETIME=[79754B80:01C8D596]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 04:48 -0500, Paul Jackson wrote:
> Huang wrote:
> > 4. Current EFI memmap based code does not work properly in all
> > situation, for example it can not works with kernel parameter:
> > "memmap=exactmap, memmap=<xxx>, ...", "mem=<xxx>" or "noefi".
> 
> With "noefi" parameter, my EFI memmap based code is not supposed
> to do anything.  The "noefi" parameter asks the kernel to ignore
> any EFI support in the firmware it is booting from.

"noefi" is used to specify that the EFI runtime services should be
disabled in kernel. But the memmap should be complete.

> Could you tell me more what you mean by "does not work properly?"

OK. It is OK for your code with "noefi". The remaining issues:

If "memmap=exactmap memmap=<xxx>" is specified in kernel command line.
The user defined memmap should override that from firmware. But your
code is executed after the user defined memmap is parsed, so the memmap
from firmware will override that from user. This does not conform the
semantics of "memmap=exactmap ...". Same issue for "mem=<xxx>".

Another issue is that the size of E820 memmap required on EFI system
must be two times bigger than that really needed. Because at first the
E820 memmap is filled with the entries from E820 and E820_EXT, then that
from EFI memmap is appended.

Best Regards,
Huang Ying

