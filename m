Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbZJSXix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbZJSXix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbZJSXiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:38:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045AbZJSXiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:38:51 -0400
Message-ID: <4ADCF88B.9080402@redhat.com>
Date: Tue, 20 Oct 2009 08:38:51 +0900
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v5: allow userspace to adjust kvmclock offset
References: <1255721316-11777-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1255721316-11777-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2009 04:28 AM, Glauber Costa wrote:
> When we migrate a kvm guest that uses pvclock between two hosts, we may
> suffer a large skew. This is because there can be significant differences
> between the monotonic clock of the hosts involved. When a new host with
> a much larger monotonic time starts running the guest, the view of time
> will be significantly impacted.
>
> Situation is much worse when we do the opposite, and migrate to a host with
> a smaller monotonic clock.
>
> This proposed ioctl will allow userspace to inform us what is the monotonic
> clock value in the source host, so we can keep the time skew short, and
> more importantly, never goes backwards. Userspace may also need to trigger
> the current data, since from the first migration onwards, it won't be
> reflected by a simple call to clock_gettime() anymore.
>
> +struct kvm_clock_data {
> +	__u64 clock;
> +	__u64 pad[2];
> +};
> +
>    

The padding is not reusable without a flags word that we can set bits in 
for extended functionality.  Please add one (and a check that it is 
zero, or -EINVAL).

Since it was already applied, please do it as an incremental patch.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

