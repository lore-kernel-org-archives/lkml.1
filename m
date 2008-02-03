Return-Path: <linux-kernel-owner+w=401wt.eu-S936238AbYBCHHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936238AbYBCHHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYBCHGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:06:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45126 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935984AbYBCHGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:06:44 -0500
Date: Sun, 3 Feb 2008 08:03:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH v2] x86: Add a list for custom page fault handlers.
Message-ID: <20080203070321.GA8293@elte.hu>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi> <1201660102.8837.9.camel@brick> <1201660453.8837.13.camel@brick> <20080130200827.322c4f7d@daedalus.pq.iki.fi> <20080131150746.GB11996@elte.hu> <20080131180253.6c007852@daedalus.pq.iki.fi> <20080131081507.5edcde10@laptopd505.fenrus.org> <20080203085522.2b63e15b@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203085522.2b63e15b@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> I have two reasons why I'd like to let it be a module:
> - it's "broken", the relay buffers are cleared on module unload
> - it's a lot easier to push updated version for testing to people
> 
> Ok, the first one is just a silly excuse, but the second one is to 
> avoid forcing non-developer users to patch their kernels. This is a 
> much needed tool for the Nouveau project even in it's current form.

i dont think this second problem is a practical one: i've test-merged 
mmiotrace two days ago into x86.git and it's holding up very well in my 
testing (it has not caused a single hickup so far). It's nice optional 
debug functionality and i dont see any reason why not to merge it.

a few cleanup requests:

- please make the pagefault callbacks explicit as Arjan has asked

- any reason why it lives in arch/x86/kernel/mmiotrace/? It should be a
  prime-time member of arch/x86/mm/ i think.

- please make it build-in-able, not modules-only.

- [ longer-term: think about integrating pf_in.c with the x86
    emulator/disassembler of KVM. ]

	Ingo
