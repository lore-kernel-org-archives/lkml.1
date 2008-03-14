Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbYCNN3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbYCNN3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYCNN27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:28:59 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:41608 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYCNN26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:28:58 -0400
Subject: Re: [PATCH] cgroups: implement device whitelist lsm (v3)
From: Stephen Smalley <sds@epoch.ncsc.mil>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Casey Schaufler <casey@schaufler-ca.com>, Greg KH <greg@kroah.com>,
       Pavel Emelianov <xemul@openvz.org>
In-Reply-To: <Xine.LNX.4.64.0803142039460.32184@us.intercode.com.au>
References: <20080313144142.GB11265@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803142039460.32184@us.intercode.com.au>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 14 Mar 2008 09:27:28 -0400
Message-Id: <1205501248.22912.35.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 21:17 +1100, James Morris wrote:
> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> 
> > Implement a cgroup using the LSM interface to enforce open and mknod
> > on device files.
> 
> Actually, I'm not sure that the LSM approach in general is best here.
> 
> The LSM model is that standard DAC logic lives in the core kernel, and 
> that extended security logic (e.g. MAC) is called after DAC via hooks.  
> cgroups has introduced new security logic of its own, which is arguably 
> "standard DAC" when cgroups is enabled.
> 
> I can understand Greg not wanting this security logic in the core kernel, 
> but it is specific to cgroups (which itself is security model agnostic) 
> and does not stand alone as a distinct security framework.
> 
> The fact that all existing LSMs need to invoke exactly the same code is an 
> indicator that it doesn't belong in LSM.
> 
> Moving this logic into LSM means that instead of the cgroups security 
> logic being called from one place in the main kernel (where cgroups 
> lives), it must be called identically from each LSM (none of which are 
> even aware of cgroups), which I think is pretty obviously the wrong 
> solution.
> 
> This is baggage which comes with cgroups -- please don't push it into LSM 
> to try and hide that.

I agree with the above, and would further note that I would expect the
SELinux solution to the problem would be done not by stacking with or
calling this device whitelist lsm but instead by introducing the ability
to bind security labels to devices within the kernel (independent of the
particular device node(s) in the filesystem used to access that device)
and applying permission checks on those device labels when processes
attempt to create or access those devices (again independent of the
particular device node used to access them).  That keeps the policy
integrated and analyzable and avoids an external dependency.

-- 
Stephen Smalley
National Security Agency

