Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYKGTRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYKGTRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYKGTRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:17:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:59050 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYKGTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hAjOED2RH8+QfNVQkHOsT5tM3yCQnU/UTiL4Rki2maCq4AnVsQjy2D3F12v3uE5e6Q
         06zGdhIWnLRP7NEvv/DsKNO3RpwiS9AiUFNFzZdmDXBUsnt46nJ4vFVDVOpHZttpfPSl
         CSoZN1m8xBANsAzhbHDITD+VUM3P/r4Smb9Z4=
Date: Fri, 7 Nov 2008 22:20:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Eduard Munteanu <eduard.munteanu@linux360.ro>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
Message-ID: <20081107192029.GA4001@x200.localdomain>
References: <1226084321.11596.37.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226084321.11596.37.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 10:58:41AM -0800, Harvey Harrison wrote:
> --- a/include/linux/kmemtrace.h
> +++ b/include/linux/kmemtrace.h
> @@ -34,7 +34,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
>  		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
>  		   type_id, call_site, (unsigned long) ptr,
>  		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
> -		   (unsigned long) gfp_flags, node);
> +		   (__force unsigned long)gfp_flags, node);

gfp_t is "unsigned int" actually. These casts are bogus.

Subject: How do I printk <type> correctly?

If variable is of Type	use	printk format specifier.
---------------------------------------------------------
		int			%d or %x
		unsigned int		%u or %x
		long			%ld ot %lx
		unsigned long		%lu or %lx
		long long		%lld or %llx
		unsigned long long	%llu or %llx
		size_t			%zu or %zx
		ssize_t			%zd or %zx

Raw pointer value SHOULD be printed with %p.

u64 SHOULD be printed with %llu/%llx, (unsigned long long):

	printk("%llu", (unsigned long long)u64_var);

s64 SHOULD be printed with %lld/%llx, (long long):

	printk("%lld", (long long)s64_var);

If type is dependent on config option (sector_t), use format specifier
of biggest type and explicitly cast to it.

Reminder: sizeof() result is of type size_t.

Thank you for your cooperation.

