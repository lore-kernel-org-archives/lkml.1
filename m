Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZELGLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZELGLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZELGLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:11:42 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:58194 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbZELGLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:11:42 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200905120158.46314.arnd@arndb.de>
References: <20090508165219.469818319@chello.nl>
	 <20090508170028.837558214@chello.nl>  <200905120158.46314.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 12 May 2009 08:11:40 +0200
Message-Id: <1242108700.11251.304.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 01:58 +0200, Arnd Bergmann wrote:
> On Friday 08 May 2009, Peter Zijlstra wrote:
> > -#define PERF_COUNTER_IOC_ENABLE                _IO ('$', 0)
> > -#define PERF_COUNTER_IOC_DISABLE       _IO ('$', 1)
> > +#define PERF_COUNTER_IOC_ENABLE                _IOW('$', 0, u32)
> > +#define PERF_COUNTER_IOC_DISABLE       _IOW('$', 1, u32)
> >  #define PERF_COUNTER_IOC_REFRESH       _IOW('$', 2, u32)
> > -#define PERF_COUNTER_IOC_RESET         _IO ('$', 3)
> > +#define PERF_COUNTER_IOC_RESET         _IOW('$', 3, u32)
> 
> These ioctl definitions look malformed:
> _IOW('$', 0, u32) means that the ioctl will read a u32 in user
> space pointed to by (u32 __user *)arg, while what perf_ioctl
> actually does is cast arg to a u32. Moreover, exported headers
> should use __u32 instead of u32.
> 
> PERF_COUNTER_IOC_REFRESH apparently was broken already, this
> patch also breaks the other definitions.

Hmm, are you saying that the 3rd argument to unlocked_ioctl is actually
(void __user *) instead of unsigned long?



