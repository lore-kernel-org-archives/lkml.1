Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbZE0Wk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbZE0Wk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758325AbZE0Wkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:40:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757461AbZE0Wkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:40:41 -0400
Date: Wed, 27 May 2009 15:40:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: orenl@cs.columbia.edu, serge@hallyn.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, xemul@parallels.com
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-Id: <20090527154001.86a5abff.akpm@linux-foundation.org>
In-Reply-To: <20090527221753.GB8321@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
	<1242968132-1044-18-git-send-email-adobriyan@gmail.com>
	<20090526131644.GA20920@hallyn.com>
	<20090526193503.GB11909@x200.localdomain>
	<4A1DA8FB.3000306@cs.columbia.edu>
	<20090527221753.GB8321@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 02:17:53 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > 1) Whether or not allow c/r of sub-container (partial hierarchy)
> > 
> > 2) Creation of restarting process hierarchy in kernel or in userspace
> > 
> > As for #1, you are the _only_ one who advocates restricting c/r to
> > a full container only. I guess you have your reasons, but I'm unsure
> > what they may be.
> 
> The reason is that checkpointing half-frozen, half-live container is
> essentially equivalent to live container which adds much complexity
> to code fundamentally preventing kernel from taking coherent snapshot.
> 
> In such situations kernel will do its job badly.
> 
> Manpage will be filled with strings like "if $FOO is shared then $BAR is
> not guaranteed".
> 
> What to do if user simply doesn't know if container is bounded?
> Checkpoint and to hell with consequences?
> 
> If two tasks share mm_struct you can't even detect that pages you dump
> aren't filled with garbage meanwhile from second task.
> 
> If two tasks share mm_struct, other task can issue AIO indefinitely
> preventing from taking even coherent filesystem snapshot.
> 
> That's why I raise this issue again to hear from people what they think
> and these people shouldn't be containers and C/R people, because the
> latter already made up their minds.
> 
> This is super-important issue to get right from the beginning.

<pipes up>

yeah, checkpointing a partial hierarchy at this stage sounds like
overreach.  Get full-container working usably first, think about
sub-containers in version 2.

<pipes down again>
