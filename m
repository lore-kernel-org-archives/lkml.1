Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbXH3U21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbXH3U21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXH3U2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:28:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38592 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXH3U2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:28:16 -0400
Date: Fri, 31 Aug 2007 02:11:14 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Joe Perches <joe@perches.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial - constify sched.h
In-Reply-To: <Pine.LNX.4.64.0708302120290.24730@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.999.0708310121121.28360@enigma.security.iitk.ac.in>
References: <1188247231.18004.129.camel@localhost> <20070827213323.GA1759@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0708302120290.24730@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Aug 2007, Jan Engelhardt wrote:
> 
> On Aug 28 2007 01:33, Alexey Dobriyan wrote:
> >
> >On Mon, Aug 27, 2007 at 01:40:31PM -0700, Joe Perches wrote:
> >> Add const to some struct task_struct * uses
> >
> >Why, oh, why?
> 
> 
> So that you can actually pass in a const struct task_struct * without having
> to cast it back to [non-const].

... which makes zero sense, because ...

> Why one would have a const struct task_struct * in the first place
> is a different matter.

... exactly.

> But see http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=77adbfbf4cf96fedf9b75bb330704828c187b190

That commit const-ified struct timespec * or struct timeval * arguments,
which made sense because: (1) those functions really did not modify the
passed structs, and, (2) callers that pass in const struct timeval *
or const struct timespec * are indeed plausible (because one can plausibly
have const timeval/timespec structs). As the changelog suggested, those
callers were having to cast away the const qualifier before passing to
these functions to avoid seeing "passing argument discards qualifiers"
warnings. While (1) holds true for the sched.h case here, (2) does not
(and there are no warnings to shut up either).

If one really wants to go about "constifying" the kernel, then I think
there's a lot of _data_ out there that should first be made const-
qualified. xxx_ops function tables, and the like.
