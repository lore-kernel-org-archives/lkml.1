Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbYHHXKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbYHHXKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYHHXKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:10:45 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:53031 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbYHHXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:10:44 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Sat, 9 Aug 2008 01:10:42 +0200
User-Agent: KMail/1.9.9
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200807171653.59177.wolfgang.walter@stwm.de> <200808082109.47284.wolfgang.walter@stwm.de> <20080808193252.GD607@linux-os.sc.intel.com>
In-Reply-To: <20080808193252.GD607@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808090110.42391.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008, Suresh Siddha wrote:
> On Fri, Aug 08, 2008 at 12:09:46PM -0700, Wolfgang Walter wrote:
> > I don't know though why kernel_fpu_begin exactly fixes the problem:
> 
> because it prevents taking a DNA fault inside the kernel (resulting
> in TS_USEDFPU not set).
> 
> > 
> > Maybe preemption must be disabled when padlocks RNG, ACE, Hash-engine etc. 
is
> > used. Maybe just some barrier is needed which preempt_disable provides.
> 
> problem can happen even when preemption is disabled.
> 
> > What should I do now?
> 
> I will post your fix(including the other usages) with the appropriate 
changelog
> shortly.
> 

Fine.

By the way, if padlock is used from userspace, could this be aproblem, too? I 
mean not via the kernel crypto layer but directly. I think these extensions 
are not restricted to a privileged user.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
Leiter EDV
Leopoldstraße 15
80802 München
Tel: +49 89 38196-276
Fax: +49 89 38196-144
wolfgang.walter@stwm.de
http://www.studentenwerk-muenchen.de/
