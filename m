Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZCXH5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZCXH5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZCXH5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:57:39 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:15855 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZCXH5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:57:38 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter tools: remove glib dependency and fix
 bugs in kerneltop.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@elte.hu, tglx@linutronix.de, fengguang.wu@intel.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
References: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 08:57:15 +0100
Message-Id: <1237881435.24918.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 16:52 +1100, Paul Mackerras wrote:
> The glib dependency in kerneltop.c is only for a little bit of list
> manipulation, and I find it inconvenient.  This adds a 'next' field to
> struct source_line, which lets us link them together into a list.  The
> code to do the linking ourselves turns out to be no longer or more
> difficult than using glib.

Awesome!! now I can compile on my test machine as well (yum got stuck,
it doesn't want to go fwd nor backwards, and I can't find time to
reinstall the thing).

> This also fixes a few other problems:

> - We had two CPU migration counters in the default set, which seems
>   unnecessary; I changed one of them to a context switch counter.

Ooh, my bad, copy/paste trouble I imagine.

> - On a test machine here, parse_symbols() and parse_vmlinux() were
>   taking long enough (almost 0.5 seconds) for the mmap buffer to
>   overflow before we got to the first mmap_read() call, so this moves
>   them before we open all the counters.

Ah, thanks for looking into that!


