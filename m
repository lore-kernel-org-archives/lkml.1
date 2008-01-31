Return-Path: <linux-kernel-owner+w=401wt.eu-S933661AbYAaSrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbYAaSrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763034AbYAaSrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:47:22 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49856 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759674AbYAaSrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:47:20 -0500
Subject: Re: [patch] vfs: create /proc/<pid>/mountinfo
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk,
       a.p.zijlstra@chello.nl
In-Reply-To: <E1JKVY6-0001wd-BE@pomaz-ex.szeredi.hu>
References: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu>
	 <20080130160839.828c4363.akpm@linux-foundation.org>
	 <E1JKVY6-0001wd-BE@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 10:45:23 -0800
Message-Id: <1201805123.10358.23.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 10:17 +0100, Miklos Szeredi wrote:
> > > From: Ram Pai <linuxram@us.ibm.com>

...snipped...

> IDR ids are 'int' but they are always positive (AFAICT), but yeah,
> maybe this is confusing.
> 
> > The new exported-to-everyone dentry_path() probably could do with a bit
> > more documentation - it's the sort of thing which people keep on wanting
> > and using.
> 
> OK.
> 
> > How does dentry_path() differ from d_path() and why do we need both and can
> > we get some sharing/consolidation happening here?

d_path displays the path from the rootfs, whereas dentry_path displays
the path from the root of that filesystem.

> 
> Tried that but not easy, without removing some of the
> microoptimizations in d_path(), which I'm not sure are really
> important, but...

this patch was intially developed with Al Viro. He preferred to keep the
two functions separate. BTW: this patch owes credits to Al Viro for his
initial set of ideas.

> 
> > Why do d_path() and dentry_path() have differing conventions for displaying
> > a deleted file and can we fix that?
> 
> I think Ram chose a different convention in dentry_path() in order to
> make sure, there was no space in the resulting path.  But spaces would
> be escaped anyway, so this isn't really important.  So yes, this could
> be fixed.


my patch was generated about  a year or so back using probably the
2.6.18 code base which had the "//deleted" convention. That got copied
in my patch. But since then I see that the original code has changed to
use the " (deleted)" convention. 

Yes this patch has to be changed to be consistent with the existing
code. 


> 
> > This patch adds a lot of code which is, I guess, unused if
> > CONFIG_PROC_FS=n.  Fixable?

yes. good observation. I will send a patch with this optimization and
the above mentioned change. 

RP

> 
> Possibly yes.  A good chunk of namespace.c could be surrounded by an
> #ifdef, which would save even more, than was added by this particular
> patch.


> Thanks,
> Miklos

