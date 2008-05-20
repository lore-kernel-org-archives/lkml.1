Return-Path: <linux-kernel-owner+w=401wt.eu-S1765708AbYETMFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765708AbYETMFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYETMEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:04:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54190 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761651AbYETMEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:04:48 -0400
Date: Tue, 20 May 2008 14:04:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
Message-ID: <20080520120431.GA9461@elte.hu>
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <87k5hpgqwa.fsf@basil.nowhere.org> <4832B74F.5040402@qumranet.com> <4832BABA.9040809@firstfloor.org> <4832BB6A.8010809@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4832BB6A.8010809@qumranet.com>
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

> I guess a fixmap would work for this.  But then the offsets added to 
> that page would need to be limited to 4K.

i dont think it's worth going for 32-bit here. On 32-bit the poison 
value gets skewed into hard to recognize values which might make oops 
analysis harder. Lets start small with 64-bit-only - there it's a quite 
plausible change, besides the exponentially larger address space on 
64-bit it might realistically happen that an attacker can control a 
32-bit-is offset but not a full 64-bit offset.

	Ingo
