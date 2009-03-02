Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZCBXvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZCBXvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbZCBXv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:51:28 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:52753 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZCBXv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:51:28 -0500
Date: Mon, 2 Mar 2009 15:51:20 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090302235120.GF27240@localdomain>
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228094430.GH12095@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 10:44:30AM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> 
>> True, but by how much? 212 bytes, out of 7285943 bytes which 
>> is very very small percentage wise.
>
>How does this eliminate the validity of the patch?
>

It costs 212 bytes to leave is_vsmp_box() to not just be a dummy no-op.
Having is_vsmp_box() detect if the hardware is indeed vSMP, is meaningful even when
CONFIG_VSMP is not turned on.   This is because is_vsmp_box() is used to
tell the kernel, that although the cpus being used are supposed to have TSCs
in sync, they are not really in sync.  This is because
you cannot ensure TSCs won't drift between multiple boards being aggregated
on vSMP systems. Take the case of distro kernels.   Distro kernels typically do
not have CONFIG_X86_VSMP on.  Due to the large internode cacheline
setting, CONFIG_VSMP would not be on on the generic distro installer kernels.
If is_vsmp_box() is a no-op, the generic distro installer kernels will
assume TSCs to be synched, which is bad.  Hence, it will be nice if, for
the cost of 212 bytes, vsmp64.o be compiled either unconditionally, OR
conditionally for 64bit architectures only.  The question is, is 212 bytes out
of 7285943 bytes too expensive for the generic kernels?  I hope not.

Thanks,
Kiran
