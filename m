Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYIKUIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYIKUIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYIKUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:08:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYIKUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:08:37 -0400
Message-ID: <48C979D3.5000308@zytor.com>
Date: Thu, 11 Sep 2008 13:04:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dean Nelson <dcn@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com>
In-Reply-To: <20080911152304.GA13655@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dean Nelson wrote:
> 
> We (SGI) need somewhere around eight vectors.
> 
> There are two kernel modules, sgi-gru and sgi-xp (in drivers/misc), that
> each need two vectors. And there's the broadcast assist unit (BAU) that is
> involved in tlb shootdown on uv, which currently uses statically reserved
> vector 0xf8 (UV_BAU_MESSAGE -- see uv_bau_init()). I know of a debugger that
> also uses 0xf8 because it was previously available until UV_BAU_MESSAGE came
> along. The BAU would be happy with a dynamically allocated system vector.
> We have a couple of other things in the works that also need vectors.
> 
> All of these eight or so vectors are only meaningful on SGI uv systems.
> 

Are these kernel-internal vectors, or exposed to userspace (i.e. the INT 
instruction works in userspace)?  From what I'm gathering, I think this 
is the former.

There are the occational user who wants fixed user-space addressible 
vectors, effectively as secondary system call entry vectors (lguest is 
the only in-kernel user that I know of); those need to be static and 
non-conflicting, which is kind of difficult.  It seems to me that 
anything else probably should be possible to be dynamic.

	-hpa
