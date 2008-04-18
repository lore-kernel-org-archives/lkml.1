Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYDRN6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYDRN6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYDRN6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:58:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40624 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYDRN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:58:45 -0400
Date: Fri, 18 Apr 2008 06:58:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       sam@ravnborg.org, arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Stack protector build failure (was Re: 2.6.25-mm1: not looking
 good)
Message-ID: <20080418065806.35c73f96@laptopd505.fenrus.org>
In-Reply-To: <20080418002858.de236663.akpm@linux-foundation.org>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	<20080417224908.67cec814@laptopd505.fenrus.org>
	<20080417231038.72363123.akpm@linux-foundation.org>
	<20080418071945.GA18044@elte.hu>
	<20080418002858.de236663.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 00:28:58 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:


> 
> > No harm done on a 
> > perfectly bug-free system - but once a bug happens that SELinux
> > should have mitigated, the breakage becomes real. Having a
> > prominent warning is the _minimum_.
> > 
> > having a build failure would be nice too because this is a build 
> > environment problem. (not a build warning - warnings can easily be 
> > missed because on a typical kernel build there's so many false
> > positives that get emitted by various other warning mechanisms)
> > Arjan?
> > 
> 
> Yeah, #error would work too.

I'm totally fine with that, but I think I need Sam's help on making that happen
the right way; this is going to need makefile fu L(

Sam:
Basically what I need is that if the
scripts/gcc-x86_64-has-stack-protector.sh script fails, the build aborts with
a message/#error that says that the compiler is not capable of supporting this feature.

Right now the script is used like this:

	stackp := $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh
        stackp-$(CONFIG_CC_STACKPROTECTOR) := $(shell $(stackp) \
                "$(CC)" -fstack-protector )

It's obviously easy to make this script print a warning.. but how do we make it stop the build?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
