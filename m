Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbYGBLt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbYGBLt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764021AbYGBLtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:49:36 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:51146 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbYGBLtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:49:35 -0400
Subject: Re: [patch] security: fix dummy xattr functions
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jjohansen@suse.de,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, serue@us.ibm.com, morgan@kernel.org
In-Reply-To: <Xine.LNX.4.64.0807021906350.26138@us.intercode.com.au>
References: <E1KDmeW-0006KB-2x@pomaz-ex.szeredi.hu>
	 <Xine.LNX.4.64.0807021604120.26138@us.intercode.com.au>
	 <E1KDwg7-0007OX-5D@pomaz-ex.szeredi.hu>
	 <Xine.LNX.4.64.0807021906350.26138@us.intercode.com.au>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 02 Jul 2008 07:48:36 -0400
Message-Id: <1214999316.22447.240.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-02 at 19:16 +1000, James Morris wrote:
> On Wed, 2 Jul 2008, Miklos Szeredi wrote:
> 
> > So where do the dummy_ functions figure into this?  As I understand,
> > they are called whenever LSM is disabled, but the LSM doesn't define a
> > particular hook, so there's a default implementation.  Is that correct?
> 
> If LSM is disabled, nothing is called (the security hooks are optimized 
> away).  It's for when LSM is enabled, but there is either no LSM module 
> selected, or as fallbacks for hooks which are not implemented by an LSM 
> module.
> 
> > If so, then in theory it is still theoretically possible that with
> > LSM+capabilities, the LSM doesn't explicitly stack inode_setxattr and
> > inode_removexattr, and so the dummy implementation should do that
> > instead.  What am I missing?
> 
> The LSM is responsible for performing this stacking (or not), depending on 
> which particular security models are desired.  It may, for example, not 
> want filesystem capabilities.
> 
> I guess it might be safer to force the LSM to override fs capabilities if 
> it doesn't want them, but I'd like to see what others think.

As discussed elsewhere, the dummy module just needs to die, and
capability needs to become the default module.  Then we no longer need
to deal with keeping them in sync or figuring out to emulate/fake
capabilities for userspace from dummy (since userspace expects them to
exist in Linux ever since they were first introduced long ago).

BTW, SELinux does not invoke the cap_ or dummy_
inode_setxattr/removexattr hooks as that would cause CAP_SYS_ADMIN to be
checked on the security.selinux attribute.  But
selinux_inode_setotherxattr() has the right logic.

-- 
Stephen Smalley
National Security Agency

