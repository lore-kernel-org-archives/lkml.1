Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbYA1LQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbYA1LQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYA1LQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:16:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:22489 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYA1LQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hMPzVe/bZTJx+MxjT7w7Lv0rrvfFz8WeVDizfHlAANMRBuI1V6WcflWB3IGy/eR9kFwLmB8TdOgNar++csG7fhsWIKNV1dU9NEd6PX9Lo19z1fw1T73danRF7H0iv0aaorPusQIoG4OV0MO6LXXyns55noOy6Oq6OmbRFGRLhTs=
Message-ID: <863e9df20801280316w59c51a91la9cece372086e673@mail.gmail.com>
Date: Mon, 28 Jan 2008 16:46:41 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [PATCH 3/3] x86: WARN_ON breakpoints from .kprobes.text section
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <479D00EC.20600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479C4A4F.10604@gmail.com> <479C94F6.2070502@redhat.com>
	 <863e9df20801270733n4b82b595u8421fb07c18acaa6@mail.gmail.com>
	 <479D00EC.20600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> Thank you for explanation, I hope I can understand it.
> Even if it causes a trap recursively, it could be checked (and ignored) by
> longjump_break_handler(), and passed to the debugger correctly.

Yes, all non-kprobe breakpoints are left to the kernel to be handled.
The objective here is to intercept the trap handling of a certain
category of such breakpoints and emit a warning. The premise being
that .kprobes.text section is a logical breakpoint-free zone.

> Please consider that someone expands jprobe(jprobe2) which uses
> jprobe_return2() instead of jprobe_return(), how would you handle it?

By a simple modification of is_jprobe_bkpt() (defined in patch #2 of
this series).

> Current kprobes provides an opportunity to those external probe frameworks
> for checking it by themselves.

Could you clarirfy this with some example. For now I'm assuming that
by external probe frameworks you mean kernel modules using kprobes. If
they embed breakpoints in their handlers, then they will simply not be
caught by this check because thay cannot lie in the .kprobes.text
section.

> By the way, external kernel debugger knows how kprobe (and exception notifier)
> works, so I think it can fetch his exception before kprobes does (by tweaking
> notifier chain, etc).
> (I hope all external kernel debuggers take care of it. :-))

I would image that from a code correctness's point of view it
shouldn't matter. In any case, nothing can be done if the kprobe
exception notifier is circumvented.

> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com

--
Thanks,
Abhishek Sagar
