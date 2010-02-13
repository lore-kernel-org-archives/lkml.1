Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0BMIRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:17:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45289 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab0BMIRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:17:14 -0500
Message-ID: <4B765FFA.1020505@zytor.com>
Date: Sat, 13 Feb 2010 00:16:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64, rwsem: Avoid store forwarding hazzard in __downgrade_write
References: <1266045183-9563-1-git-send-email-avi@redhat.com>
In-Reply-To: <1266045183-9563-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 11:13 PM, Avi Kivity wrote:
> +#ifndef CONFIG_X86_64
> +		       "i" (-RWSEM_WAITING_BIAS)
> +#else
> +		       "r" (-RWSEM_WAITING_BIAS)
>  #endif
> +		     : "memory", "cc");

Using an "er" constraint here should work on both architectures.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

