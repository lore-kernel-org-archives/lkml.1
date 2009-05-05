Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZEEI6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZEEI6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZEEI6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:58:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50347 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbZEEI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:58:19 -0400
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
From: Andi Kleen <andi@firstfloor.org>
References: <20090504125114.5e391564@chukar>
	<alpine.LFD.2.01.0905041159480.4983@localhost.localdomain>
	<20090504125124.0f469970@infradead.org>
	<m1vdogbows.fsf@fess.ebiederm.org>
	<alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
	<20090505055011.GE31071@waste.org>
Date: Tue, 05 May 2009 10:58:10 +0200
In-Reply-To: <20090505055011.GE31071@waste.org> (Matt Mackall's message of "Tue, 5 May 2009 00:50:11 -0500")
Message-ID: <87my9sncyl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:
>
> Looking forward:
>
> A faster-but-weakened RNG for ASLR (and similar purposes) 

We really need it for the user space interface too, right now
recent glibc drains your entropy pool on every exec, and worse
recent kernels drain it now even with old glibc too. So any
system which doesn't have a active high frequency random number
source (which is most systems) doesn't have much real entropy
left for the applications that really need it.

-Andi (who always thought it was a bad idea to let ASLR weaken
your SSL/SSH session keys)

-- 
ak@linux.intel.com -- Speaking for myself only.
