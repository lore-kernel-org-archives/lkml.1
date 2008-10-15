Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYJONmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYJONmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYJONmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:42:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60115 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYJONmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:42:31 -0400
Date: Wed, 15 Oct 2008 08:42:04 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
Message-ID: <20081015134204.GA26886@us.ibm.com>
References: <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk> <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org> <20081007222726.GA9465@kroah.com> <48EBF21E.40709@kernel.org> <m1myh8rnf4.fsf@frodo.ebiederm.org> <48F45075.7000003@kernel.org> <20081014185320.GA24908@us.ibm.com> <m13aiyk7jf.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13aiyk7jf.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > Again fuse doesn't address the *core* issue (sysfs needing a way to
> > create files for multiple devicenames with same name).  But I believe
> > Benjamin was looking into a minimal patch to fix that.  Benjamin,
> > have you gotten anywhere with that?
> 
> I would love to hear a minimal strategy for that.

Oh I just meant for kernel-space.  So if a container is creating lo,
it will create a device named lo, but the sysfs file will be called
lo_1 or something.

> The only minimal strategy user space wise is to create multiple superblocks.
> Anything else I an think of violates backwards compatibility.

Yes, the above would require that the container either not mount
sysfs, ignore sysfs, or tweak sysfs using
	mount -t tmpfs none /sys/class/net
	mount --bind /sys/devices/virtual/net/lo_1 /sys/class/net/lo
or using fuse.

I'd definately prefer the sysfs tagging approach.  But I'd prefer
the above over never being able to use network namespaces on a
standard distro (with sysfs enabled).

-serge
