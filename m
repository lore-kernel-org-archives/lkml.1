Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZKIOoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZKIOoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZKIOoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:44:05 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52432 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZKIOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:44:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=YrP1anj1s52MjWaY6mM2NyrKAglHiQESqWyXLsVOXh1liEw+vXetQbvVwkKo5MPtDE
         eNS6wgFT3rjKsNv4ofI5JH5h8Pca+5J5vm606mxITZ7ChLVXubMMsfZLM6tO6tQzS+Ok
         srdoAajWuL6sgvulOSZKWEcoIhcfNEh+TeW/c=
Subject: Re: [PATCH -v5 08/11] tracing: not trace mips_timecounter_init()
 in MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <1257771288.2845.11.camel@frodo>
References: <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
	 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <cover.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
	 <c62985530910251727o23beafcco539870e4b2f84637@mail.gmail.com>
	 <1256550156.5642.148.camel@falcon>  <20091102214351.GI4880@nowhere>
	 <1257741072.3451.27.camel@falcon.domain.org>
	 <1257771288.2845.11.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 09 Nov 2009 22:35:20 +0800
Message-ID: <1257777320.3451.132.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-11-09 at 07:54 -0500, Steven Rostedt wrote:
[...]
> 
> Just do it in the Makefile. We can add __arch_notrace, and then in the
> Makefile define it with the arch.
> 
> ifeq ($(ARCH), MIPS)
> 	CFLAGS_foo.o = -D__arch_notrace=notrace
> endif
> 
> And we can simply define __arch_notrace in a header:
> 
> #ifndef __arch_notrace
> # define __arch_notrace
> #endif
> 
> I much rather uglify the Makefile than the code. 
> 

Seems can not totally avoid the problem mentioned by Frederic, that is
if there are two many functions in the file, and different platforms
care about different functions ;) 

what about Frederic's __time, just replace that __arch_notrace by
__time_notrace, and only consider the time relative functions currently?
Seems this will really make the stuff simpler.

Regards,
	Wu Zhangjin

