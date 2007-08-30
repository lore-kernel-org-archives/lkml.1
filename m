Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXH3D0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXH3D0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbXH3D0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:26:19 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39405 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757549AbXH3D0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:26:06 -0400
X-Sasl-enc: 6i6rKP7HBCR5KDQXzsJGSdPgCWZhJ58pp13B7T7Iu4z3 1188444363
Subject: RE: regression of autofs for current git?
From: Ian Kent <raven@themaw.net>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       autofs@linux.kernel.org, "'Adrian Bunk'" <bunk@kernel.org>
In-Reply-To: <010401c7eab3$38d16100$aa742300$@com>
References: <00f401c7ea7f$6db9fc80$492df580$@com>
	 <20070829224754.GW26410@stusta.de>
	 <1188442804.4090.10.camel@raven.themaw.net>
	 <010401c7eab3$38d16100$aa742300$@com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 11:25:58 +0800
Message-Id: <1188444358.4090.15.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 20:09 -0700, Hua Zhong wrote:
> I am in the process of bisecting now. It takes a while but the bad commit is
> between 2.6.22 and 13f9966b3ba5b45f47f2ea0eb0a90afceedfbb1f (June 28). I'll
> continue tomorrow.
> 
> My system is FC4. 
> 
> autofs-4.1.4-26
> nfs-utils-1.0.7-13.FC4
> 
> By the way, the particular autofs commit Andrian sent is innocent. It's
> something else.
> 
> It will still take me about 10 reboots to bisect. If anyone has a patch for
> me to try, I'll give it a shot tomorrow.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75180df2ed467866ada839fe73cf7cc7d75c0a22

This (and it's related patches) may be the problem.
I can probably tell if you post your map or if you strace the automount
process managing the a problem mount point and look for mount returning
EBUSY when it should succeed.

> 
> > -----Original Message-----
> > From: Ian Kent [mailto:raven@themaw.net]
> > Sent: Wednesday, August 29, 2007 8:00 PM
> > To: Hua Zhong
> > Cc: 'Linux Kernel Mailing List'; autofs@linux.kernel.org; Adrian Bunk
> > Subject: Re: regression of autofs for current git?
> > 
> > On Thu, 2007-08-30 at 00:47 +0200, Adrian Bunk wrote:
> > > On Wed, Aug 29, 2007 at 01:58:58PM -0700, Hua Zhong wrote:
> > >
> > > > Hi,
> > >
> > > Hi Hua,
> > >
> > > > I am wondering if this is a known issue, but I just built the
> > current git
> > > > and several autofs mounts mysteriously disappeared. Restarting
> > autofs could
> > > > fix some, but then lose others. 2.6.22 was fine.
> > > >
> > > > Is there anything I could check other than bisect? (It may take
> > some time
> > > > for me to get to it)
> > >
> > > the commit below is the only autofs4 patch that went into the git
> > tree
> > > since 2.6.22.
> > >
> > > Does reverting it fix your problems?
> > 
> > Maybe but there is an NFS change that appears to be in the current
> > 2.6.23-rc kernel and doesn't seem to be in 2.6.22 that is known to
> > break
> > some autofs maps and also breaks amd.
> > 
> > I can't seem to locate the commit just now.
> > In the meantime what version of user space autofs and nfs-utils are you
> > running?
> > And can you post your autofs maps please?
> > 
> > Ian
> > 
> > 
> 
> 

