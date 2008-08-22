Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYHVLbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYHVLbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 07:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYHVLbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 07:31:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34318 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752562AbYHVLbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 07:31:40 -0400
Date: Fri, 22 Aug 2008 06:31:39 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: silence section mismatch warning - uv_cpu_init
Message-ID: <20080822113139.GA30014@sgi.com>
References: <1219259268-5868-2-git-send-email-marcin.slusarz@gmail.com> <20080821103444.GE19452@elte.hu> <20080821184859.GA5403@joi> <20080822061901.GN14110@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822061901.GN14110@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 08:19:01AM +0200, Ingo Molnar wrote:
> 
> * Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > From: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Subject: [PATCH v2] x86: fix section mismatch warning - uv_cpu_init
> > 
> > WARNING: vmlinux.o(.cpuinit.text+0x3cc4): Section mismatch in reference from the function uv_cpu_init() to the function .init.text:uv_system_init()
> > The function __cpuinit uv_cpu_init() references
> > a function __init uv_system_init().
> > If uv_system_init is only used by uv_cpu_init then
> > annotate uv_system_init with a matching annotation.
> > 
> > uv_system_init was ment to be called only once, so do it from codepath
> > (native_smp_prepare_cpus) which is called once, right before activation
> > of other cpus (smp_init).
> > 
> > Note: old code relied on uv_node_to_blade being initialized to 0,
> > but it'a not initialized from anywhere.
> 
> thanks - applied it to tip/x86/urgent. Jack, any objections?

Looks good. Thanks.

Acked-by: Jack Steiner <steiner@sgi.com>

--- jack
