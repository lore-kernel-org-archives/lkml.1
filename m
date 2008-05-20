Return-Path: <linux-kernel-owner+w=401wt.eu-S932763AbYETOSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbYETOSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYETOSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:18:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56563 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbYETOSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:18:32 -0400
Date: Tue, 20 May 2008 07:18:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
Message-ID: <20080520071804.482c173e@infradead.org>
In-Reply-To: <20080520034453.GA21313@Krystal>
References: <20080504134838.GA21487@Krystal>
	<20080505065559.GD3350@elte.hu>
	<20080505105915.GA26444@Krystal>
	<20080505111029.GA9948@elte.hu>
	<20080505113057.GA28070@Krystal>
	<20080505122835.GA1523@elte.hu>
	<20080520034453.GA21313@Krystal>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 23:44:53 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Ideally, I'd like to have this kind of high-level information :
> > > 
> > > event name : kernel syscall
> > > syscall name : open
> > > arg1 (%s) : "somefile"    <-----
> > > arg2 (%d) : flags
> > > arg3 (%d) : mode
> > > 
> > > However, "somefile" has to be read from userspace. With the
> > > protection involved, it would cause a performance impact to read
> > > it a second time rather than tracing the string once it's been
> > > copied to kernel-space.

the audit subsystem already does all of this... why not use that??
(And it goes through great lengths to do it securely)

> > 

> Hrm, a quick benchmark on my pentium 4 comparing a normal open()
> system call executed in a loop to a modified open() syscall which
> executes the lines added in the following patch adds 450 cycles to
> each open() system call. I added a putname/getname on purpose to see
> the cost of a second userspace copy and it's not exactly free.

copying twice does mean that if the user wants, he can cheat you. He
can, in another thread, change the string under you. So say you're
doing this for anti-virus purposes, he can make you scan one file and
open another.


The audit subsystem was carefully designed to avoid this trap... how
about using that?
