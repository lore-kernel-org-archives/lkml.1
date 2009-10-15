Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZJOGxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZJOGxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZJOGxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZJOGxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:53:17 -0400
Message-ID: <4AD6C679.3000001@redhat.com>
Date: Thu, 15 Oct 2009 15:51:37 +0900
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL RFC] pvclock cleanups and pvclock vsyscall support
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 04:28 AM, Jeremy Fitzhardinge wrote:
> Hi all,
>
> This series contains several things:
>
>   - Unify the separate vdso and vsyscall implementations of vgettimeofday and
>     vgetcpu.  There's at least one bugfix which was only applied to one copy
>     (ignore tcache in vgetcpu was only applied to the vdso version); this
>     should avoid such skews in future.
>
>   - Bug fixes for the Xen and KVM clocksource.read functions to make sure
>     the returned time doesn't regress compared to clocksource.cycle_last.
>     (Probably stable material.)
>
>   - Make sure the pvclock rdtsc is surrounded by appropriate barriers so
>     that it doesn't get speculated to the wrong place with respect to reading
>     the time parameters.  (Probably stable material.)
>
>   - General cleanups of the pvclock algorithm (there's no need to make a local
>     copy of the time parameters before use).
>
>   - Add a new CONFIG_X86_VSYSCALL to control the compilation of vsyscall-related
>     code rather than just using CONFIG_X86_64 - we may want to implement 32-bit
>     vsyscall at some point, and this will make it easier.
>
>   - Add the sched notifier for task migration between CPUs, for use by
>     pvclock vread.
>
>   - Implement a pvclock vread function, so that pvclock-using clocksources can be
>     used by vsyscall/vdso vgettimeofday and vclock_gettime.
>
>   - Use pvclock vread in the Xen clocksource.
>    

Looks good to me.

Acked-by etc.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

