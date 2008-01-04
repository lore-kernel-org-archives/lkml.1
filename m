Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYADGeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYADGeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 01:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYADGei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 01:34:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:8582 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYADGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 01:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V5tz61zevc1Nyf9RiAGkqurtTd2iyGfvJUANHk4/UYLnKm/vRJ3rAuAcl+EKS3miqPcMcj5XD2y2cOdvVJDbm5m1ZrnhfEk26OtPhL+mXj5abRftvuc0VGeaxHSwqyPv/xgSSORMrCfSG0+tAMcjjUafPZwHEDJqaO2UodW9IBo=
Message-ID: <863e9df20801032234v1a0eba9arfc71098a100bb145@mail.gmail.com>
Date: Fri, 4 Jan 2008 12:04:35 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
In-Reply-To: <477D5447.6090804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>
	 <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>
	 <477BD366.1060504@redhat.com>
	 <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com>
	 <477C08A0.503@redhat.com> <477D184A.8090009@redhat.com>
	 <477D5447.6090804@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> I could understand what the original code did at last.
> If a kprobe is inserted on a breakpoint which other debugger inserts,
> it single step inline instead of out-of-line.(this is done in prepare_singlestep)
> In this case, (p && kprobe_running() && kcb->kprobe_status==KPROBE_HIT_SS)
> is true and we need pass the control to the debugger.
> And if (*p->ainsn.insn != BREAKPOINT_INSTRUCTION) (or (p != kprobe_running())) in
> that case, there may be some bugs.

Yes, we can only fault while singlestepping for a unique case, which
is when we're singlestepping (in-line) a breakpoint because a probe
was installed on it. All other scenarios are a BUG . That's also
assuming that no exception will preempt singlestepping, whose codepath
has a probe on it.

> Now I think your original suggestion is correct.
> Please fix it in another patch.

Ok.

> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

Thanks,
Abhishek Sagar
