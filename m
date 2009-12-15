Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZLOAvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZLOAvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbZLOAvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:51:14 -0500
Received: from 216-239-44-51.google.com ([216.239.44.51]:42749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZLOAvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:51:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ZKYhC4OQylDxJrxRXD7k+lUtcAJLHr5C4VSjMCzeYV0pVgLZANFmCTcg8D/f+VcTZ
	YyL7v+vOT9s7qfW8nFD6A==
MIME-Version: 1.0
In-Reply-To: <20091214161922.6f252492@infradead.org>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	 <20091214161922.6f252492@infradead.org>
Date: Mon, 14 Dec 2009 16:36:20 -0800
Message-ID: <4352991a0912141636t35a96c14o5fd4b9e152e6e681@mail.gmail.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the 
	Linux Kernel
From: Salman Qazi <sqazi@google.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 4:19 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 14 Dec 2009 15:11:47 -0800
> Salman Qazi <sqazi@google.com> wrote:
>
>
> I like the general idea, I have one request (that I didn't see quite in
> your explanation): Please make sure that all cpus in the system do
> their idle injection at the same time, so that memory can go into power
> saving mode as well during this time etc etc...
>

With the current interface, the forced idle percentages on the CPUs
are controlled independently.  There's a trade-off here.  If we inject
idle cycles on all the CPU at the same time, our machine
responsiveness also degrades: essentially every CPU becomes equally
bad for an interactive task to run on.  Our aim at the moment is to
try to concentrate the idle cycles on a small set of CPUs, to strive
to leave some CPUs where interactive tasks can run unhindered.  But,
given a different workload and goals the correct policy may be
different.

Simultaneously idling multiple "cores" becomes necessary in the SMT
case: as there is no point in idling a single thread, while the other
thread is running full tilt.  So, in such a case it is necessary to
idle all the threads making up the physical core.  This feature has
not been implemented yet.

I think the best approach may be to provide a way to specify the
policy from the user space.  Basically let the user decide at what
level of CPU hierarchy the forced idle percentages are specified.
Then, in the levels below, we simply inject at the same time.

>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
