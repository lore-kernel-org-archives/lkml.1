Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYCTHxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYCTHxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYCTHx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:53:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:30050 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYCTHx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aor31AowhHiAS6mc94UxSc3b+Eeg4f6gpGodi4dqT2tjZUSL0vzcmeNsjSLiICNlHkcvQp3gG1togy+6Y7GfjvjVnyG1AEAKuz7mza/KR6HR3uHENRsh1bPw+hj1BvQJolOT6HB1obGNP2Ela9nUozyhbveKwtJvXcPLLHmw5uk=
Message-ID: <86802c440803200053m1b0928a9q6567d8c619fa7a2f@mail.gmail.com>
Date: Thu, 20 Mar 2008 00:53:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran G Thirumalai" <kiran@scalex86.org>
Subject: Re: [patch 4/4] x86: apic_is_clustered_box to indicate unsynched TSC's on multiboard vSMP systems
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       "Andi Kleen" <ak@suse.de>, shai@scalex86.org
In-Reply-To: <20080320074508.GE9414@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080320073740.GA9414@localdomain>
	 <20080320074508.GE9414@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 12:45 AM, Ravikiran G Thirumalai
<kiran@scalex86.org> wrote:
> Indicate TSCs are unreliable as time sources if the platform is
>  a multi chassi ScaleMP vSMPowered machine.
>
>  Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>
>  Index: linux.git.trees/arch/x86/kernel/apic_64.c
>  ===================================================================
>  --- linux.git.trees.orig/arch/x86/kernel/apic_64.c      2008-03-19 20:42:28.187659497 -0700
>  +++ linux.git.trees/arch/x86/kernel/apic_64.c   2008-03-19 21:24:17.705515003 -0700
>  @@ -1208,7 +1208,7 @@ __cpuinit int apic_is_clustered_box(void
>          * will be [4, 0x23] or [8, 0x27] could be thought to
>          * vsmp box still need checking...
>          */
>  -       if (!is_vsmp_box() && (boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
>  +       if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
>                 return 0;

why?

>
>         bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
>  @@ -1248,6 +1248,12 @@ __cpuinit int apic_is_clustered_box(void
>                         ++zeros;
>         }
>
>  +       /* ScaleMP vSMPowered boxes have one cluster per board and TSCs are
>  +        * not guaranteed to be synced between boards
>  +        */
>  +       if (is_vsmp_box() && clusters > 1)
>  +               return 1;

you still call that for intel box.

YH
