Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZJ2Bbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZJ2Bbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZJ2Bbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:31:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbZJ2Bbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:31:48 -0400
Date: Wed, 28 Oct 2009 18:28:58 -0700
From: Greg KH <gregkh@suse.de>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Brian Swetland <swetland@google.com>, Eric Miao <eric.miao@canonical.com>,
       kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
Message-ID: <20091029012857.GA30274@suse.de>
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com>
 <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com>
 <20091027140558.GA17208@suse.de>
 <4AE8E953.6090504@canonical.com>
 <20091029010419.GA18410@suse.de>
 <4AE8EBCB.5030102@canonical.com>
 <20091029011759.GA908@suse.de>
 <4AE8EF8C.9030805@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE8EF8C.9030805@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 09:27:40AM +0800, Bryan Wu wrote:
> Greg KH wrote:
> > On Thu, Oct 29, 2009 at 09:11:39AM +0800, Bryan Wu wrote:
> >> Greg KH wrote:
> >>> On Thu, Oct 29, 2009 at 09:01:07AM +0800, Bryan Wu wrote:
> >>>> Greg KH wrote:
> >>>>> On Tue, Oct 27, 2009 at 12:40:07PM +0800, Eric Miao wrote:
> >>>>>>> Compiling broke since commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
> >>>>>>>    headers: remove sched.h from poll.h
> >>>>>>>
> >>>>>>> Adding <linux/sched.h> to fix this compiling bug.
> >>>>> I have now just marked the android drivers as broken, as this is not the
> >>>>> only build error in them at the moment :(
> >>>>>
> >>>> Yeah, actually the drivers/staging/android/lowmemorykiller.c has been
> >>>> failing to compile for a long time, because that struct mm_struct does
> >>>> not have a field named oom_adj. All the Android drivers are compiled
> >>>> as modules in Ubuntu kernel package, except this one.
> >>>>
> >>>> Although Android public kernel is still in 2.6.29, it's own driver is
> >>>> totally different with our mainline staging version. Is there any plan
> >>>> to sync with it?
> >>> No, Google has abandoned any current effort to push code upstream for
> >>> the past year :(
> >>>
> >>> The android drivers are deleted in linux-next and will go away in 2.6.33
> >>> because of this.
> >>>
> >> Thanks a lot for this update. It looks like we need to consider to drop Android 
> >> modules in our Ubuntu kernel building somehow.
> > 
> > As no one is using them, it should be trivial to just change your kernel
> > config, right?
> > 
> 
> The reason we include them is that we wanna port the Android runtime environment 
> to Ubuntu. Then the Android applications can run on Android compatible Ubuntu OS 
> directly without any modification.
> 
> The Android runtime environment needs some Android drivers such as Binder.

Don't you also need the wakelocks and the hooks in the core of the
kernel to tie into the binder mess?

> But now, it is hard for us to do that without a workable Android drivers in 
> mainline.

Then push on Google to get them cleaned up and fixed!  Or do it
yourself, all I need is a developer to take ownership of the code.

thanks,

greg k-h
