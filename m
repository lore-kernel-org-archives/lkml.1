Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZHYW3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZHYW3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZHYW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:29:50 -0400
Received: from claw.goop.org ([74.207.240.146]:57264 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187AbZHYW3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:29:50 -0400
Message-ID: <4A9465DE.2030709@goop.org>
Date: Tue, 25 Aug 2009 15:29:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: jeremy@xensource.com, chrisw@sous-sol.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] XEN: enlighten, use uninitialized_var(cx)
References: <1251234044-6943-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1251234044-6943-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 14:00, Jiri Slaby wrote:
> To avoid a wrong compiler warning, use unitialized_var(cx) in
> xen_init_cpuid_mask.
>
> cx needn't be initialized for cpuid when ax is 1.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Chris Wright <chrisw@sous-sol.org>
>   
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> ---
>  arch/x86/xen/enlighten.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index e90540a..5ab75e2 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -202,7 +202,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>  
>  static __init void xen_init_cpuid_mask(void)
>  {
> -	unsigned int ax, bx, cx, dx;
> +	unsigned int ax, bx, uninitialized_var(cx), dx;
>  
>  	cpuid_leaf1_edx_mask =
>  		~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
>   

