Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZKWMjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZKWMjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbZKWMje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:39:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:25988 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbZKWMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:39:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=prCJU1Emeeymd0Q5kxiZPgXdy9XZC52MUXq/uXb/NEVReabxa97W9f7PaOTg2LU5Jn
         cSSYIyCMXn/5lapfQZWBKYE2V3O2fWvUd9a95WM6WjeQZdi2LUp8YzITUTfqkM6CNi5T
         m3af6OArxlkfwdE+c77tn9ZG7oJXN9OOKLU/c=
Date: Mon, 23 Nov 2009 13:39:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf_events: Undo some recursion damage
Message-ID: <20091123123935.GB4989@nowhere>
References: <20091123103819.993226816@chello.nl> <tip-4ed7c92d68a5387ba5f7030dc76eab03558e27f5@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4ed7c92d68a5387ba5f7030dc76eab03558e27f5@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 11:55:08AM +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  4ed7c92d68a5387ba5f7030dc76eab03558e27f5
> Gitweb:     http://git.kernel.org/tip/4ed7c92d68a5387ba5f7030dc76eab03558e27f5
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 23 Nov 2009 11:37:29 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 23 Nov 2009 11:49:57 +0100
> 
> perf_events: Undo some recursion damage
> 
> Make perf_swevent_get_recursion_context return a context number
> and disable preemption.
> 
> This could be used to remove the IRQ disable from the trace bit
> and index the per-cpu buffer with.


But if I do that, it means I will lose traces once irq nest.

