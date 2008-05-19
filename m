Return-Path: <linux-kernel-owner+w=401wt.eu-S1761712AbYESNi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761712AbYESNi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762169AbYESNXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:23:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762162AbYESNXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:23:12 -0400
Date: Mon, 19 May 2008 15:22:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
Message-ID: <20080519132250.GA20793@elte.hu>
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <20080519130151.GE13546@elte.hu> <48317E2B.2030304@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48317E2B.2030304@qumranet.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Avi Kivity <avi@qumranet.com> wrote:

>> i'd suggest to add an ARCH_ILLEGAL_POINTER define instead, which 
>> defaults to zero and gets added to pointer-ish poison values. That 
>> makes it both simpler and also it does not need any include/asm 
>> changes because ARCH_ILLEGAL_POINTER can be set from the Kconfig 
>> space.
>
> Right.
>
> How much unmapped space do we have on i386 or other archs?  The deltas 
> added to ARCH_ILLEGAL_POINTER will have to be limited to that.

can we get away with having the offset default to zero, and all poison 
values remain unchanged if that? Then 64-bit x86 could just set the 
offset to 2^63 and we wont have to worry about 32-bit x86 at all ...

i.e. start small with this and only have an effect on 64-bit x86.

	Ingo
