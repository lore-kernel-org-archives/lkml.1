Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYAIQFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYAIQFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYAIQFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:05:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbYAIQE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:04:59 -0500
Date: Wed, 9 Jan 2008 08:03:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] show_task: real_parent
In-Reply-To: <20080109080323.8FCDC26F9A7@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0801090800360.3148@woody.linux-foundation.org>
References: <20080109080323.8FCDC26F9A7@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jan 2008, Roland McGrath wrote:
> 
> The show_task function invoked by sysrq-t et al displays the
> pid and parent's pid of each task.  It seems more useful to
> show the actual process hierarchy here than who is using
> ptrace on each process.

Hmm. It could go both ways. If the problem is some ptrace()/wait4() 
interaction issue (which is certainly not unheard of!) the parent that 
matters for the kernel may be the right thing to print out.

I wonder if we should just print out both (or perhaps print out the 
ptrace parent only if it differs from the normal parent?)

I'll apply this, because I agree that it's sensible in general, I just 
wonder how often anybody really even cares about the parent information 
when it's not about some wait-related issue..

		Linus
