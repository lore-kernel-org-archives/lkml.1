Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbXGaI4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbXGaI4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXGaIzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:55:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:50214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbXGaIzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,202,1183359600"; 
   d="scan'208";a="274696129"
Subject: Re: [PATCH 0/5] x86_64 EFI support -v3
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1bqdtus0w.fsf@ebiederm.dsl.xmission.com>
References: <1185851569.23149.25.camel@caritas-dev.intel.com>
	 <m1bqdtus0w.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 16:55:27 +0800
Message-Id: <1185872127.23149.81.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 08:55:38.0164 (UTC) FILETIME=[90AFE740:01C7D350]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 22:16 -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> > - The variable efi_enabled is used throughout across architecutres if
> >  CONFIG_EFI option is enabled. The i386 code also uses this variable.
> >  This is something that can be revisited with code consolidation
> >  across architectures.
> 
> Fix it first. arch/i386/ efi support is horrible, and show what happens
> when things are not done properly the first time.  Later doesn't happen.
> With the partvirt logic we have a lot of operations properly split out
> already.  Figure out how to use them.

What do you suggest to use instead of efi_enabled?

Current method is (efi_enabled based):

(1) Encapsulate EFI based implementation and legacy BIOS based
implementation into separate functions.
(2) Define a wrapper function for each interface in (1), efi_enabled is
used to choose implementation between EFI and legacy BIOS.

Another possible method is (function pointer based):

1. Encapsulate EFI based implementation and legacy BIOS based
implementation into separate functions.
2. Define a function pointer for each interface in (1), the function
pointer is set to legacy BIOS based implementation by default and
changed to EFI based implementation if appropriate.

Because there are only two possible choice, I think the function pointer
based method has no big advantages over the efi_enabled based method.

Best Regards,
Huang Ying
