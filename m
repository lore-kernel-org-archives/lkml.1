Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZDKGR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZDKGR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbZDKGQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:16:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:45454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868AbZDKGQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:16:47 -0400
Subject: Re: [tip:tracing/hw-branch-tracing] x86, bts: detect size of DS
 fields
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-bc44fb5f7d3e764ed7698c835a1a0f35aba2eb3d@git.kernel.org>
References: <20090313104218.A30096@sedona.ch.intel.com>
	 <tip-bc44fb5f7d3e764ed7698c835a1a0f35aba2eb3d@git.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 11:45:43 +0530
Message-Id: <1239430543.4418.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Markus,

Here are few sparse warnings due to this patch.
If possible, please run sparse before sending the patch.

On Fri, 2009-03-13 at 11:00 +0000, Markus Metzger wrote:
> Commit-ID:  bc44fb5f7d3e764ed7698c835a1a0f35aba2eb3d
> Gitweb:     http://git.kernel.org/tip/bc44fb5f7d3e764ed7698c835a1a0f35aba2eb3d
> Author:     Markus Metzger <markus.t.metzger@intel.com>
> AuthorDate: Fri, 13 Mar 2009 10:42:18 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 11:57:19 +0100
> 
> x86, bts: detect size of DS fields
> 
> Impact: more robust DS feature enumeration
> 
> Detect the size of the pointer-type fields in the DS area
> configuration via the DTES64 features rather than based on
> the cpuid.
> 
> Rename a variable to denote that size to reflect that it only
> covers the pointer-type fields.
> 
> Add more boot-time diagnostics giving the detected size and
> the sizes of BTS and PEBS records.
> 
> Use the size of the BTS/PEBS record to indicate that the
> respective feature is not available (if the record size is zero).
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> LKML-Reference: <20090313104218.A30096@sedona.ch.intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/ds.c |   84 ++++++++++++++++++++++++++------------------------
>  1 files changed, 44 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
> index 87b67e3..6e5ec67 100644
> --- a/arch/x86/kernel/ds.c
> +++ b/arch/x86/kernel/ds.c
> @@ -441,13 +441,13 @@ enum bts_field {
>  
>  static inline unsigned long bts_get(const char *base, enum bts_field field)
>  {
> -	base += (ds_cfg.sizeof_field * field);
> +	base += (ds_cfg.sizeof_ptr_field * field);

arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment
arch/x86/kernel/ds.c:514:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:514:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:514:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:514:7: error: invalid assignment

>  	return *(unsigned long *)base;
>  }
>  
>  static inline void bts_set(char *base, enum bts_field field, unsigned long val)
>  {
> -	base += (ds_cfg.sizeof_field * field);;
> +	base += (ds_cfg.sizeof_ptr_field * field);;

arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment
arch/x86/kernel/ds.c:520:35: error: incompatible types for operation (*)
arch/x86/kernel/ds.c:520:35:    left side has type unsigned char static [unsigned] [toplevel] sizeof_ptr_field
arch/x86/kernel/ds.c:520:35:    right side has type bad type enum bts_field field
arch/x86/kernel/ds.c:520:7: error: invalid assignment

This warning is due to some old patch:

c2724775 (Markus Metzger  2008-12-11 13:49:59 +0100  548)       memset(out, 0, sizeof(*out));
c2724775 (Markus Metzger  2008-12-11 13:49:59 +0100  549)       if ((bts_get(at, bts_qual) & ~bts_qual_mask) == bts_escape) {

arch/x86/kernel/ds.c:549:19: warning: incorrect type in argument 2 (invalid types)
arch/x86/kernel/ds.c:549:19:    expected bad type enum bts_field field
arch/x86/kernel/ds.c:549:19:    got int

Thanks,
--
JSR

