Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYIYWAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYIYWAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbYIYWAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:00:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYIYWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:00:17 -0400
Message-ID: <48DC09D9.7040204@zytor.com>
Date: Thu, 25 Sep 2008 14:59:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Alok Kataria <akataria@vmware.com>, Alok kataria <alokkataria1@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
References: <20080221115452.GB13948@elte.hu>	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu>	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>	 <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1>	 <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1>	 <48DB1BCE.2070106@zytor.com>  <1222320201.23524.135.camel@alok-dev1> <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1222375694.27056.179.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
> The whole backdoor thing is also broken because it requires
> non-architectural side effects to operate (IN instructions can not
> arbitrarily change all GPRs).  This can confuse applications which are
> very smart and try to single step over the instruction by emulating it,
> logging the port I/O, then restoring GPRs to the state before execution
> and writing the 1 register affected by the IN.  Such clever debuggers
> and profiling tools have been written.
> 

To be fair, SMM sometimes also play these kinds of games -- even though 
it is equally frowned upon there.

However, it is the particular use of this for detection use that is 
utterly damning.  Using random I/O port probes for hardware detect 
should have disappeared in the early 1990's, and it's really disturbing 
that virtualization vendors -- not just VMWare -- are, in effect, 
re-making all the mistakes hardware vendors did in the 1980's.

Fortunately, we can usually use DMI to bail us out.  Just like we used 
to look for magic strings in the VGA BIOS so we could figure out what 
exact kind of SuperVGA card we have.

	-hpa


