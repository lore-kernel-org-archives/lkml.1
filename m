Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbXITUQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbXITUQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXITUQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:16:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3092 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbXITUQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:16:27 -0400
Subject: Re: [Announce] Linux-tiny project revival
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: linux-tiny@selenic.com, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
In-Reply-To: <200709201538.43093.rob@landley.net>
References: <46F1645D.9050406@am.sony.com>
	 <200709201538.43093.rob@landley.net>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 13:16:00 -0700
Message-Id: <1190319360.26101.154.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 15:38 -0500, Rob Landley wrote:
> And so far no behavior has changed.  But now the _fun_ part is, you can add a 
> config symbol for "what is the minimum loglevel I care about?"  Set that as a 
> number from 0-9.  And then you can define the printk to do:
> 
> #define printk(level, str, ...) \
>   do { \
>     if (level < CONFIG_PRINTK_DOICARE) \
>       actual_printk("<" #level ">" str, __VA_ARGS__); \
>   } while(0);
> 
> And viola (however you spell that, I think I'm using the stringed instrument 

> But this doesn't _completely_ eliminate 
> printks, so you can still get the panic() calls and such.  You tweak precisly 
> how much bloat you want, using the granularity information that's already 
> there in the source code...
> Opinions?

I'd rather take the opportunity to convert all the printks to
use pr_<level>.  That way, you can pick'n'choose if you want
arbitrary combinations of KERN_<level> compiled in or not.


