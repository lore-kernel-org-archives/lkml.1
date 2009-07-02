Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbZGBROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbZGBROb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZGBROY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:14:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:61603 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZGBROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RWRgG3LQBsdOPbxbJXTMc27VdkXiHA0+MCTlghj0NnVLQ5xGh0NaT/jLYNRQ7j2+dx
         fOOTd9k3N3yRyWe9EsYTqAhrY98nK6XhlRkSUDalQbAyI061F1c+crOj3t7tYjsu0sOR
         bIJwtzmZ/7iUw+tfxPA3iyiYslUdBGGPbntog=
Date: Thu, 2 Jul 2009 21:14:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -tip] x86: Remove useless variable disable_x2apic
Message-ID: <20090702171423.GD5140@lenovo>
References: <1246554239.2242.27.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246554239.2242.27.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jaswinder Singh Rajput - Thu, Jul 02, 2009 at 10:33:59PM +0530]
| 
| setup_nox2apic() is writing 1 to disable_x2apic but no one is reading it.
| 
| Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| ---
|  arch/x86/kernel/apic/apic.c |    2 --
|  1 files changed, 0 insertions(+), 2 deletions(-)
| 
| diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
| index 8c7c042..0a1c283 100644
| --- a/arch/x86/kernel/apic/apic.c
| +++ b/arch/x86/kernel/apic/apic.c
| @@ -140,7 +140,6 @@ int x2apic_mode;
|  #ifdef CONFIG_X86_X2APIC
|  /* x2apic enabled before OS handover */
|  static int x2apic_preenabled;
| -static int disable_x2apic;
|  static __init int setup_nox2apic(char *str)
|  {
|  	if (x2apic_enabled()) {
| @@ -149,7 +148,6 @@ static __init int setup_nox2apic(char *str)
|  		return 0;
|  	}
|  
| -	disable_x2apic = 1;
|  	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
|  	return 0;
|  }
| -- 
| 1.6.2.5
|

yes, at moment we use cpu_has_x2apic mostly.
Ack. But lets CC Suresh to be sure. Maybe
there is something in plans.
 
	-- Cyrill
