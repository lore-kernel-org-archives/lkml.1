Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbYACDAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbYACDAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYACDAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:00:07 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:18461 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYACDAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:00:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kcalxgcbhU9m4stt4GlZpWSW9cUQYFtXhv/dyXoTDw1nk9yzeU0k3DPL0iLwar/7rxv5t/1nTPsfwFSDxR2YPrXrBYhsdJvRX7WcpOSTZ80rnSYaQMydLAyaiFsYX2LC4iU56a9L9j8Z4KXALku8lP9plfnKDD5lGTWczZROnpI=
Subject: Re: [PATCH] x86: Use is_kprobe_fault to better match usage
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, qbarnes <qbarnes@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
In-Reply-To: <477C4A42.1010701@redhat.com>
References: <1199322323.6323.76.camel@brick>  <477C4A42.1010701@redhat.com>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 19:00:00 -0800
Message-Id: <1199329200.6323.97.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-02 at 21:36 -0500, Masami Hiramatsu wrote:
> Hi Harvey,
> 
> Harvey Harrison wrote:
> > Currently the notify_page_fault helper is used to test it the page
> > fault was caused by a kprobe causing an early return from do_page_fault.
> > 
> > Change the name of the helper to is_kprobe_fault to match the usage and
> > remove the preempt_disable/enable pair around kprobe_running() with an
> > explicit test for preemption.  The idea for this comes from a patch
> > by Quentin Barnes to kprobes.c
> 
> Sure, that's right.
> However, since other architectures also have notify_page_fault(),
> I think all of those code might better be changed same time for
> maintainability.
> 

How about a static inline in linux/kprobes.h with a big comment above
about when/why the !preemptible() check is sufficient?

Harvey



