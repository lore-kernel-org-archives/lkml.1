Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbYHCMVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbYHCMVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbYHCMVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:21:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbYHCMVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:21:37 -0400
To: "Ming Lei" <tom.leiming@gmail.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
Subject: Re: [RFC] ftrace: support tracing functions in one module
References: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sun, 03 Aug 2008 08:19:28 -0400
In-Reply-To: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com> (Ming Lei's message of "Sun, 3 Aug 2008 15:50:19 +0800")
Message-ID: <y0mljzee1f3.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ming Lei" <tom.leiming@gmail.com> writes:

> [...]  For example, one may only have interest in functions calling
> in usbcore.ko, but he must trace all the functions calling in the
> kernel, so the tracing result is too large to use it. [...]

Until ftrace gains this ability, you could use systemtap:

# cat callret.stp
probe $1.call { printf ("%s <- %s\n", thread_indent(1), probefunc()) }
probe $1.return { printf ("%s -> %s\n", thread_indent(-1), probefunc()) }
# stap callret.stp 'module("usbcore").function("*")'
[...]
^C
#

(One can also add conditions based on function parameters, processes,
whatever; soon it'll be easy to trace all function parameters.)


- FChE
