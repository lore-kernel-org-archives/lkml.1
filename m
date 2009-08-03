Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbZHCPEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbZHCPEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbZHCPEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:04:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35811 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbZHCPEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:04:22 -0400
Message-ID: <4A76FDB2.7080706@redhat.com>
Date: Mon, 03 Aug 2009 18:09:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davidel@xmailserver.org, gleb@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH-RFC 2/2] eventfd: EFD_STATE flag
References: <cover.1248803500.git.mst@redhat.com> <20090728175538.GC21549@redhat.com>
In-Reply-To: <20090728175538.GC21549@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2009 08:55 PM, Michael S. Tsirkin wrote:
> This implements a new EFD_STATE flag for eventfd.
> When set, this flag changes eventfd behaviour in the following way:
> - write simply stores the value written, and is always non-blocking
> - read unblocks when the value written changes, and
>    returns the value written
>
> Motivation: we'd like to use eventfd in qemu to pass interrupts from
> (emulated or assigned) devices to guest. For level interrupts, the
> counter supported currently by eventfd is not a good match: we really
> need to set interrupt to a level, typically 0 or 1, and give the guest
> ability to see the last value written.
>
>
> @@ -31,37 +31,59 @@ struct eventfd_ctx {
>   	 * issue a wakeup.
>   	 */
>   	__u64 count;
> +	/*
> +	 * When EF_STATE flag is set, eventfd behaves differently:
> +	 * value written gets stored in "count", read will copy
> +	 * "count" to "state".
> +	 */
> +	__u64 state;
>   	unsigned int flags;
>   };
>    

Why not write the new value into ->count directly?

-- 
error compiling committee.c: too many arguments to function

