Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbYHKLHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbYHKLHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYHKLHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:07:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbYHKLHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:07:42 -0400
Date: Mon, 11 Aug 2008 13:07:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>, Avi Kivity <avi@qumranet.com>,
       Glauber Costa <gcosta@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix shadowed variable warning
Message-ID: <20080811110703.GC6925@elte.hu>
References: <1218322620.24441.8.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218322620.24441.8.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> arch/x86/kernel/pvclock.c:102:6: warning: symbol 'tsc_khz' shadows an earlier one
> include/asm/tsc.h:18:21: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Introduced between next-20080729 and next-20080808
> 
>  arch/x86/kernel/pvclock.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

caused by this commit in the KVM tree:

  commit ba03518948d9af809a44fc1ab43e9e8c1638abaa
  Author: Glauber Costa <gcosta@redhat.com>
  Date:   Mon Jul 28 11:47:52 2008 -0300

    x86: paravirt: factor out cpu_khz to common code

    KVM intends to use paravirt code to calibrate khz. Xen
    current code will do just fine. So as a first step, factor out
    code to pvclock.c.

    Signed-off-by: Glauber Costa <gcosta@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

	Ingo
