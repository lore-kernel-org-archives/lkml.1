Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYA3EG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYA3EG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 23:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYA3EGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 23:06:47 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47798 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbYA3EGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 23:06:46 -0500
Date: Wed, 30 Jan 2008 09:37:13 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
Message-ID: <20080130040712.GA6762@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <479C4A28.3020705@gmail.com> <20080129060203.GA15576@in.ibm.com> <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com> <479F4291.1060106@redhat.com> <863e9df20801291008x40208609j15749fc6e39fbe47@mail.gmail.com> <479F7EA5.5040201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479F7EA5.5040201@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 02:29:41PM -0500, Masami Hiramatsu wrote:
> Abhishek Sagar wrote:
> > On 1/29/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> >> In that case, why don't you just reduce the priority of kprobe_exceptions_nb?
> >> Then, the execution path becomes very simple.
> > 
> > Ananth mentioned that the kprobe notifier has to be the first to run.
> 
> (Hmm.. I think he has just explained current implementation:))
> IMHO, since kprobes itself can not know what the external debugger
> wants to do, the highest priority should be reserved for those external tools.

The reason why kprobes needs to be the first to run is simple: it
doesn't need user intervention and if it isn't the intended recepient of
the breakpoint, it just lets the kernel take over (unlike a debugger,
which would potentially need user attention). Also, if the underlying
instruction itself is a breakpoint, we have the facility in kprobes to
single-step inline so the kernel can take control and notify any other
intended recepient of the underlying breakpoint.

As such, I believe the current situation is fine, has worked fine for
close to 4 years now and doesn't warrant any change.

Ananth
