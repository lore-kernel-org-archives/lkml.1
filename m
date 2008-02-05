Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbYBEWBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbYBEWBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbYBEWBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:01:31 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:12402 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758511AbYBEWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:01:30 -0500
Date: Tue, 5 Feb 2008 13:58:05 -0800
From: Daniel Walker <dwalker@dwalker1.mvista.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Max Krasnyanskiy <maxk@qualcomm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: CPU hotplug and IRQ affinity with 2.6.24-rt1
Message-ID: <20080205215805.GD18613@dwalker1.mvista.com>
References: <47A7A131.8040800@qualcomm.com> <20080205025144.GA31774@dwalker1.mvista.com> <47A7A784.BA47.005A.0@novell.com> <20080205165936.GA18613@dwalker1.mvista.com> <47A863BE.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A863BE.BA47.005A.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 11:25:18AM -0700, Gregory Haskins wrote:
> @@ -6241,7 +6242,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
>                 cpu_clear(rq->cpu, old_rd->online);
> 
>                 if (atomic_dec_and_test(&old_rd->refcount))
> -                       kfree(old_rd);
> +                       reap = old_rd;

Unrelated to the in atomic issue, I was wondering if this if statement
isn't true can the old_rd memory get leaked, or is it cleaned up
someplace else?

Daniel
