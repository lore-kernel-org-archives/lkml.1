Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYHHIoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYHHIoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYHHIoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:44:06 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:59458 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbYHHIoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:44:05 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Fri, 8 Aug 2008 10:44:01 +0200
User-Agent: KMail/1.9.9
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, vegard.nossum@gmail.com
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080806201401.GA607@linux-os.sc.intel.com> <20080806212152.GB607@linux-os.sc.intel.com>
In-Reply-To: <20080806212152.GB607@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808081044.01470.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, Suresh Siddha wrote:
> On Wed, Aug 06, 2008 at 01:14:02PM -0700, Siddha, Suresh B wrote:
> > On Wed, Aug 06, 2008 at 10:33:25AM -0700, Wolfgang Walter wrote:
> > > Hello Herbert,
> > >
> > > I think I finally found the problem.
> > >
> > > Here a short description again: all our routers with a via C3 using 
padlock for AES-encryption are
> > > crashing with 2.6.26 while they work fine with 2.6.25. Not using padlock
> > > (i.e. using the i386 assembler version of AES) they just work fine.
> > 
> > Both the padlock version or asm version don't use FP/math registers, 
right?
> > It is interesting that you don't see the problem with asm version
> > but see the problem with padlock version.
> > 
> > Does disabling CONFIG_PREEMPT in 2.6.26 change anything? And also,
> > can you provide the complete kernel log till the point of failure(oops
> > that you sent doesn't have the call trace info)
> 
> BTW, in one of your oops, I see:
> 
> note: cron[1207] exited with preempt_count 268435459
> 
> I smell some kind of stack corruption here which is corrupting
> thread_info (in the above case preempt_count in the thread_info).
> 

I don't think 268435459 is a strong indication of stack corruption:

268435459 == 0x10000003 == PREEMPT_ACTIVE|0x03

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
