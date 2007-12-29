Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXL2MQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXL2MQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 07:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXL2MQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 07:16:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:37075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbXL2MQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 07:16:14 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Date: Sat, 29 Dec 2007 13:16:07 +0100
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071229093904.GA17390@uranus.ravnborg.org> <20071229095253.GC27360@does.not.exist>
In-Reply-To: <20071229095253.GC27360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712291316.07938.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If -funit-at-a-time really increases stack size too much on some compiler
version the right fix would be to check where it does that using make checkstack
and then add "noinline" attributes there to prevent the compiler from inlining.
That would prevent them.

Globally disabling it is too big a hammer.

e.g. I know XFS did it in a similar way to prevent this problem.

So I would reenable it for now and if you know it causes problems on specific
compiler versions, Adrian, you could watch make checkstack there and submit
noinline patches as needed.

-Andi

