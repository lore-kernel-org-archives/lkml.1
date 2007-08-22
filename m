Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbXHVVpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbXHVVpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbXHVVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:45:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54137 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933343AbXHVVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:45:36 -0400
Date: Thu, 23 Aug 2007 03:28:24 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       wbrana@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][bugzilla #8679] therm_throt.c: Fix section mismatch
In-Reply-To: <alpine.LFD.0.999.0708211103090.2774@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0708230320010.2049@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708211003390.2774@enigma.security.iitk.ac.in>
 <20070820220328.438e8a4d.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0708211103090.2774@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Aug 2007, Satyam Sharma wrote:
> 
> I must say, this is an amazingly cunning idea. Only things I can think of
> against this would be: the dropping of unneeded code is not guaranteed,
> but depends on compiler. And we saw from the "static inline {return 0;}"
> testcase that gcc can sometimes be not-so-smart.

Oh, wait. I just stumbled upon arch/i386/kernel/cpu/intel_cacheinfo.c
that references the callback function from generic CPU-initialization
startup code that must get executed even when HOTPLUG_CPU=n. The leave-it-
upto-toolchain method would see this reference, and preserve the function
even after initcalls stage for HOTPLUG_CPU=n. So the explicit __cpuinit
method scores here, admittedly only because of weird taste of said code.
