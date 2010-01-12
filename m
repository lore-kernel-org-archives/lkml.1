Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669Ab0ALR5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0ALR5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630Ab0ALR5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:57:09 -0500
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:58544 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754229Ab0ALR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:57:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PDB9J3tkmXmfEIJsQVn9jG37euefQUth6wRQrpJ67GE9ElN6kEEW6UJpS/t3FfJKF8QgkE2k5gw0kB4mbG710H68xNaCFaentmtzuTQjk0oC29a2G3D6E2tv0MqJXapJ;
Date: Tue, 12 Jan 2010 09:57:02 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes the
 screen flicker
Message-ID: <20100112095702.4b22fcc1@jbarnes-piketon>
In-Reply-To: <1263318189.3284.2.camel@localhost.localdomain>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	<CXIfLt-ygXM.A.GGD.GilSLB@chimera>
	<1263228784.12830.0.camel@localhost.localdomain>
	<20100111085527.104f5c3e@jbarnes-piketon>
	<8B599161-2977-4A43-B88F-36E87AFCF4EA@m3y3r.de>
	<20100111111941.189eb41e@jbarnes-piketon>
	<1263318189.3284.2.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 18:43:09 +0100
Thomas Meyer <thomas@m3y3r.de> wrote:

> Am Montag, den 11.01.2010, 11:19 -0800 schrieb Jesse Barnes:
> > On Mon, 11 Jan 2010 20:03:57 +0100
> > Thomas Meyer <thomas@m3y3r.de> wrote:
> > 
> > > 
> > > 
> > > Am 11.01.2010 um 17:55 schrieb Jesse Barnes
> > > <jbarnes@virtuousgeek.org>:
> > > 
> > > > On Mon, 11 Jan 2010 17:53:04 +0100
> > > > Thomas Meyer <thomas@m3y3r.de> wrote:
> > > >
> > > >> Am Sonntag, den 10.01.2010, 23:56 +0100 schrieb Rafael J.
> > > >> Wysocki:
> > > >>> This message has been generated automatically as a part of a
> > > >>> report of regressions introduced between 2.6.31 and 2.6.32.
> > > >>>
> > > >>> The following bug entry is on the current list of known
> > > >>> regressions introduced between 2.6.31 and 2.6.32.  Please
> > > >>> verify if it still should be listed and let me know (either
> > > >>> way).
> > > >>>
> > > >>
> > > >> Yes, still should be listed.
> > > >>
> > > >> Problem still exists in 2.6.32.3 and 2.6.33-rc3-00097-g2c1f189,
> > > >> that contains
> > > >> this commit:
> > > >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cda9d05c499093c67b4a376a15009923acc2127a
> > > >>
> > > >> The above commit removes the render reclock support, that
> > > >> ought to fix a common kind of problem encountered on i915
> > > >> hardware, but not on my machine.
> > > >>
> > > >> Still need to boot with "nomodeset" to have a workable system.
> > > >
> > > > Does this patch prevent the flicker?
> > > 
> > > By the way: how often and in what interval is the function   
> > > intel_lvds_detect called?
> > > 
> > > How long will/can the function acpi_lid_open take to complete?
> > > Maybe some acpi interpretation takes really long? Is this
> > > possible?
> > > 
> > > Would this explain the flickering?
> > 
> > It should only be called when a client requests the connection
> > status (e.g. xrandr or the GNOME display applet).
> 
> how to check how often this function is called and it's duration? is
> the function tracer capable of this?

Yeah, the function tracer should be able to do it (though I don't know
how to use it offhand, maybe through the perf tool?).  Or you could
just add some DRM_ERROR lines. :)

> > The LVDS state will also be checked at ACPI LID event time, maybe
> > your platforms is getting spurious LID events?
> 
> maybe! where can I check this? acpid log file?

Yeah or using acpi_listen I think.

-- 
Jesse Barnes, Intel Open Source Technology Center
