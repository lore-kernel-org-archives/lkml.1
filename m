Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbXITWMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbXITWMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXITWMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:12:03 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41552
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751616AbXITWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:12:01 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: [Announce] Linux-tiny project revival
Date: Thu, 20 Sep 2007 18:11:51 -0500
User-Agent: KMail/1.9.6
Cc: linux-tiny@selenic.com, linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <46F2ED1E.3090407@am.sony.com>
In-Reply-To: <46F2ED1E.3090407@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201811.51384.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 4:58:54 pm Tim Bird wrote:
> Rob Landley wrote:
> > So instead of:
> >   printk(KERN_NOTICE "Fruit=%d\n", banana);
> > It would now be:
> >   printk(KERN_NOTICE, "Fruit=%d\n", banana);
> >
> > Change the header from:
> >   #define KERN_NOTICE "<5>"
> > to:
> >   #define KERN_NOTICE 5
> >
> > Then you can change the printk guts to do something vaguely like
> > (untested): #define printk(arg1, arg2, ...) actual_printk("<" #arg1 ">"
> > arg2, __VA_ARGS__)
>
> ...
>
> > [then] the
> > compiler's dead code eliminator zaps the printks you don't care about so
> > they don't bloat the kernel image.
>
> I agree in principal with the idea, but there are some major
> practical wrinkles that would have to be worked through.
>
> First, not all printks that are missing a log level should have one.
> People do stuff like this:
>
> printk(KERN_INFO "interesting info follows:");
> ...
> printk("var5: %d\n", var5);
>
> Or even things that evaluate to:
> printk("");
>
> The code inside printk currently has to examine the
> strings, looking for line feeds and inserting log levels.
>
> Given that there are about 60,000 printks in the kernel (and that's
> not counting wrappers like dprintk() and other locally-defined
> functions and macros) it would be a huge task to examine the code
> and differentiate strings that really start a new log message
> (and thus should have an attached log level) and strings
> that don't.

Hmmm.  The hard part isn't making printk(0,blah) mean the same as not having a 
log level message now, because the current logic already handles it.  The 
problem is that filtering continuations of previous messages involves knowing 
what log level the previous message was so you know whether or not to filter 
it.

Yeah, that would take some doing to untangle.  An incremental switchever (easy 
printks first, I.E. the ones that currently specify a loglevel) seems more 
strongly indicated...

That said, I started this by noting I haven't personally had time to bang on 
this since I thought of it.  You did ask for ideas. :)

>  -- Tim

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
