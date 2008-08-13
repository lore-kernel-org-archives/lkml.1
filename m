Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYHMQ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYHMQ6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYHMQ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:58:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbYHMQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:58:39 -0400
Date: Wed, 13 Aug 2008 09:57:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
 0) in kernel_kexec()
In-Reply-To: <1218618760.24951.137.camel@caritas-dev.intel.com>
Message-ID: <alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Huang Ying wrote:
>
> -	xchg(&kexec_lock, 0);
> +	locked = xchg(&kexec_lock, 0);
> +	BUG_ON(!locked);

Why do you want to do this at all? 

And why do you implement your locks with xchg() in the first place? That's 
total and utter crap.

Hint: we have _real_ locking primitives in the kernel.

			Linus
