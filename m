Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0BRBdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:33:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41848 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab0BRBdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:33:39 -0500
Message-ID: <4B7C98B9.1090903@zytor.com>
Date: Wed, 17 Feb 2010 17:32:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 34/35] x86: use num_processors for possible cpus
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org> <1265793639-15071-35-git-send-email-yinghai@kernel.org>
In-Reply-To: <1265793639-15071-35-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 01:20 AM, Yinghai Lu wrote:
> some systems that have disable cpus entries because same
>   BIOS will support 2 sockets and 4 sockets and more at
>   same time, BIOS just leave some disable entries, but
>   those system do not support cpu hotplug. we don't need
>   treat disabled_cpus as hotplug cpus.
> so we can make nr_cpu_ids smaller and save more space
>   (pcpu data allocations), and could make some systems run
>   with logical flat instead of physical flat apic mode
> 
> -v2: change to black list instead
> -v3: just remove that, and the one use possible_cpus= directly.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I'm confused by this one.  This would seem to mean that unless you're
specifying possible_cpus= then you are not treating anything as
hotpluggable.

This is clearly wrong, and it would appear to go the wrong direction in
terms of what is safe.

What am I missing here?

	-hpa
