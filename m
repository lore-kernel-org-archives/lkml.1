Return-Path: <linux-kernel-owner+w=401wt.eu-S1422707AbXDRJUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422707AbXDRJUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422709AbXDRJUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:20:53 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:59034 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXDRJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:20:52 -0400
To: linuxram@us.ibm.com
CC: serue@us.ibm.com, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <1176841504.2813.124.camel@ram.us.ibm.com> (message from Ram Pai
	on Tue, 17 Apr 2007 13:25:04 -0700)
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
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
	 <E1Hdtai-0002Ri-00@dorka.pomaz.szeredi.hu> <1176841504.2813.124.camel@ram.us.ibm.com>
Message-Id: <E1He6KI-0003Zl-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Apr 2007 11:19:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Allowing this and other flags to NOT be propagated just makes it
> > possible to have a set of shared mounts with asymmetric properties,
> > which may actually be desirable.
> 
> The shared mount feature was designed to ensure that the mount remained
> identical at all the locations.

OK, so remount not propagating mount flags is a bug then?

> Now designing features to make it un-identical but still naming it
> shared, will break its original purpose.  Slave mounts were designed
> to make it asymmetric.

What if I want to modify flags in a master mount, but not the slave
mount?  Would I be screwed?  For example: mount is read-only in both
master and slave.  I want to mark it read-write in master but not in
slave.  What do I do?

> Whatever feature that is desired to be exploited; can that be exploited
> with the current set of semantics that we have? Is there a real need to
> make the mounts asymmetric but at the same time name them as shared?
> Maybe I dont understand what the desired application is? 

I do think this question of propagating mount flags is totally
independent of user mounts.

As it stands, currently remount doesn't propagate mount flags, and I
don't see any compelling reasons why it should.

The patchset introduces a new mount flag "allowusermnt", but I don't
see any compelling reason to propagate this flag _either_.

Please say so if you do have such a reason.  As I've explained, having
this flag set differently in parts of a propagation tree does not
interfere with or break propagation in any way.

Miklos


