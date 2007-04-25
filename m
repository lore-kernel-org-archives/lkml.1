Return-Path: <linux-kernel-owner+w=401wt.eu-S1423236AbXDYGlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423236AbXDYGlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423238AbXDYGlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:41:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:51516 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423237AbXDYGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hjhwh1yqdBVmkMXTnApQG2jYUzYeXbhQnxFv9cqURF8K8KCxdSbbABHO+vouByJCvza4Pn045QznwxXNjGWakS9QZPcUVUM/Sw+FycBIb3ZD0OgmvjmXxn2HYGp27uSUTS9rGvbfqnhpFcXmVwTxcwBze4BVUPV7S+oBBJvTSkI=
Message-ID: <a44ae5cd0704242341n4c8d9eaaw4516759ff79e8cd5@mail.gmail.com>
Date: Tue, 24 Apr 2007 23:41:32 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- software suspend failed (1 tasks refusing to freeze)
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <20070424225429.544075c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com>
	 <20070424224137.0ccf7874.akpm@linux-foundation.org>
	 <a44ae5cd0704242249i210ba860i659c230b5dbb211c@mail.gmail.com>
	 <20070424225429.544075c8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 24 Apr 2007 22:49:48 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
>
> > On 4/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Tue, 24 Apr 2007 22:27:44 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> > >
> > > > [ 1251.506964] PM: Preparing system for mem sleep
> > > > [ 1251.514790] Stopping tasks ...
> > > > [ 1271.456065] Stopping user space processes timed out after 20
> > > > seconds (1 tasks refusing to freeze):
> > > > [ 1271.456243]  multiload-apple
> > > > [ 1271.456291] Restarting tasks ... done.
> > > >
> > > > This isn't happening under earlier builds I've tested.  How can I debug this?
> > > >
> > >
> > > hm, that's multiload-applet, some gnome thing.
> > >
> > > sysrq-T, perhaps?  Perhaps the process is sleeping in the kernel somewhere.
> >
> > Should I wait for the next patch from Tejun before retesting?  Perhaps
> > this suspend problem is a side effect of the locking problem he
> > mentioned.
>
> It's unlikely to be related to Tejun's sysfs changes.
>
I tried to reproduce this, but this time when I tried to suspend, the
machine just hung with a message showing saying the system was
suspending.  When I touched my Synaptics mousepad after about ten
seconds of waiting, the system suddenly suspended.  Upon resuming, I
checked dmesg and found the time seems to be totally out of whack:

[ 1334.589074] pci 0000:00:1f.6: LATE suspend
[ 1334.589080] Intel ICH 0000:00:1f.5: LATE suspend
[ 1334.589085] pci 0000:00:1f.3: LATE suspend
[ 1334.589091] pci 0000:00:1f.0: LATE suspend
[ 1334.589096] pci 0000:00:1e.0: LATE suspend, may wakeup
[ 1334.589102] pci 0000:00:02.1: LATE suspend
[ 1334.589108] pci 0000:00:02.0: LATE suspend
[ 1334.589113] pci 0000:00:00.3: LATE suspend
[ 1334.589118] pci 0000:00:00.1: LATE suspend
[ 1334.589124] agpgart-intel 0000:00:00.0: LATE suspend
[ 1334.589733]  hwsleep-0323 [03] enter_sleep_state     : Entering
sleep state [S3]
[18014527.889728] Intel machine check architecture supported.
[18014527.889749] Intel machine check reporting enabled on CPU#0.
[18014527.889783] Back to C!
[18014527.889783] agpgart-intel 0000:00:00.0: EARLY resume
[18014527.889783] PCI: Calling quirk c01c94b2 for 0000:00:00.0
