Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZKJA0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZKJA0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZKJA0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:26:21 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19424 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZKJA0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:26:20 -0500
Message-ID: <4AF8B31C.5030802@caviumnetworks.com>
Date: Mon, 09 Nov 2009 16:26:04 -0800
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
Subject: Re: [PATCH v7 04/17] tracing: add static function tracer support
 for MIPS
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com> <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com> <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com> <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 00:26:07.0438 (UTC) FILETIME=[65370EE0:01CA619C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:

>  
> +ifndef CONFIG_FUNCTION_TRACER
>  cflags-y := -ffunction-sections
> +else
> +cflags-y := -mlong-calls
> +endif
>  cflags-y += $(call cc-option, -mno-check-zero-division)
>  

That doesn't make sense to me.  Modules are already compiled with 
-mlong-calls.  The only time you would need the entire kernel compiled 
with -mlong-calls is if the tracer were in a module.  The logic here 
doesn't seem to reflect that.

David Daney
