Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYDIMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYDIMvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 08:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYDIMvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 08:51:02 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:54430 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbYDIMvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:51:00 -0400
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Toshiharu Harada <haradats@nttdata.co.jp>
Cc: Paul Moore <paul.moore@hp.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>
In-Reply-To: <47FC8052.9070409@nttdata.co.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
	 <20080404122408.986477936@I-love.SAKURA.ne.jp>
	 <200804071140.59247.paul.moore@hp.com>  <47FC8052.9070409@nttdata.co.jp>
Content-Type: text/plain; charset=utf-8
Organization: National Security Agency
Date: Wed, 09 Apr 2008 08:49:17 -0400
Message-Id: <1207745357.21223.391.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-09 at 17:37 +0900, Toshiharu Harada wrote:
> On 4/8/2008 12:40 AM, Paul Moore wrote:
> > On Friday 04 April 2008 8:23:12 am Tetsuo Handa wrote:
> >> This file contains modifications against kernel source code
> >> needed to use TOMOYO Linux 1.6.
> >>
> >> Although LSM hooks are provided for performing access control,
> >> TOMOYO Linux 1.6 doesn't use LSM because of the following reasons.
> > 
> > Hello,
> > 
> > I understand your frustration with the existing LSM hooks/API and your 
> > reasoning for abandoning LSM in favor of a new set of hooks, however, I 
> > think this sets a dangerous precedence which could result in an 
> > abundance of security related hooks scattered throughout the kernel.  I 
> > would much rather see the LSM API extended/tweaked to support the needs 
> > of SAKURA and TOMOYO than ignored and duplicated; I suspect several 
> > others will say the same.
> > 
> > You have made good progress with TOMOYO so far and if I can remember 
> > correctly you really only have one hurdle left, the VFS portion.  
> > Please continue to seek a solution to this that fits within the LSM 
> > framework.
> > 
> > Thank you.
> 
> Thank you for your comments and concern.
> 
> I realized that we should have included the reason why we decided to
> post non-LSM version. Let me explain the reason and the history.
> 
> We started developing TOMOYO Linux as original patch sets against
> 2.4 vanilla kernel. We understand the role of LSM, so we ported
> TOMOYO Linux to use LSM and submitted it to the LKML on 13 June 2007.
> We kept working to reflect feedbacks from the community and believe
> no critical Nack remains.
> 
> http://lwn.net/Articles/238049/
> http://lwn.net/Articles/246930/
> http://lwn.net/Articles/252652/
> http://lwn.net/Articles/254503/
> http://lwn.net/Articles/258905/
> http://lwn.net/Articles/263179/
> http://lwn.net/Articles/264187/
> http://lwn.net/Articles/276603/
> 
> Still there remains an issue of LSM limitation (vfsmount parameter
> isn’t passed to LSM).
> 
> LWN article 239962 says, "At the 2006 summit, Linus took a clear
> position that the use of pathnames for security policies seemed
> reasonable to him". Current LSM implementation is sufficient for SELinux
> and other label based MACs but not for pathname-based MACs.
> This has been argued in the AppAmor thread for quite a long time.
> Though proposals had been posted by AppArmor and TOMOYO Linux project,
> none has been merged until now.
> 
> We apologize for the confusion we caused in the last posting,
> but we don't want to give up returning our work to the mainline. 
> 
> We cordially request LSM changes to pass vfsmount parameters.

Don't cordially request it - submit patches to make it happen.  Or work
with others who have been submitting such patches.

There are two options:
1) Submit patches to pass down the vfsmounts to the vfs helpers so that
they can be passed to the existing security_inode hooks. -or-
2) Submit patches to add new security hooks to the callers where the
vfsmount is already available (some have suggested moving the existing
security_inode hooks to the callers, but that would cause problems for
SELinux as I've posted elsewhere, so adding new hooks is preferable, and
then SELinux can just default to the dummy functions for those new
hooks).

-- 
Stephen Smalley
National Security Agency

