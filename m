Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbYIFWNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbYIFWNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 18:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIFWM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 18:12:58 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52635 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYIFWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 18:12:57 -0400
Date: Sat, 6 Sep 2008 18:12:31 -0400
From: Jeff Dike <jdike@addtoit.com>
To: John Reiser <jreiser@BitWagon.com>
Cc: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>, jiayingz@google.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, dkegel@google.com
Subject: Re: [uml-devel] [PATCH 2/6] UML: Don't valgrind userspace
Message-ID: <20080906221231.GA9359@c2.user-mode-linux.org>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net> <alpine.DEB.1.00.0808291614430.15543@abydos.NerdBox.Net> <20080905163718.GA11455@c2.user-mode-linux.org> <48C2EE46.2060509@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C2EE46.2060509@BitWagon.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 01:55:34PM -0700, John Reiser wrote:
> > This is effectively appropriating part of the kernel's ABI for
> > valgrind's use.  
> 
> UML is part of the kernel, so getting a memory reference checker (valgrind)
> running in UML is part of the kernel, too.  The concept of "escape from the
> virtualizer" eventually occurs to more than just memory reference checkers.

Irrelevant - what if UML, or anything else for that matter, starts
using CLONE_IO?  All of a sudden, valgrind will start letting those
threads go.

> Why wouldn't that be a race between the next _NR_clone from this thread
> and the next _NR_clone from any other existing thread [in the same
> process]?

Yeah, if you cloned in a signal handler, that would be a problem.

How about sticking the annotation in the thread itself?  This may be
what you're suggesting here - I can't really tell.

> Valgrind can pre-pend a block of code at the start of the new thread,
> but almost immediately that code will want to "unvirtualize."
> Doing so at _NR_clone itself is convenient all around.

  	      		Jeff

-- 
Work email - jdike at linux dot intel dot com
