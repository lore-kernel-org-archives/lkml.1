Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbZFCFB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbZFCFB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbZFCFBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:01:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbZFCFBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:01:04 -0400
Date: Tue, 2 Jun 2009 21:55:51 -0700
From: Greg KH <gregkh@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-02-16-11 uploaded (staging)
Message-ID: <20090603045551.GA3869@suse.de>
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org> <4A25F814.7030101@oracle.com> <alpine.DEB.2.00.0906022132490.26434@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906022132490.26434@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:45:15PM -0700, David Rientjes wrote:
> On Tue, 2 Jun 2009, Randy Dunlap wrote:
> 
> > drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'
> > 
> 
> Thanks Randy.
> 
> This is due to oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch 
> which was merged in mmotm early this morning.
> 
> I had previously fixed this in an earlier version of the patch series, but 
> people didn't agree that an oom killer change should touch staging files 
> even though the Android lowmemorykiller is in both mmotm and git HEAD.  
> See http://marc.info/?l=linux-kernel&m=124200164711314.
> 
> I'm still a little curious about why it was decided like that since it 
> seems to be the simplest way to avoid these failures, which leave you with 
> a broken build, and an unnecessary burden on maintainers to magically fix 
> them up later (which I guess is now?).
> 
> So when I moved oomkilladj from struct task_struct to struct mm_struct and 
> renamed it to something more appropriate, I still think I should have been 
> able to change drivers/staging/android/lowmemorykiller.c for those 
> reasons and avoid all of this hassle.
> 
> Anyway, here's a patch that should work and will hopefully now be 
> accepted.  I know Greg is the maintainer for the staging tree and we're 
> talking about mmotm, but I don't know how else to do it anymore.

If Andrew took the change that caused this, then he can take the fixup
for the android code as well, no problem with me.

thanks,

greg k-h
