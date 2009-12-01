Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZLAM1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZLAM1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZLAM1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:27:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbZLAM1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:27:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [linux-pm] intermittent suspend problem again
Date: Tue, 1 Dec 2009 13:28:15 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911291607.05348.rjw@sisk.pl> <87y6ln0yxp.fsf@tac.ki.iif.hu>
In-Reply-To: <87y6ln0yxp.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011328.15551.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 December 2009, Ferenc Wagner wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Sunday 29 November 2009, Ferenc Wagner wrote:
> >
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >>> On Saturday 28 November 2009, Ferenc Wagner wrote:
> >>>
> >>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >>>> 
> >>>>> Compile with CONFIG_PM_VERBOSE (it does mean exactly that).
> >>>> 
> >>>> The last message now was:
> >>>> 
> >>>> e100: 0000:02:08.0: hibernate, may wakeup
> >>>> 
> >>>> Looks like hibernating the e100 driver is unstable.
> >>>
> >>> Can you verify that by trying to hibernate without the e100 driver?
> >> 
> >> Not really, as I still can't reliable reproduce the issue.  Since I'm
> >> running with suspend loglevel = 8, it's happened only twice (in a row),
> >> with seemingly exact same console output.  Some earlier freezes also
> >> happened in dpm_suspend_start, at least.  However, I can certainly add
> >> e100 to SUSPEND_MODULES under /etc/pm/config.d, and continue running
> >> with that.
> >
> > That's what I'd do.
> 
> That worked out mosty OK (no freeze in quite some hibernation cycles),
> but I'm continuing testing it.

Great, please let me know how it works out.

> On the other hand, I reverted 8fbd962e3, recompiled and replaced the
> module, and got the freeze during hibernation.  And that was the bulk of
> the changes since 2.6.31...  I'll revert the rest and test again, but
> that seems purely cosmetic, so no high hopes.
> 
> > In addition to that, you can run multiple hibernation/resume cycles in
> > a tight loop using the RTC wakealarm.
> 
> I'll do so, as soon as I find a way to automatically supply the dm-crypt
> passphrase... or even better, learn to hibernate to ramdisk from the
> initramfs. :)

Well, you don't need to use swap encryptuon for _testing_. :-)

Thanks,
Rafael
