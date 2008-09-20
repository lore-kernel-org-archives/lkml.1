Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbYITGMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbYITGMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 02:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbYITGMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 02:12:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYITGMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 02:12:01 -0400
Date: Sat, 20 Sep 2008 08:11:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Giacomo A. Catenazzi" <cate@debian.org>
Cc: Peter Oruba <peter.oruba@amd.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to
	microcode_intel.c.
Message-ID: <20080920061145.GD25713@elte.hu>
References: <20080728164411.490752571@amd.com> <20080728164448.492961653@amd.com> <20080907120823.59f8fa47@infradead.org> <48CA586C.2010104@amd.com> <20080912063517.783b7f85@infradead.org> <48D3942B.1050901@amd.com> <b647ffbd0809190537w18cc4d5fo4ce1a9c0390405d9@mail.gmail.com> <48D3A1FD.7010309@debian.org> <48D3A338.5070400@amd.com> <48D3AEB5.1000007@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D3AEB5.1000007@debian.org>
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


* Giacomo A. Catenazzi <cate@debian.org> wrote:

>> That sounds like a single-module solution would be the best way to 
>> go. All dependencies would then be handled inside the module.
>
> Single module probably is more difficult to maintain.

why? In this case we have just two relevant CPU microcode drivers - and 
we dont expect their number to grow significantly. So it should be 
perfectly clean to link everything into a single module.

In fact as this example has shown it a single-module solution has 
numerous advantages, as it simplifies userspace interactions.

Taken to the extreme, a single-image (bzImage) kernel has many 
advantages over a many-modules kernel as well. So we only want to 
modularize when we absolutely have to, and this is not one of those 
cases.

	Ingo
