Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbZJNJ2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbZJNJ2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbZJNJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:28:11 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:44233 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbZJNJ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=F9c1OcdaxFrTBm0MyAxAYe1rHZtFsYiJsNhCzb0JlmrVE/SUaBt32ecyNd5Myp7xHy
         JkwcPgdvoABO2STr65OmCxARYb2Jsa/CXQf+1ZlhP8QoE7XhxljUN1vLqn37u4Q5suDb
         zcZ/Tls1/3avqHogUCNKmM4TGfq0wK3//tCIE=
MIME-Version: 1.0
In-Reply-To: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>
Date: Wed, 14 Oct 2009 02:21:22 -0700
Message-ID: <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>
Subject: Re: How to check whether executing in atomic context?
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 11:36 PM, Leonidas . <leonidas137@gmail.com> wrote:
> Hi List,
>
> I am working on a profiler kind of module, the exported apis of my
> module can be
> called from process context and interrupt context as well. Depending on the
> context I am called in, I need to call sleepable/nonsleepable variants
> of my internal
> bookkeeping functions.
>
> I am aware of in_interrupt() call which can be used to check current
> context and take action
> accordingly.
>
> Is there any api which can help figure out whether we are executing
> while hold a spinlock? I.e
> an api which can help figure out sleepable/nonsleepable context? If it
> is not there, what can
> be done for writing the same? Any pointers will be helpful.
>
> -Leo.
>

  While searching through the sources, I found this,

  97/*
  98 * Are we running in atomic context?  WARNING: this macro cannot
  99 * always detect atomic context; in particular, it cannot know about
 100 * held spinlocks in non-preemptible kernels.  Thus it should not be
 101 * used in the general case to determine whether sleeping is possible.
 102 * Do not use in_atomic() in driver code.
 103 */
 104#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) !=
PREEMPT_INATOMIC_BASE)
 105

this just complicates the matter, right? This does not work in general
case but I think this
will always work if the kernel is preemptible.

Is there no way to write a generic macro?


-Leo.
