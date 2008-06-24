Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbYFXD3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbYFXD3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYFXD3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:29:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:53169 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYFXD3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r0PmBtBmh6+PDnSBMHtCw84U19R0mUKyxQtSw2W5rMqbtYJlUL9U0C1h/MaqNATBXA
         UGMHH51cDC8FRLqiNbw3qy8XCXGPpng2ewrIzPzrgcnmOrc+Q0+Xk8EeVnoo3+qGf+a4
         giV9mQGPctep3URlsPFhRFCrEX3rLE6asmzho=
Message-ID: <863e9df20806232029x6621ff13qd584591214e93d7f@mail.gmail.com>
Date: Tue, 24 Jun 2008 08:59:34 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/4] ftrace: prevent ftrace modifications while being kprobe'd
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080623201525.GA10386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485D45AB.3000405@gmail.com> <20080623201525.GA10386@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Jun 24, 2008 at 1:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
> note that i had to do a number of fixups to themerge, and there was one
> chunk which did not merge cleanly and i left it out for now:
>
> @@ -435,8 +502,12 @@ static void ftrace_replace_code(int enable)
>                                continue;
>
>                        /* ignore updates to this record's mcount site */
> -                       if (get_kprobe((void *)rec->ip))
> +                       if (get_kprobe((void *)rec->ip)) {
> +                               freeze_record(rec);
>                                continue;
> +                       } else {
> +                               unfreeze_record(rec);
> +                       }

I wonder why it conflicted during the merge. I notice that patch 4/4
has been applied before
3/4. Can you try reversing the order and see if it works? Else I'll redo them.

--
Thanks,
Abhishek Sagar
