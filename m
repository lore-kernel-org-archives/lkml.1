Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYGUKeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYGUKeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbYGUKeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:34:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbYGUKd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:33:59 -0400
Date: Mon, 21 Jul 2008 12:33:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Alan Cox <alan@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [build error] istallion build failure
Message-ID: <20080721103338.GA24049@elte.hu>
References: <48845504.20102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48845504.20102@cn.fujitsu.com>
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


* Wang Chen <wangchen@cn.fujitsu.com> wrote:

> Alan, commit "istallion: use tty_port"(b02f5ad6a3ff5a1ee2a7b8ec6eee338de553b060)
> is guilty.
> 
> drivers/char/istallion.c: In function ‘stli_open’:
> drivers/char/istallion.c:829: error: ‘struct stliport’ has no member named ‘refcount’
> drivers/char/istallion.c: In function ‘stli_close’:
> drivers/char/istallion.c:891: error: ‘struct stliport’ has no member named ‘refcount’

i've triggered it too and bisected it back to:

| a352def21a642133758b868c71bee12ab34ad5c5 is first bad commit
| commit a352def21a642133758b868c71bee12ab34ad5c5
| Author: Alan Cox <alan@redhat.com>
| Date:   Wed Jul 16 21:53:12 2008 +0100
|
|    tty: Ldisc revamp

	Ingo
