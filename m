Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZIDFEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZIDFEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbZIDFEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:04:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225AbZIDFEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:04:44 -0400
Date: Fri, 4 Sep 2009 07:04:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fix "no member named 'sect_attrs' of strcut module"
Message-ID: <20090904050428.GB8382@elte.hu>
References: <1252036108-24221-1-git-send-email-wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252036108-24221-1-git-send-email-wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Zhangjin <wuzhangjin@gmail.com> wrote:

> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> The commit(1b364bf438cf337a3818aee77d68c0713f3e1fc4, "module: workaround
> duplicate section names") introduced a condition to avoid null pointer
> reference:
> 
> -       add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
> +       if (mod->sect_attrs)
> +               add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
> 
> but sect_attrs is only defined when CONFIG_KALLSYMS enabled, so this
> patch is need to fix the following error:
> 
> error: 'struct module' has no member named 'sect_attrs'
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

This has been fixed already, see this upstream fix:

  ea6bff3: modules: Fix build error in the !CONFIG_KALLSYMS case

	Ingo
