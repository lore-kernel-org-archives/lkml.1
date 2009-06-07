Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZFGJjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZFGJjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZFGJjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:39:02 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:54899 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZFGJjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:39:01 -0400
To: avi@redhat.com
Cc: guillaume.thouvenin@ext.bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4A2B5D0E.20002@redhat.com>
	<200906071638.CIC52145.OFOQHLFSMOJVFt@I-love.SAKURA.ne.jp>
	<4A2B7A79.4060600@redhat.com>
	<200906071747.FFJ57396.MSOOQFVHtFOJLF@I-love.SAKURA.ne.jp>
	<4A2B8201.8050904@redhat.com>
In-Reply-To: <4A2B8201.8050904@redhat.com>
Message-Id: <200906071839.DFB51529.JFHLOFtMFOSVQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 7 Jun 2009 18:39:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> What if you change "rm" in the patch to "m"?
It still fails.

        __asm__ __volatile__ (                      \
            _PRE_EFLAGS("0", "5", "2")              \
            _op _suffix " %4,%1 \n"                 \
            _POST_EFLAGS("0", "5", "2")             \
            : "=m" (_eflags), "+m" (_dstv), "=&r" (_tmp)        \
            : "c" (_clv) , "r" (_srcv), "i" (EFLAGS_MASK)       \
            );
