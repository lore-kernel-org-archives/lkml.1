Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYJULf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYJULf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYJULfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:35:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39071 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYJULfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:35:15 -0400
Date: Tue, 21 Oct 2008 13:34:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David John <davidjon@xenontk.org>
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [PATCH v5] HPET: Remove the BKL.
Message-ID: <20081021113456.GA14529@elte.hu>
References: <1224568707-2361-1-git-send-email-davidjon@xenontk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224568707-2361-1-git-send-email-davidjon@xenontk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David John <davidjon@xenontk.org> wrote:

> Remove calls to the BKL as concurrent access is protected
> by the spinlock hpet_lock.
> 
> Signed-off-by: David John <davidjon@xenontk.org>
> ---
>  drivers/char/hpet.c |   41 ++++++++++++++++++++++++-----------------
>  1 files changed, 24 insertions(+), 17 deletions(-)

this patch still needs to add locking documentation commits to hpet.c, 
which shows that you considered all the locking changes that happen due 
to dropping the BKL. Most of this code runs very rarely so there's 
little chance that races will be caught in practice in any debuggable 
manner.

	Ingo
