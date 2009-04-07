Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZDGEwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZDGEwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZDGEwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:52:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbZDGEwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:52:11 -0400
Date: Mon, 6 Apr 2009 21:45:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>,
       Avan Anishchuk <matimatik@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
 updates
In-Reply-To: <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain> <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain> <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Linus Torvalds wrote:
> 
> It bisected past them. I'm getting worried that it's timing-related, 
> because nothing that remains looks even remotely interesting for that Mac 
> mini, but right now:
> 
>  - bad: 56fcef75117a153f298b3fe54af31053f53997dd
>  - good: bb233fdfc7b7cefe45bfa2e8d1b24e79c60a48e5
> 
> and there's not a whole lot of commits in between.

It's c3b1b1cbf002e65a3cabd479e68b5f35886a26db: 'ramfs: add support for 
"mode=" mount option'.

And I checked. Reverting it at the tip fixes it. So no random timing 
fluctuations.

So that commit causes some random SLAB corruption, that then (depending 
apparently on luck) may or may not crash in some odd random places later.

Wu?

		Linus
