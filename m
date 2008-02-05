Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYBEQJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYBEQJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYBEQJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:09:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbYBEQJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:09:32 -0500
Date: Tue, 5 Feb 2008 17:09:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205160913.GB28812@elte.hu>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <20080205160214.GD24331@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205160214.GD24331@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > brk: check the lower bound properly
> > 
> > There is a check in sys_brk(), that tries to make sure that we do not 
> > underflow the area that is dedicated to brk heap.
> > 
> > The check is however wrong, as it assumes that brk area starts immediately 
> > after the end of the code (+bss), which is wrong for example in 
> > environments with randomized brk start. The proper way is to check whether 
> > the address is not below the start_brk address.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> ACK.

actually, does the patch above from Jiri solve the problem with your 11 
year old binaries too? (Sorry if it has been mentioned elsewhere, i 
could not decode it from this thread.)

	Ingo
