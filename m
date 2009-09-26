Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZIZKWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZIZKWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 06:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZIZKWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 06:22:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZIZKWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 06:22:36 -0400
Subject: Re: [PATCH 2/4] jump label - base patch
From: Steven Rostedt <rostedt@goodmis.org>
To: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       ak@suse.de, rth@redhat.com, mhiramat@redhat.com
In-Reply-To: <20090925004938.9D85BE06@magilla.sf.frob.com>
References: <cover.1253831945.git.jbaron@redhat.com>
	 <98c4c0b11300ac3b7de3acb2096f8f34184b1457.1253831946.git.jbaron@redhat.com>
	 <20090925004938.9D85BE06@magilla.sf.frob.com>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 06:21:26 -0400
Message-Id: <1253960486.12145.108.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 17:49 -0700, Roland McGrath wrote:
> > +#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
> > +#define __HAVE_ARCH_JUMP_LABEL
> > +#endif
> 
> Put this in linux/compiler-gcc4.h (there only test __GNUC_MINOR__).
> If icc/whoever adds asm goto they can define it too.

We need to be careful here. This code also depends on the text_poke
implementation that is not defined for every arch.

The code around DEFINE_TRACE can be updated to test for
__HAVE_ARCH_JUMP_LABEL as well the config to know if we have text_poke.

-- Steve


