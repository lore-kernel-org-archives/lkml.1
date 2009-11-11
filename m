Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZKKOSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZKKOSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZKKOSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:18:10 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:35257 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbZKKOSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:18:10 -0500
Date: Wed, 11 Nov 2009 14:18:15 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 04/17] tracing: add static function tracer support
 for MIPS
In-Reply-To: <1257947513.7308.8.camel@falcon.domain.org>
Message-ID: <alpine.LFD.2.00.0911111413560.10184@eddie.linux-mips.org>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>  <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>  <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com> 
 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>  <4AF8B31C.5030802@caviumnetworks.com>  <1257814817.2822.3.camel@falcon.domain.org>  <4AF99848.9090000@caviumnetworks.com>  <1257907351.2922.37.camel@falcon.domain.org> 
 <alpine.LFD.2.00.0911111309170.10184@eddie.linux-mips.org> <1257947513.7308.8.camel@falcon.domain.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, Wu Zhangjin wrote:

> >  No, register jumps cannot be predicted -- this is where the performance 
> > goes on any serious processor -- the two extra instructions are nothing 
> > compared to that.  OTOH frame pointer calculations are pure arithmetic, so 
> > you only lose time incurred by the instructions themselves.
> 
> Yes, I only mean the -mlong-calls and the original -mno-long-calls with
> -pg.
> 
> The orignal one looks like this:
> 
> move ra, at
> jal _mcount
> 
> The new one with -mlong-calls looks like this:
> 
> lui v1, HI_16BIT_OF_MCOUNT
> addiu v1, v1, LOW_16BIT_OF_MCOUNT
> move ra, at
> jalr v1
> 
> both of them have a "jump" instruciton, so, only two lui, addiu added
> for -mlong-calls ;)
> 
> what about the difference between that "jal _mcount"  and "jalr v1"?

 As I say, the latter cannot be predicted and will incur a stall for any 
decent pipeline.  With the former the target address of the jump can be 
calculated early and the instruction fetch unit can start feeding 
instructions from there into the pipeline even before the jump has reached 
the execution stage.

  Maciej
