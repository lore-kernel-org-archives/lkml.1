Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXI0G0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXI0G0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXI0G0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:26:32 -0400
Received: from main.gmane.org ([80.91.229.2]:51504 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXI0G0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:26:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Shreyansh Jain <shreyansh.jain@gmail.com>
Subject: Re: =?utf-8?b?dHJ5X21vZHVsZV9nZXQ=?= code understanding
Date: Thu, 27 Sep 2007 06:26:15 +0000 (UTC)
Message-ID: <loom.20070927T061840-329@post.gmane.org>
References: <loom.20070927T051622-501@post.gmane.org> <20070927061304.GA7966@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.8.220.8 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.7) Gecko/20070914 Firefox/2.0.0.7)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for you reply, please see inline.

Heiko Carstens <heiko.carstens <at> de.ibm.com> writes:
> 
[snip]
> > static inline int try_module_get(struct module *module){
> >   int ret = 1;   <--- error case when !module
> >     if (module) {
> >          unsigned int cpu = get_cpu();
> >          if (likely(module_is_live(module)))
> >                 local_inc(&module->ref[cpu].count);
> >          else
> >                 ret = 0;   <--- error case
> >          put_cpu();
> >   }
> >   return ret;   <----
> > }
> > ----
[snip]
 
> Somewhere in module.h you have:
> 
> #ifdef MODULE
> #define THIS_MODULE (&__this_module)
> #else  /* !MODULE */
> #define THIS_MODULE ((struct module *)0)
> #endif
> 
> So this just means, that THIS_MODULE is NULL for compiled in modules
> and therefore try_module_get(NULL) succeeds. It's not an error case.

Agreed.

Then what is return value if my module tries to 'get' a module which does not
exist (and is a module, not in-built)? . Is it '1' ?
Or am I imagining a hypothetical scenario which would not exist?

Thanks again for your fast response.
Shreyansh

