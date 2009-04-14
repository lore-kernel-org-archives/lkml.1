Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZDNNpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZDNNpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZDNNp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:45:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZDNNp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:45:29 -0400
Date: Tue, 14 Apr 2009 15:44:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       serue@us.ibm.com, dave@linux.vnet.ibm.com, orenl@cs.columbia.edu,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090414134420.GC27163@elte.hu>
References: <20090410023207.GA27788@x200.localdomain> <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain> <20090413073925.GB7085@x200.localdomain> <alpine.LFD.2.00.0904131137520.26713@localhost.localdomain> <20090414122906.GA20201@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414122906.GA20201@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Apr 13, 2009 at 11:39:51AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Mon, 13 Apr 2009, Alexey Dobriyan wrote:
> > > 
> > > Well, in OpenVZ everything is in kernel/cpt/ and prefixed with "cpt_"
> > > and "rst_".
> > 
> > So?
> > 
> > We're not merging OpenVZ code _either_.
> 
> This is to give example of other prefixes: cpt_ and rst_
> Are they fine?

Not really. 'rst' can be easily mistaken for 'reset' and neither 
really tells me at a glance what they do. They are also quite 
tongue-twisters.

See my namespace analysis and suggestions from yesterday for a 
proper naming scheme.

The key i believe is to move away from this singular 'the world is 
all about checkpoint and restore', and move it to a IMHO clearer 
state_*() type of naming which really isolates all these kernel 
state save/restore management APIs from other kernel APIs. (See my 
mail from yesterday for details.)

kstate_*() would be another, perhaps even clearer naming scheme. 
I.e.:

  kstate_checkpoint_XYZ()
  kstate_restore_XYZ()
  kstate_collect_XYZ()
  kstate_dump_XYZ()
  kstate_image_XYZ()
  ...

Just _look_ at them - they are expressive at a glance, and 
reasonably short. That is the kind of first-time impression
we need, not a 'wtf?' moment.

I just checked, there's zero hits on "git grep \<kstate_" in the 
kernel, so it's a pristine namespace. IMHO, go wild ...

	Ingo
