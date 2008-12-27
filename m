Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYL0ISc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYL0ISc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 03:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYL0ISX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 03:18:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYL0ISW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 03:18:22 -0500
Date: Sat, 27 Dec 2008 09:17:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [PATCH] kgdb: more barrier in blank weak function
Message-ID: <20081227081737.GA26218@elte.hu>
References: <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <4955B782.3030407@kernel.org> <4955B7EC.7050002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4955B7EC.7050002@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix panic possible panic etc
> 
> some compiler seems to inline the weak global function if no line in it

>  kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
>  {
> -	return;
> +	barrier();
>  }

>  void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
>  {
> +	barrier();
>  }

seems like the barrier() is not enough - the only safe sequence seems to 
be to turn it into a function that returns an integer.

	Ingo
