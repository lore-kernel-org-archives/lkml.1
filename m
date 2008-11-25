Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYKYOcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYKYOcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYKYOcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:32:11 -0500
Received: from ns1.suse.de ([195.135.220.2]:47195 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYKYOcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:32:11 -0500
Date: Tue, 25 Nov 2008 15:32:07 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, wim@iguana.be,
       stable@kernel.org, Thomas.Mingarelli@hp.com
Subject: Re: [PATCH] [WATCHDOG] Fix kdump when using hpwdt
Message-ID: <20081125153207.4f5ea2ac@hale.suse.de>
In-Reply-To: <20081125142751.GD341@redhat.com>
References: <1227446124-10856-1-git-send-email-bwalle@suse.de>
	<20081125142751.GD341@redhat.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal [2008-11-25 09:27]:
>
> On Sun, Nov 23, 2008 at 02:15:24PM +0100, Bernhard Walle wrote:
> > When the "hpwdt" module is loaded (even if the /dev/watchdog device is not
> > opened), then kdump does not work. The panic kernel either does not start at
> > all or crash in various places.
> > 
> > The problem is that hpwdt_pretimeout is registered with register_die_notifier()
> > with the highest possible priority. Because it returns NOTIFY_STOP, the
> > crash_nmi_callback which is also registered with register_die_notifier() is
> > never executed. This causes the shutdown of other CPUs to fail.
> > 
> > Reverting the order is no option: The crash_nmi_callback executes HLT and so
> > never returns normally. Because of that, it must be executed as last notifier,
> > which currently is done.
> > 
> > So, that patch returns NOTIFY_OK to keep the crash_nmi_callback executed.
> 
> Hi Bernhard,
> 
> Why does this handler need to run after a crash? IOW, even if kdump NMI
> handler halts the cpu, and this handler never gets a chance to run, is 
> that an issue.

Hi Vivek,

Because otherwise the crashkernel receives NMIs and crashes ... it just
doesn't work. The watchdog guys should be able to provide technical
details here.


Regards,
Bernhard

