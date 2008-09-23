Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYIWIcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYIWIcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYIWIcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:32:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbYIWIcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:32:05 -0400
Date: Tue, 23 Sep 2008 10:31:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH] x86: Fix 27-rc crash on vsmp due to paravirt during
	module load
Message-ID: <20080923083145.GD23031@elte.hu>
References: <20080923055847.GA26882@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923055847.GA26882@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> 27-rc fails to boot up if configured to use modules.  Turns out 
> vsmp_patch was marked __init, and vsmp_patch being the pvops 'patch' 
> routine for vsmp, a call to vsmp_patch just turns out to execute a 
> code page with series of 0xcc (POISON_FREE_INITMEM -- int3).  Since 
> apply_paravirt can only be called during init/module load, make 
> vsmp_patch with "__init_or_module"

applied to tip/x86/urgent, thanks Ravikiran!

	Ingo
