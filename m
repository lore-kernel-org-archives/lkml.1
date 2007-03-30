Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXC3TXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXC3TXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXC3TXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:23:35 -0400
Received: from koef.zs64.net ([212.12.50.230]:49954 "EHLO koef.zs64.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbXC3TXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:23:34 -0400
X-Greylist: delayed 2099 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 15:23:33 EDT
Date: Fri, 30 Mar 2007 14:44:39 -0400
From: Martin Cracauer <cracauer@cons.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com
Subject: Re: [perfmon] exposing FSB clock speed in /sys
Message-ID: <20070330184439.GA6671@cons.org>
References: <20070330153937.GC16059@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330153937.GC16059@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote on Fri, Mar 30, 2007 at 07:39:37AM -0800: 
> Hello,
> 
> It seems that the kernel does not expose the Front-Side Bus (FSN) Clock
> speed to user applications. I found code in the kernel dealing with
> frequency scaling that extracts the information for x86 processors but
> the value is never exposed.
> 
> Knowledge the the FSB speed is very useful to monitoring tools. It is used
> to compute certain bus-related metrics.
> 
> Looking at the code, it seems that there is no standard way of extracting
> the FSB speed. For each processor model, you have different MSRs. I would
> think that the routines in the cpufreq code could be moved out and used
> as the basis to expose the information somewhere in /sys.

That is still problematic as finding out the FSB might not be
trivial.  For example, for the NForce4 chipsets we have a too to
manipulate FSB and multipliers, but it's not in the kernel and never
will be.  I don't think that K8 has a way to find the FSB from the CPU
only, so you are bound to tangle with "nice" chipsets from NVidia et al.

I like the idea, but I expect there will be reservations against
presenting a /proc file that cannot be supported for almost all
machines. 

In general, I would like the cpufreq code split up, as I need to reuse
parts of it for other clock manipulation projects.  Currently, cpufreq
is a blob of code to manipulate frequencies, and to deal with the
fallout.  These two should be split up.

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
FreeBSD - where you want to go, today.      http://www.freebsd.org/
