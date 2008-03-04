Return-Path: <linux-kernel-owner+w=401wt.eu-S933364AbYCDTya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364AbYCDTya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764779AbYCDTwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:52:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:39188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765928AbYCDTws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:52:48 -0500
Date: Tue, 4 Mar 2008 11:33:48 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Zhang, Rui" <rui.zhang@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, dm-devel@redhat.com
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Message-ID: <20080304193348.GC5534@suse.de>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu> <20080304104312.457ba3a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304104312.457ba3a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 10:43:12AM -0800, Andrew Morton wrote:
> On Tue, 4 Mar 2008 14:54:47 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> > > On Mon, Mar 03, 2008 at 07:25:49AM +0800, Zhang, Rui wrote:
> > > > Hi, all,
> > > > 
> > > > kernel panic on boot when I try to run 2.6.25-rc1 and later, but 2.6.24-rc8 boots okay.
> > > > The result of git-bisect shows that
> > > > edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit.
> > > > 
> > > > The git-bisect-result and the dmesg log when the kernel panic are 
> > > > attached. Any help on this please? :)
> > > 
> > > Are you using LVM?  If so, please either upgrade your userspace/initrd 
> > > stuff, or enable CONFIG_SYSFS_DEPCRECATED
> > 
> > we _really_ must handle this differently and this _is_ a regression that 
> > multiple people have spent hours on bisecting already ...
> > 
> > So "enable CONFIG_SYSFS_DEPCRECATED" is _NOT_ the right answer, and this 
> > has been pointed out to you in the past.
> 
> Isn't the device-mapper kernel code capable of detecting the older userspace
> version and loudly warning about it?  That at least would prevent us from
> wasting lots of people's time like this.

Yes, this is an LVM issue with older userspace provided by some
distros, I think the dm code can notify the user about the problem, Kay
would know more.

The two distros I use here work just fine with this set to N :)

I have a patch queued up to change the wording of this config entry to
not say 2006, as that's not true anymore, and it should hopefully fix
some of the confusion here.

thanks,

greg k-h
