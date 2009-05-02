Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbZEBTnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbZEBTnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbZEBTnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:43:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:47079 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZEBTnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:43:23 -0400
In-Reply-To: <20090502001421.GA9342@oksana.dev.rtsoft.ru>
References: <20090502001329.GA11549@oksana.dev.rtsoft.ru> <20090502001421.GA9342@oksana.dev.rtsoft.ru>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <68B2EF73-0FD2-41F9-966B-9A54965AFBA6@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely select CONFIG_FRAME_POINTER
Date: Sat, 2 May 2009 21:48:08 +0200
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch introduces HAVE_NORMAL_FRAME_POINTER Kconfig symbol. When
> defined, the top level Makefile won't add -fno-omit-frame-pointer
> cflag (the flag is useless for PowerPC kernels, and also makes gcc
> generate wrong code).

> +++ b/arch/powerpc/Kconfig

> +	select HAVE_NORMAL_FRAME_POINTER

> +config HAVE_NORMAL_FRAME_POINTER
> +	bool
> +	help
> +	  Architectures should select this symbol if their ABI implies
> +	  having a frame pointer.

I am totally confused what you call a frame pointer here.
None of the relevant PowerPC ABIs have a frame pointer
separate from the stack pointer; the compiler can create
one, of course.  A better config symbol name and help text
would help understand this patch :-)


Segher

