Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYHUKfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYHUKfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYHUKe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:34:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40135 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbYHUKe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:34:57 -0400
Date: Thu, 21 Aug 2008 12:34:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH] x86: silence section mismatch warning - uv_cpu_init
Message-ID: <20080821103444.GE19452@elte.hu>
References: <1219259268-5868-2-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219259268-5868-2-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> WARNING: vmlinux.o(.cpuinit.text+0x3cc4): Section mismatch in reference from the function uv_cpu_init() to the function .init.text:uv_system_init()
> The function __cpuinit uv_cpu_init() references
> a function __init uv_system_init().
> If uv_system_init is only used by uv_cpu_init then
> annotate uv_system_init with a matching annotation.
> 
> uv_system_init was ment to be called only once, so make explicit by 
> creating properly-named function and annotate it as __ref.
> 
> Old code relied on uv_node_to_blade being initialized to 0, but it'a 
> not initialized from anywhere and it's not static either.

this needs a proper fix as the patch is too ugly. If something should be 
called only once then it has to go into a codepath that will only 
initialize it once.

	Ingo
