Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYADGoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYADGoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 01:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYADGnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 01:43:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:25932 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYADGnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 01:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xclxOV53j8kyaLSl7Ckjeln04T9EW1eeR5aExmCv32Wmn5piz8Erg0DmwKgXpZdV8Lkjm4sZkgDaRsCZjUEhjx2xhSZWFIjxPp8v1EI6TSIbDxLdI2JPL9GAT+WGctiHtCxb0PcZzWSYfWmLz55httIPzzsXf8Od8WDF+UySbvE=
Message-ID: <863e9df20801032243t2e8af6eh934a59617162a332@mail.gmail.com>
Date: Fri, 4 Jan 2008 12:13:42 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
In-Reply-To: <477D4183.60909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>
	 <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>
	 <477BD366.1060504@redhat.com>
	 <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com>
	 <477C08A0.503@redhat.com> <477D2595.4060102@gmail.com>
	 <477D4183.60909@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> > +     case KPROBE_HIT_SS:
> > +             if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
> > +                     regs->flags &= ~TF_MASK;
> > +                     regs->flags |= kcb->kprobe_saved_flags;
> > +                     return 0;
> > +             } else {
> > +                     recursive_singlestep(p, regs, kcb);
> > +             }
> > +             break;
> > +     default:
> > +             /* impossible cases */
> > +             WARN_ON(1);
>
> WARN_ON() does not call panic(). Since the kernel doesn't stop,
> we need to prepare singlestep after that.

We shouldn't panic in 'default'. First, we'll never hit this case, and
if we do then we can be sure that the fault is not due to a probe. So
instead of singlestepping we'll let the kernel handle it. If it cant,
it'll panic/die() for us. I'll try to cleanup this case and
incorporate these suggestions in a separate patch, as u suggested.

> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

--
Thanks,
Abhishek Sagar
