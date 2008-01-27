Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYA0PeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYA0PeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 10:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYA0PeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 10:34:01 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:40495 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYA0PeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 10:34:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cDLJENhlfW0NrBCP/mRyrRnfT6US8zHLYBJM9Kv8Z2bUVemYeJhuWZZgWcdu326krgfK0CM225w/RBbmsAsrGuOezSyF4dU6msFKULNxjtDhukW+y32tfAfSaJ4y6GDmGtRnRiwNrJMAgrlKQ/4g2T3vGoq6rTK326+dCsy8pws=
Message-ID: <863e9df20801270733n4b82b595u8421fb07c18acaa6@mail.gmail.com>
Date: Sun, 27 Jan 2008 21:03:58 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [PATCH 3/3] x86: WARN_ON breakpoints from .kprobes.text section
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <479C94F6.2070502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479C4A4F.10604@gmail.com> <479C94F6.2070502@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> Sorry, I can not understand what issue these patches can solve.
> The breakpoint which is inserted by external debugger will be checked by
> kprobe_handler() and be passed to other exception_notify_handlers.
> In that case, we don't need to warn it.
> I think current code is enough simple.

kprobe_handler has a blanket check for all non-kprobe breakpoints.
They're all left to the kernel to handle. This is fine. Although
external debuggers are free to plant breakpoints anywhere, they should
be discouraged from doing so inside .kprobes.text region. Placing them
there may lead to recursive page-fault/trap handling. It's a defensive
check. I hope I've been able to clarify.

> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com

Thanks,
Abhishek Sagar
