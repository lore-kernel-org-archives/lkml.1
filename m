Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZDPDz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZDPDz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 23:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZDPDzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 23:55:51 -0400
Received: from thunk.org ([69.25.196.29]:33196 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbZDPDzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 23:55:50 -0400
Date: Wed, 15 Apr 2009 23:55:24 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416035524.GJ21586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>, hpa@zytor.com,
	tglx@linutronix.de, rusty@rustcorp.com.au,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	davej@redhat.com
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net> <20090415224800.GA22425@elte.hu> <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain> <20090416004430.GA22616@elte.hu> <alpine.LFD.2.00.0904151757100.4042@localhost.localdomain> <20090416014642.GA24029@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416014642.GA24029@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 03:46:42AM +0200, Ingo Molnar wrote:
> 
> For similar reasons people have memos, stick-it's and other formal, 
> automated, reflex-alike daily routine measures to make sure they 
> dont forget to do something they all too easily forget otherwise.
...
> This kind of formal measure _forces_ the extraction of this very 
> specific type of summary on all sides of the contribution chain - 
> and it drastically reduced the number of commits i regretted in 
> hindsight.


The question is whether Impact: _works_ in its current form.  I was
came across a recent set of commits sent to you where it was
pathetically obvious that Impact: doesn't really help.  

The patch submitter in question was a non-English speaker.  I've
blacked out the submitter's name, because I'm not trying to call out
that particular person, but rather the assumption that Impact: is
always helpful.  Here's a very clear case where it is not.

I do feel your pain; there are one or two ext4 contributors where I
always have to rewrite their commit logs and comments, and often I end
up staring at the code trying to figure out what the !@#@? they meant.
I used to try to coach them to make better messages, but I've since
given up and just resigned myself to the fact that it's up to me
rewrite the commit logs (and often, the comments in the code, too...)

If we are going to use the Impact: header, there should only be a few
standardized values that it can have, i.e., "clean up", "fix oops",
"fix lock ordering", "fix performance problem", etc.  Otherwise people
will just put garbage in the Impact field --- what the heck does
"Impact: it is not ready yet.  remove it" mean?  

Or "Impact: fix smp_affinity when moving irq_desc"?  

Or worse yet, "Impact: so use dev_to_node"?!?

At least for this particular submitter, the Impact: header clearly is
adding no value, and in fact, I suspect his git commit logs would be
better without trying to force him into filling out a field in what
appears to be a completely random fashion.

	    	   	     	    		 - Ted


x86/irq: remove NUMA_MIGRATIE_IRQ_DESC

Impact: it is not ready yet.  remove it

it causes crash on system with lots of cards with MSI-X
when irq_balancer enabled...

will have one new patch that create irq_desc according to device numa node.

Signed-off-by: XXXXXXX XX <XXXXXXX@XXXXX.XXX>

----------------------------

irq: correct CPUMASKS_OFFSTACK typo -v3

Impact: fix smp_affinity copying when moving irq_desc

CPUMASKS_OFFSTACK is not defined anywhere. it is a typo
and init_allocate_desc_masks called before it set affinity to all cpus...

split init_alloc_desc_masks() into all_desc_masks() and init_desc_masks()
so in the init_copy_desc_masks could use CPUMASK_OFFSTACK there.
aka copy path will not calling init_desc_masks anymore.

also could use that CPUMASK_OFFSTACK in alloc_desc_masks()

v3: update after "remove numa_migrate irq_desc"

Signed-off-by: XXXXXXX XX <XXXXXXX@XXXXX.XXX>
Acked-by: XXXXX XXXXXX <XXXXX@XXXXXXXX.XXX.XX>

-----------------------

Subject: [PATCH 3/8] irq: make set_affinity to return status -v2

Impact: prepare to use it to keep affinity consistent

according to Ingo, change set_affinity() in irq_chip to return int.

v2: fix two typo

Signed-off-by: XXXXXXX XX <XXXXXXX@XXXXX.XXX>

----------------------

irq: change irq_desc_alloc to take node instead cpu

Impact: prepare to make irq_desc_alloc to numa aware

so could make irq_desc_alloc use node pass down

Signed-off-by: XXXXXXX XX <XXXXXXX@XXXXX.XXX>

-------------------------

irq: make io_apic_set_pci_routing to take device

Impact: so use dev_to_node

and use node in irq_desc_all_node()

Signed-off-by: XXXXXXX XX <XXXXXXX@XXXXX.XXX>

-------------------------

x86/irq: make MSI irq_desc numa aware

Impact: use irq_desc_alloc_node

try to get irq_desc on the node in create_irq_nr

Signed-off-by: XXXXXXX XX <XXXXXXX@XXXXX.XXX>

---------------------

irq: make ht irq_desc numa aware

Impact: use create_irq_nr

try to get irq_desc on the node with create_irq_nr

Signed-off-by: XXXXXXX XX <XXXXXXX@XXXXX.XXX>
