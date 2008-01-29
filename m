Return-Path: <linux-kernel-owner+w=401wt.eu-S933880AbYA2Tht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbYA2Tht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934034AbYA2Th2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:37:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711AbYA2ThZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:37:25 -0500
Message-ID: <479F7EA5.5040201@redhat.com>
Date: Tue, 29 Jan 2008 14:29:41 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: ananth@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       jkenisto@us.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
References: <479C4A28.3020705@gmail.com> <20080129060203.GA15576@in.ibm.com>	 <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com>	 <479F4291.1060106@redhat.com> <863e9df20801291008x40208609j15749fc6e39fbe47@mail.gmail.com>
In-Reply-To: <863e9df20801291008x40208609j15749fc6e39fbe47@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Sagar wrote:
> On 1/29/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
>> In that case, why don't you just reduce the priority of kprobe_exceptions_nb?
>> Then, the execution path becomes very simple.
> 
> Ananth mentioned that the kprobe notifier has to be the first to run.

(Hmm.. I think he has just explained current implementation:))
IMHO, since kprobes itself can not know what the external debugger
wants to do, the highest priority should be reserved for those external tools.

> It still wouldnt allow us to notice breakpoints on places like do_int3
> etc.

If you'd like to do that, my recommendation is to modify IDT directly.

>> I also like to use a debugger for debugging kprobes. that will help us.
> 
> Hmm...It would increase the code-path leading upto kprobe_handler.
> That's more territory to be guarded from kprobes.

Sure, all functions of the debugger should be marked __kprobes.
Thus it will be guarded from kprobes.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

