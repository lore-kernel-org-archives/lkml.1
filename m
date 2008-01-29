Return-Path: <linux-kernel-owner+w=401wt.eu-S932956AbYA2RZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbYA2RZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYA2RYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:24:51 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:43453 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYA2RYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:24:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UJkdvAQvVmjOmY1ONlUSDujlKgoSPsdgSgrUeXqX4uR0FluRErl9ufA/fAVMf05jdXLbM+AsVMVeXdDJ612g+riKb7tmA8OkJ2iPw2T4u/DCUJKTE5fDZ3Yff7D9XnmYskm0vhHjAAIjfjDB7uC0wpv+GjO0emCj8POuL5fsYyA=
Message-ID: <863e9df20801290924n7a0794b8k4c334d0c78560db9@mail.gmail.com>
Date: Tue, 29 Jan 2008 22:54:46 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: ananth@in.ibm.com
Subject: Re: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       "Masami Hiramatsu" <mhiramat@redhat.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080129131821.GA27312@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479C4A28.3020705@gmail.com> <20080129060203.GA15576@in.ibm.com>
	 <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com>
	 <20080129131821.GA27312@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/08, Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> > May be I'm completely off the mark here, but shouldn't a small subset
> > of this section simply be 'breakpoint-free' rather than 'kprobe-free'?
> > Placing a breakpoint on kprobe_handler (say) can loop into a recursive
> > trap without allowing the debugger's notifier chain to be invoked.
>
> A well heeled debugger will necessarily take care of saving contexts
> (using techniques like setjmp/longjmp, etc) to help it recover from such
> nested cases (See xmon for example).

Ok, but the protection/warning is not just for xmon.

> > I'm assuming that non-kprobe exception notifiers may (or even should) run
> > after kprobe's notifier callback (kprobe_exceptions_notify).
>
> Yes, any such notifier is invoked after kprobe's callback as the kprobe
> notifier is always registered with the highest priority.

Ok.

> > The WARN_ON (and not a BUG_ON) will be hit iff:
> > (in_kprobes_functions(addr) && !is_jprobe_bkpt(addr))
>
> But that still is unneeded dmesg clutter, IMHO.

Ok, a warning in my opinion would've been prudent since I think we
cannot guarantee non kprobe breakpoint users (debuggers or anything
else) from the recursive trap handling case.

> Ananth

--
Thanks,
Abhishek
