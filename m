Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbZANATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbZANATS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbZANATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:19:06 -0500
Received: from ozlabs.org ([203.10.76.45]:46111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbZANATF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:19:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 13/13] x86_32: make percpu symbols zerobased on SMP
Date: Wed, 14 Jan 2009 10:48:58 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: ebiederm@xmission.com, cl@linux-foundation.org, mingo@elte.hu,
       travis@sgi.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       akpm@linux-foundation.org, steiner@sgi.com, hugh@veritas.com
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <1231843097-18003-14-git-send-email-tj@kernel.org>
In-Reply-To: <1231843097-18003-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141048.59632.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009 21:08:17 Tejun Heo wrote:
> This patch makes percpu symbols zerobased on x86_32 SMP by using
> PERCPU_VADDR() with 0 vaddr in vmlinux_32.lds.S.  A new PHDR is added
> as existing ones cannot contain sections near address zero.
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Mike Travis <travis@sgi.com>
> ---
>  arch/x86/kernel/cpu/common.c     |    8 ++++++++
>  arch/x86/kernel/head_32.S        |   37 ++++++++++++++++++++++++++++++++++---
>  arch/x86/kernel/setup_percpu.c   |    4 ----
>  arch/x86/kernel/vmlinux_32.lds.S |   16 +++++++++++++++-
>  4 files changed, 57 insertions(+), 8 deletions(-)

Hmm, the only reason for this change is to unify with 64-bit, yes?  Yet it
doesn't actually win us anything on that front, as this diffstat shows.

If gcc's -mcmodel=kernel had used a weak symbol for the offset of the stack
canary, we would have been happy.  Unfortunately generic per-cpu and x86-64
PDA were developed separately, so noone realize the problem until too late.

The basic series looks good: it will clash with my per-cpu work (mainly
because I remove the per_cpu__ prefix) in a purely-textual way though.

Thanks for this!
Rusty.
