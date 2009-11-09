Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZKIWfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZKIWfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZKIWfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:35:23 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16541 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZKIWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:35:22 -0500
Message-ID: <4AF898E9.3050506@caviumnetworks.com>
Date: Mon, 09 Nov 2009 14:34:17 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Zhangjin <wuzhangjin@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       zhangfx@lemote.com, zhouqg@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 17/17] tracing: make function graph tracer work with
 -mmcount-ra-address
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com> <3a9fc9ca02e8e6e9c3c28797a4c084c1f9d91f69.1257779502.git.wuzhangjin@gmail.com> <0cef783a71333ff96a78aaea8961e3b6b5392665.1257779502.git.wuzhangjin@gmail.com> <18e1d617ed824bb1c10f15216f2ed9ed3de78abd.1257779502.git.wuzhangjin@gmail.com> <3da916c1cb6e05445438826f98a91111f43ff6cd.1257779502.git.wuzhangjin@gmail.com> <d4aa4cdb9b4c25e7a683c923bdeabed847bd8010.1257779502.git.wuzhangjin@gmail.com> <451c55dead5d6afd871de6afd14dbbcf70a0f834.1257779502.git.wuzhangjin@gmail.com> <0c463e2af521e613fd15751a9f610c74cf887292.1257779502.git.wuzhangjin@gmail.com> <695747bff7cddb97d6f43c05c4cf05eb269e402d.1257779502.git.wuzhangjin@gmail.com> <406a8e5e3117737e401bb2bba84ad9b17f99857d.1257779502.git.wuzhangjin@gmail.com> <ceef672f082971118c472d1c079d49762ae43b38.1257779502.git.wuzhangjin@gmail.com> <2113f5f0165feac8cf58c156946adff776f9056d.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <2113f5f0165feac8cf58c156946adff776f9056d.1257779502.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Nov 2009 22:34:17.0790 (UTC) FILETIME=[C5F405E0:01CA618C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:
[...]
> +	cflags-y += $(call cc-option, -mmcount-ra-address)
[...]
> +#if (__GNUC__ <= 4 && __GNUC_MINOR__ < 5)



Sprinkling the code with these #if clauses is ugly and prone to breakage 
I think.

The Makefile part is testing for the same feature.

We do a very similar thing with -msym32, and KBUILD_SYM32.  Perhaps you 
could rework this patch in a similar manner and test for 
KBUILD_MCOUNT_RA_ADDRESS instead of the '(__GNUC__ <= 4 && 
__GNUC_MINOR__ < 5)'

David Daney
