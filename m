Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZKQGOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZKQGOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZKQGOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:14:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39864 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbZKQGOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:14:17 -0500
Date: Tue, 17 Nov 2009 07:13:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, Jim Keniston <jkenisto@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -next 0/3] x86 insn decoder test updates (Re: linux-next:
 Tree for October 29 (x86 posttest))
Message-ID: <20091117061352.GE30852@elte.hu>
References: <20091116230611.5250.86656.stgit@harusame>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116230611.5250.86656.stgit@harusame>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Here are the patches which update x86 instruction decoder build-time 
> test. As Stephen reported on linux-next, sometimes objdump decodes bad 
> instructions as normal. This will cause a false positive result on x86 
> insn decoder test. This patches update the test as below;
>
>  - Show more information with V=1
>  - Show in which symbol the difference places.
>  - Just warning instead of build failure.

yes, -tip testing was showing such build bugs too:

 Error: ffffffff8104aae3:	c5 83 3d 49 80 ee    	lds    0xffffffffee80493d(%rbx),%eax
 Error: objdump says 6 bytes, but insn_get_length() says 3 (attr:0)

it happens with older tools, such as binutils-2.17. Modern binutils 
(2.19) is fine.

We dont want to remove the build error: it helped us fix a number of 
real bugs in the decoder - instead please try to create a make based 
workaround based on binutils, to not run the test with binutils older 
than 2.19 or so.

Thanks,

	Ingo
