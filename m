Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbZBYLAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbZBYLAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZBYLAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:00:41 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:33151 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbZBYLAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:00:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jXUTB3+oi/i58YK5/Xkf8uvbfsxy97YPKtauYnYTSxhI3CTO9ffFBLm0UgaV7mVC5T
         6fp1CyuF6cPzffAcJ+x9fc7P54Cav5LmerC6PNQtTaPcoBIOc8dZGSnORATUBvmVeQrz
         8mor5gQ77JT6PxpLArzTZjuuy1NPgHcBxYLeg=
Message-ID: <49A524D3.3090408@gmail.com>
Date: Wed, 25 Feb 2009 12:00:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: mingo@redhat.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 1/2] x86_32: summit_32, use BAD_APICID
References: <20090224175518.GA15616@elte.hu> <1235508093-18063-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1235508093-18063-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.2.2009 21:41, Jiri Slaby wrote:
> --- a/arch/x86/kernel/apic/summit_32.c
> +++ b/arch/x86/kernel/apic/summit_32.c
> @@ -303,12 +303,10 @@ static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
>   	int cpu;
>
>   	num_bits_set = cpus_weight(*cpumask);
> -	/* Return id to all */
>   	if (num_bits_set>= nr_cpu_ids)
> -		return 0xFF;
> +		return BAD_APICID;

Actually, wasn't this intended to return all available rather than BAD 
(to which would correspond the comment), but performed in a wrong 
manner? This is old code, any ideas who would know this?

In my opinion the check should be removed completely to allow the code 
go through same-cluster check.

In that case, the callers code is buggy, since it passes online_cpu 
masks even on machines, where apics are not on the same clusters.
