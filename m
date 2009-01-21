Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbZAUPgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbZAUPgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAUPgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:36:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZAUPgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:36:10 -0500
Date: Wed, 21 Jan 2009 16:33:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaliy Gusev <vgusev@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] kthread: Don't looking for a task in create_kthread()
	#2
Message-ID: <20090121153355.GA19169@redhat.com>
References: <200901201345.42054.vgusev@openvz.org> <200901201716.34842.vgusev@openvz.org> <20090120150019.GA17399@redhat.com> <200901202019.56972.vgusev@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901202019.56972.vgusev@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Vitaliy Gusev wrote:
>
> Ok, I understand you. You want to decrease kthreadd latency. In this case
> your suggestion is right.

Please feel free to send the patch then.

> > OK, please forget. This reminds me kthread.c needs a major rework
> > anyway, hopefully I'll try to do this soon.
>
> I also have intent to make kthread_run/kthread_create more easy used for
> threads that exit himself on error.
> For example, we create some thread THR, which does something but exits on error.
> So in normal case we need to call kthread_stop() to stop thread THR, but on
> error we don't. This is a problem, because we can't simple (without race) 
> determine that THR was exited.

This is only one of the problems,

> Simple workaround - do a sleeping loop in thread THR and don't exit until kthread_should_stop.
> But it isn't a good for code reading/writing.
>
> So my suggestion is: Move workaround sleeping logic from THR to low level
> functions:
>    wait for a kthread_should_stop in kthread() if THR was exited.

I think it is better to improve kthread_stop() so it can be used even
if kthread has already exited, this is not that hard.

But there are other problems, I'll try to provide mor info later.

Oleg.

