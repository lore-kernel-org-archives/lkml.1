Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbXLIABp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbXLIABp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbXLIAB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:01:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbXLIAB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:01:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
Date: Sun, 9 Dec 2007 01:19:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1197042810.24045.61.camel@caritas-dev.intel.com> <20071208235344.GA17005@elf.ucw.cz>
In-Reply-To: <20071208235344.GA17005@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712090119.57826.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of December 2007, Pavel Machek wrote:
> Hi!
> 
> > This patch implements the functionality of jumping between the kexeced
> > kernel and the original kernel.
> > 
> > To support jumping between two kernels, before jumping to (executing)
> > the new kernel and jumping back to the original kernel, the devices
> > are put into quiescent state, and the state of devices and CPU is
> > saved. After jumping back from kexeced kernel and jumping to the new
> > kernel, the state of devices and CPU are restored accordingly. The
> > devices/CPU state save/restore code of software suspend is called to
> > implement corresponding function.
> > 
> > To support jumping without reserving memory. One shadow backup page
> > (source page) is allocated for each page used by new (kexeced) kernel
> > (destination page). When do kexec_load, the image of new kernel is
> > loaded into source pages, and before executing, the destination pages
> > and the source pages are swapped, so the contents of destination pages
> > are backupped. Before jumping to the new (kexeced) kernel and after
> > jumping back to the original kernel, the destination pages and the
> > source pages are swapped too.
> > 
> > A jump back protocol for kexec is defined and documented. It is an
> > extension to ordinary function calling protocol. So, the facility
> > provided by this patch can be used to call ordinary C function in real
> > mode.
> > 
> > A set of flags for sys_kexec_load are added to control which state are
> > saved/restored before/after real mode code executing. For example, you
> > can specify the device state and FPU state are saved/restored
> > before/after real mode code executing.
> > 
> > The states (exclude CPU state) save/restore code can be overridden
> > based on the "command" parameter of kexec jump. Because more states
> > need to be saved/restored by hibernating/resuming.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> I'm not kexec hacker... but maybe this is in good enough state to be
> merged? It is useful on its own: kexec jump and back means we can dump
> system then continue running, for example...

As far as I'm concerned, patches [1/4] and [2/4] can go.

The other two are not in that shape yet (especially the [3/4] patch).

Greetings,
Rafael
