Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbZHXIVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbZHXIVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZHXIVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:21:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:33934 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751731AbZHXIVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:21:38 -0400
X-Authenticated: #2360897
X-Provags-ID: V01U2FsdGVkX1+2rZtNGTi2sXug/n3ImMyvkforUH9a95JxcE1iYx
	eaD7cnj83NLLU0
Date: Mon, 24 Aug 2009 10:21:49 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Amerigo Wang <amwang@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, nhorman@redhat.com,
       ebiederm@xmission.com, andi@firstfloor.org, fenghua.yu@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com, avorontsov@ru.mvista.com
Subject: Re: [Patch 5/8] ia64: implement crashkernel=auto
Message-ID: <20090824082148.GA16457@mail1.bwalle.de>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
 <20090821065729.4855.47860.sendpatchset@localhost.localdomain>
 <20090821172407.d3a5cd2b.akpm@linux-foundation.org>
 <20090822111816.GA12281@elte.hu>
 <4A91F57D.10708@redhat.com>
 <20090824074318.GB2424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824074318.GB2424@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-08-24 09:43]:
> * Amerigo Wang <amwang@redhat.com> wrote:
> >
> > The reason that I kept 2ULL<<30 instead of 1ULL<<31 is that '1<<30' is  
> > exactly 1G, so 2ULL<<30 can be easily read as 2G. ;)
> 
> i have no trouble reading 1ULL<<31 as 2G ;-) OTOH, the logic and 
> pattern of the comparisons (especially without the comment) looked 
> odd at first sight, until i noticed this.

Why not just something like

    #define KBYTE(x)  ((x)*1024ULL)
    #define MBYTE(x)  ((x)*1024ULL*1024)
    #define GBYTE(x)  ((x)*1024ULL*1024*1024) 
    #define TBYTE(x)  ((x)*1024ULL*1024*1024*1024)

I find GBYTE(2) much easier to read than 1ULL<<31. Honestly, I would
add a comment '/* 2G */' if I would write 1ULL<<31 in own code.

But I'm of course not one of that super kernel hackers. ;-)


Regards,
Bernhard
