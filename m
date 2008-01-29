Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbYA2GBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbYA2GBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYA2GBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:01:38 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46064 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYA2GBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:01:37 -0500
Date: Tue, 29 Jan 2008 11:32:04 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
Message-ID: <20080129060203.GA15576@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <479C4A28.3020705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479C4A28.3020705@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 02:38:56PM +0530, Abhishek Sagar wrote:
> Greetings,
> 
> Non kprobe breakpoints in the kernel might lie inside the .kprobes.text section. Such breakpoints can easily be identified by in_kprobes_functions and can be caught early. These are problematic and a warning should be emitted to discourage them (in any rare case, if they actually occur).

Why? As Masami indicated in an earlier reply, the annotation is to
prevent *only* kprobes.
 
> For this, a check can route the trap handling of such breakpoints away from kprobe_handler (which ends up calling even more functions marked as __kprobes) from inside kprobe_exceptions_notify.

Well.. we pass on control of a !kprobe breakpoint to the kernel. This is
exactly what permits debuggers like xmon to work fine now. I don't see
any harm in such breakpoints being handled autonomously without any sort
of kprobe influence.

Ananth
