Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbXIUO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbXIUO6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbXIUO6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:58:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:19888 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXIUO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e6uo7uVOOcTpd7I2cAvQZMX3bGvxzz9X04SSjYNWtsEmhNrx9WuH9OtSQ5kE3mdlMr7+7yBg05pJtLM6Vr6grLyX7LJZG3GhKzsqM3IDQLF5vHVa0U+2mgJ7d84xjN+6Z9QVU023kawSWIwJICfEVKTQIZikJSJvzvM4dBhL0Y8=
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
From: Gilboa Davara <gilboad@gmail.com>
Reply-To: gilboad@gmail.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46F3D351.2090506@grupopie.com>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
	 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>
	 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>
	 <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
	 <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in>
	 <46F1314B.8040105@grupopie.com>
	 <1190378737.30016.15.camel@gilboa-home-dev.localdomain>
	 <46F3D351.2090506@grupopie.com>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 16:57:59 +0200
Message-Id: <1190386679.30016.67.camel@gilboa-home-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 15:21 +0100, Paulo Marques wrote:
> Gilboa Davara wrote:
> > Hello Paulo,
> 
> Hi, Gilboa
> 
> Usually the developer can separate the output by hand in the unlikely 
> case of simultaneous concurrent users of printk, so I don't think this 
> is really a big problem.

In general I agree, but as the number of cores increases dramatically,
hitting a warning/BUG/oops simultaneously on multiple cores (especially
during development) becomes more of a problem.

At least to me, It's not rare that when working on 8C or above machine,
an oops message becomes completely unreadable due to multiple debug
printks that trash the serial port output. 

Never the less, I do agree that this problem is more developer related
and should not hit an end user running a debug-free distribution kernel.

> 
> >> Of course this requires changing _all_ callers of print_symbol to use 
> >> the new interface, but these are less than 100 ;)
> > 
> > This is my first contribution to the Linux kernel. As such I rather
> > start small, and work my way up slowly. (Read: solve the immediate stack
> > over-run now, think about changing the symbol_display interface later)
> 
> Yes, but this is a sensitive area, so you can not just implement 
> something now that can cause regressions, and just fix it later.

True.
My aim is to create a patch that
A. Doesn't break the current interface/APIs while keeping the
patch/noise to a minimum.
B. Does not cause any type of regression.

> 
> Kernel panics are quite rare and the information provided by the stack 
> dump is _extremely_ precious.

I fully agree.

> 
> Even more, risking deadlocks caused by something that should only be 
> used to produce debug information is even worse.

Hopefully the latest patch moves one step further in removing your
concerns.

> 
> >> Comments?
> > 
> > I do agree that the current interface needs work.
> > 
> > ... But as I said, I rather start slowly and on small scale. (Though I
> > did find a rather problematic place to start at... ;))
> 
> Well, if we agree that this is the way to go, then the way to start 
> slowly would be to submit a patch that makes both interfaces available 
> for a while and changes the most stack-critical callers to the new 
> interface.
> 
> Then slowly keep submitting patches to change other callers 
> progressively until there are no more callers of the old interface. At 
> that point we can just drop it entirely.

If I cannot find a working solution that does meet my initial goals
(Minimal patch/no regression) I'll start from scratch - creating a new
trace call path.

- Gilboa

