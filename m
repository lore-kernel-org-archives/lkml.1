Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZIZQKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZIZQKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZIZQKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:10:44 -0400
Received: from verein.lst.de ([213.95.11.210]:42583 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbZIZQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:10:44 -0400
Date: Sat, 26 Sep 2009 18:10:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] tracing fixes
Message-ID: <20090926161034.GA17279@lst.de>
References: <20090921130228.GA25588@elte.hu> <alpine.LFD.2.01.0909210908020.4950@localhost.localdomain> <20090921162211.GA844@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921162211.GA844@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 06:22:11PM +0200, Ingo Molnar wrote:
> Hm, yes, you are right, we missed that. I noticed the modpost 
> dependency:
> 
>   http://marc.info/?l=linux-kernel&m=125326944223679&w=2
> 
> but thought that it's safe and didnt notice that dangling 
> module_layout() reference and the build warning it generates in the 
> kernel.
> 
> I _think_ the patch below should do the trick - module_layout() appears 
> to be an artificial symbol with 'significant' symbols listed in its 
> argument list so that it gets a proper signature. Removing the marker 
> symbol should thus be the solution, but i'm not 100% sure. Thoughts?
> 
> 	Ingo

Looks good to me, Linus?

> diff --git a/kernel/module.c b/kernel/module.c
> index b6ee424..392eb3d 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2947,7 +2947,6 @@ void module_layout(struct module *mod,
>  		   struct modversion_info *ver,
>  		   struct kernel_param *kp,
>  		   struct kernel_symbol *ks,
> -		   struct marker *marker,
>  		   struct tracepoint *tp)
>  {
>  }
---end quoted text---
