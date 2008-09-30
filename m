Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYI3QPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYI3QPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYI3QO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:14:59 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:55019 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbYI3QO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:14:58 -0400
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <20080930154553.GA29249@us.ibm.com>
References: <20080924090317.359685535@nttdata.co.jp>
	 <20080924090338.407746083@nttdata.co.jp>
	 <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp>
	 <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp>
	 <20080930154553.GA29249@us.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 30 Sep 2008 12:14:48 -0400
Message-Id: <1222791288.19676.114.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-30 at 10:45 -0500, Serge E. Hallyn wrote:
> Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> > Serge E. Hallyn wrote:
> > > Unfortunately I think that is a shortcoming in the security_path_*
> > > patchset.  Unfortunate bc that is going to be a pain to work out.
> > Thanks for your constructive and tough suggestion. ;-)
> > 
> > > So for starters,
> > > both vfs_mknod and vfs_create do may_create, so just pull that
> > > into the callers.
> > Do you mean that we should move DAC code to all the caller of vfs_* ? 
> 
> That's not reasonable, is it.
> 
> The rule thus far has been 'DAC before MAC'.  Question to all:  do we
> insist on keeping it that way?

It isn't a hard rule; there are already some hooks that occur before the
DAC checking, e.g. setattr, because the DAC checking happens in the fs
code as part of the inode op.  But when possible, we prefer DAC before
MAC for SELinux so that we don't get noise in the audit logs from
harmless application/library probing that would be denied by DAC anyway.
Same issue would seemingly apply for learning modes of TOMOYO or
AppArmor.

> If the answer is yes, then the security_path_hooks patch is inherently
> wrong.
> 
> If the answer is no, then Kentaro doesn't need to resort to this
> ugliness to try and get may_delete() called before his MAC code, only to
> have may_delete() called a second time from the vfs_* functions.

-- 
Stephen Smalley
National Security Agency

