Return-Path: <linux-kernel-owner+w=401wt.eu-S2993093AbXDRTmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993093AbXDRTmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXDRTmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:42:47 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36631 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbXDRTmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:42:46 -0400
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <E1HeFbh-0004c2-00@dorka.pomaz.szeredi.hu>
References: <20070412164541.580374744@szeredi.hu>
	 <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	 <1176713221.9488.17.camel@ram.us.ibm.com>
	 <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	 <1176716941.9488.57.camel@ram.us.ibm.com>
	 <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
	 <1176743669.9488.62.camel@ram.us.ibm.com>
	 <E1HdVLi-0007oe-00@dorka.pomaz.szeredi.hu>
	 <20070417170737.GA14891@sergelap.austin.ibm.com>
	 <E1Hdrir-0002E8-00@dorka.pomaz.szeredi.hu>
	 <1176838111.2813.109.camel@ram.us.ibm.com>
	 <E1Hdtai-0002Ri-00@dorka.pomaz.szeredi.hu>
	 <1176841504.2813.124.camel@ram.us.ibm.com>
	 <E1He6KI-0003Zl-00@dorka.pomaz.szeredi.hu>
	 <1176921319.2848.56.camel@ram.us.ibm.com>
	 <E1HeFbh-0004c2-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 12:41:07 -0700
Message-Id: <1176925268.2848.67.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 21:14 +0200, Miklos Szeredi wrote:
> > As I said earlier, I see a case where two mounts that are peers of each
> > other can become un-identical if we dont propagate the "allowusermnt".
> > 
> > As a practical example.
> > 
> > /tmp and /mnt are peers of each other.
> > /tmp has its "allowusermnt" flag set, which has not been propagated
> > to /mnt.
> > 
> > now a normal-user mounts an ext2 file system under /tmp at /tmp/1
> > 
> > unfortunately the mount wont appear under /mnt/1 
> 
> Argh, that is not true.  That's what I've been trying to explain to
> you all along.

I now realize you did, but I failed to catch it. sorry :-(

> 
> The propagation will be done _regardless_ of the flag.  The flag is
> only checked for the parent of the _requested_ mount.  If it is
> allowed there, the mount, including any propagations are allowed.  If
> it's denied, then obviously it's denied everywhere.
> 
> > and in case if you allow the mount to appear under /mnt/1, you will
> > break unpriviledge mounts semantics which promises: a normal user will
> > not be able to mount at a location that does not allow user-mounts.
> 
> No, it does not promise that.  The flag just promises, that the user
> cannot _request_ a mount on the parent mount.

ok. if the ability for a normal user to mount something *indirectly*
under a mount that has its 'allowusermnt flag' unset, 
is acceptable under the definition of 'allowusermnt', i guess my only
choice is to accept it. :-)

RP

> 
> Miklos

