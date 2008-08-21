Return-Path: <linux-kernel-owner+w=401wt.eu-S1761105AbYHUT2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761105AbYHUT2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYHUT2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:28:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39702 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbYHUT2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:28:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Date: Thu, 21 Aug 2008 21:31:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com> <200808212107.42356.rjw@sisk.pl> <19f34abd0808211214x24af9351tcc077307fd1f2be5@mail.gmail.com>
In-Reply-To: <19f34abd0808211214x24af9351tcc077307fd1f2be5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212131.29906.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Vegard Nossum wrote:
> On Thu, Aug 21, 2008 at 9:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, 21 of August 2008, Vegard Nossum wrote:
> >> On Thu, Aug 21, 2008 at 8:31 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >> > On Thu, Aug 21, 2008 at 8:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >> On Thursday, 21 of August 2008, Vegard Nossum wrote:
> >> >>>
> >> >>> I just got this on v2.6.27-rc4 (+ unrelated fix):
> >> >>>
> >> >>> ACPI: Preparing to enter system sleep state S5
> >> >>
> >> >> This looks fishy.
> >> >>
> >> >> Please check what's there in /sys/power/disk .
> >> >>
> >>
> >> Sorry, forgot this one:
> >>
> >> # cat /sys/power/disk
> >> test testproc [shutdown] reboot
> >
> > Hm, I wonder why 'platform' isn't there.
> >
> > Perhaps the dmesg log will tell.
> >
> > [/me looks]
> >
> > No, it doesn't.  The BIOS evidently supports S4.
> >
> > [/me looks into the source code]
> >
> > I have no idea whatsoever how it is possible to have
> >
> > "ACPI: (supports S0 S1 S3 S4 S5)"
> >
> > in the log and not to have "platform" in the output of "cat /sys/power/disk".
> 
> I'm sorry, I made a stupid mistake: That file was taken from the
> system when it was booted with acpi=off. The boot log had acpi
> enabled, of course. Here is the same file (now booted without
> acpi=off):
> 
> # cat /sys/power/disk
> [platform] test testproc shutdown reboot
> 
> > Can you please add
> >
> > printk(KERN_CRIT "PM: hibernation_ops = %p\n", hibernation_ops);
> >
> > at the end of kernel/power/disk.c:hibernation_set_ops() and see if it gets
> > printed during boot?
> 
> I guess this is now not necessary anymore?

No, it's not.

Now, what is the source of the "SysRq : Power Off" in the dmesg you posted?

Also, have you tried to hibernate with the "platform" setting selected in
"cat /sys/power/disk" and if you have, does the lockdep warning appear in this
case?

Rafael

