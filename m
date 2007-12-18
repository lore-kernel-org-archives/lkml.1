Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXLRHhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXLRHhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXLRHhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:37:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:59189 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXLRHhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:37:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,179,1196668800"; 
   d="scan'208";a="344005234"
Subject: Re: [PATCH -mm -v3] x86 boot : export boot_params via sysfs
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>,
       akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1abo8d3jk.fsf@ebiederm.dsl.xmission.com>
References: <1197620206.12999.12.camel@caritas-dev.intel.com>
	 <20071214155228.GA13342@kroah.com> <4762C78D.9080107@zytor.com>
	 <4762D2CC.1030109@zytor.com>  <m1abo8d3jk.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Dec 2007 15:29:34 +0800
Message-Id: <1197962974.12999.29.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 18 Dec 2007 07:29:40.0355 (UTC) FILETIME=[C039B530:01C84147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 21:34 -0700, Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > This is directly analogous to how we treat identity information in IDE, or PCI
> > configuration space -- some fields are pre-digested, but the entire raw
> > information is also available.
> 
> Add to that a totally unchanged value can just be easier to get correct.
> 
> Still the kexec code as much as it can should not look there, as we may
> get the same basic information in a couple of different ways.
> 
> EFI memmap vs. e820 for example.  If/when that is the case /sbin/kexec
> should get the information and spit it out into whatever format makes
> sense for the destination kernel.  My sense is just passing through
> values is brittleness where we don't want it.
> 
> However I think being able to get at the raw boot information overall
> sounds useful.  I just don't know if it is generally useful or just
> useful when debugging bootloaders though.

If struct boot_params as a whole is useless for kexec, I can move it to
debugfs, because kexec is the only normal user now. Then which fields of
struct boot_params do you think is useful for kexec?

Refer to include/asm-x86/bootparam.h

edid_info?
e820_entries and e820_map?	maybe useful for kdump
edd related fields (eddbuf, edd_mbr_sig_buffer, etc)? split fields until fundamental types?

Best Regards,
Huang Ying

