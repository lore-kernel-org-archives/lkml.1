Return-Path: <linux-kernel-owner+w=401wt.eu-S2993109AbXCIKgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993109AbXCIKgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993110AbXCIKgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:36:18 -0500
Received: from depni.sinp.msu.ru ([213.131.7.21]:51055 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993109AbXCIKgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:36:17 -0500
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
References: <20070309053931.GA10459@waste.org>
	<200703091728.03978.kernel@kolivas.org>
	<20070309075358.GA10394@waste.org>
	<200703091936.47128.kernel@kolivas.org>
	<87slce945h.fsf@depni.sinp.msu.ru>
	<20070309094904.GC2986@holomorphy.com>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Fri, 09 Mar 2007 13:36:15 +0300
In-Reply-To: <20070309094904.GC2986@holomorphy.com> (William Lee Irwin, III's message of "Fri\, 9 Mar 2007 01\:49\:04 -0800")
Message-ID: <87irdasnz4.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III <wli@holomorphy.com> writes:

> On Fri, Mar 09, 2007 at 12:07:06PM +0300, Serge Belyshev wrote:
>> If you see sched_yield() when stracing any 3d program, I suggest you
>> to try this bruteforce workaround, which works fine for me,
>> disable sched_yield():
>
> May I suggest LD_PRELOAD of a library consisting of only a nopped
> sched_yield() function in userspace?
>

Sure. This is definitely clearer way to do. You just need to put
export LD_PRELOAD=/path/to/your/lib.so somewhere early enough.

cat > yield.c << EOF
int sched_yield (void)
{
	return 0;
}
EOF
gcc yield.c -o yield.so -shared -O2 -fPIC -g
