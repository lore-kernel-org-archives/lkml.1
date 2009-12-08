Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZLHOau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZLHOau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZLHOat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:30:49 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50071 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZLHOas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:30:48 -0500
X-IronPort-AV: E=Sophos;i="4.47,362,1257138000"; 
   d="scan'208";a="8527542"
Message-ID: <4B1E62ED.1060304@analog.com>
Date: Tue, 8 Dec 2009 22:30:05 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Mike Frysinger <vapier@gentoo.org>, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
References: <4B1E568A.4020005@analog.com> <1259128503-28276-1-git-send-email-vapier@gentoo.org> <7253.1260269873@redhat.com> <9984.1260281967@redhat.com>
In-Reply-To: <9984.1260281967@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2009 14:30:50.0267 (UTC) FILETIME=[0A1A06B0:01CA7813]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2009 10:19 PM, David Howells wrote:
> Jie Zhang<jie.zhang@analog.com>  wrote:
>
>> I agree on using 0 instead of NULL. But for !MMU, I think, vaddr is always as
>> same as addr. So we don't need to pass it?
>
> FRV flushes the vaddr because in MMU mode the cache flush instructions take
> virtual addresses, so if we pass addr as vaddr, I can use the same cache flush
> code for both modes.  I suspect it makes little difference to the amount of
> code if we pass that rather than 0, as the value is already computed, and
> either way, it's going to take one instruction to set up the argument.
>
> Note that Blackfin assumes that it may use the dst address for flushing - an
> assumption that isn't valid in MMU mode with a VIVT cache (which I presume
> Blackfin isn't, but other CPUs are).
>
Thanks for your explanation. Now I understand why passing add as vaddr 
is better.


Jie
