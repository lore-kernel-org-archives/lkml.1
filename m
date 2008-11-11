Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYKKOEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYKKOEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYKKOD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:03:58 -0500
Received: from aun.it.uu.se ([130.238.12.36]:54924 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbYKKOD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:03:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18713.37039.130384.255448@harpo.it.uu.se>
Date: Tue, 11 Nov 2008 15:03:27 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
In-Reply-To: <20081111132018.GI14989@elte.hu>
References: <20081107003021.GA18666@google.com>
	<20081107004824.GA28780@x200.localdomain>
	<20081107074147.GA26607@elte.hu>
	<20081107075925.GA1825@elte.hu>
	<20081107082003.GA15800@x200.localdomain>
	<20081107083249.GD4435@elte.hu>
	<20081107084943.GA16147@x200.localdomain>
	<20081107085352.GA27245@elte.hu>
	<20081107090304.GA30540@elte.hu>
	<20081111122531.GA5836@joi>
	<20081111132018.GI14989@elte.hu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > > >  # cat /proc/18579/stack
 > > >  [<ffffffffffffffff>] 0xffffffffffffffff
 > > 
 > > so this file provides view of _kernel_ stack only?
 > > shouldn't it be named kernel-stack then?
 > 
 > it prints the kernel stack right now, but i'd not restrict it to the 
 > kernel stack conceptually: i think we could eventually expand it to 
 > print the user-space portion of the stack as well. (in the case when 
 > user-space is built with frame pointers) We've got code for that in 
 > the kernel already. It would be an easy one-stop-shop for full-range.

That would be quite fragile given the fact that user-space
only has to follow standard ABIs at specific points like
calls to standard library functions. In between, anything
can, and does, happen.
