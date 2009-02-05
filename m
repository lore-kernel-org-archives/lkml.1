Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZBEGbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZBEGbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZBEGbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:31:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:3601 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZBEGbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wcldjz0Apt3jV439OhVApEHNcIVPoOPvCb3DHnyt6HOkN6imc58AtsHDtPSQTHjo/U
         gK0d2VENm6SChRWPuxTeZWwEJdPLckTBAX7TxOysUUwmY7VQMsy5NZOqypGo/kf+NWv4
         N00xLs0dlD5nkTC2FiVidtbhKPbCbKI8czHIo=
Message-ID: <498A87B5.3020808@gmail.com>
Date: Thu, 05 Feb 2009 15:31:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Brian Gerst <brgerst@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 2/3] xen: make direct versions of irq_enable/disable/save/restore
 to common code
References: <4983AC87.5000304@goop.org>
In-Reply-To: <4983AC87.5000304@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeremy Fitzhardinge wrote:
> Now that x86-64 has directly accessible percpu variables, it can also
> implement the direct versions of these operations, which operate on a
> vcpu_info structure directly embedded in the percpu area.
> 
> In fact, the 64-bit versions are more or less identical, and so can be
> shared.  The only two differences are:
> 1. xen_restore_fl_direct takes its argument in eax on 32-bit, and rdi on
> 64-bit.
>    Unfortunately it isn't possible to directly refer to the 2nd lsb of
> rdi directly
>    (as you can with %ah), so the code isn't quite as dense.
> 2. check_events needs to variants to save different registers.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/xen/Makefile     |    3 arch/x86/xen/xen-asm.S    |  140
> +++++++++++++++++++++++++++++++++++++++++++++
> arch/x86/xen/xen-asm.h    |   12 +++
> arch/x86/xen/xen-asm_32.S |  113 ++++--------------------------------
> arch/x86/xen/xen-asm_64.S |  136
> +------------------------------------------
> 5 files changed, 171 insertions(+), 233 deletions(-)
...
> ===================================================================
> --- a/arch/x86/xen/xen-asm_32.S
> +++ b/arch/x86/xen/xen-asm_32.S
> @@ -11,101 +11,28 @@
>     generally too large to inline anyway.
>  */
> 
> -#include <linux/linkage.h>
> -
> -#include <asm/asm-offsets.h>
> +//#include <asm/asm-offsets.h>

Applied without the above addition of //

Thanks.

-- 
tejun
