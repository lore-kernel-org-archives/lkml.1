Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbXJVMqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbXJVMqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXJVMqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:46:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXJVMqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:46:14 -0400
Date: Mon, 22 Oct 2007 14:45:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071022124551.GA7438@elte.hu>
References: <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk> <20071022122504.GL2998@hacking> <20071022124322.GB8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022124322.GB8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ftp.linux.org.uk> wrote:

> in kernel/sched.c
> 
> FWIW, I would simply kill the damn fastcall thing - right now the only 
> user is uml/i386; everything else either has it #defined to nothing or 
> (as i386 does) passes -mregparm=3 while having fastcall expand to 
> __attribute__((regparm(3))) - i.e. has all functions fastcall.
> 
> Do we really need it on uml/i386 enough to keep bothering with that 
> mess?

we should kill it there too.

the only place where we should _please_ keep those annotations are for 
functions that get called from assembly code. This makes life immensely 
easier for -pg (CONFIG_FUNCTION_TRACING) kernels.

	Ingo
