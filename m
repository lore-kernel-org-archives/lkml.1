Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYFKA65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYFKA65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYFKA6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:58:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:36814 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbYFKA6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:58:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,620,1204531200"; 
   d="scan'208";a="393337349"
Subject: Re: [linux-pm] [PATCH -mm 2/2] kexec jump -v11: save/restore
	device state
From: "Huang, Ying" <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806101400090.14381@localhost.localdomain>
References: <1213082106.22608.30.camel@caritas-dev.intel.com>
	 <alpine.LFD.1.10.0806101400090.14381@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jun 2008 09:01:14 +0800
Message-Id: <1213146074.21923.10.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 11 Jun 2008 00:58:43.0460 (UTC) FILETIME=[4B879440:01C8CB5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 14:01 -0400, Len Brown wrote:
> 
> On Tue, 10 Jun 2008, Huang, Ying wrote:
> 
> > This patch implements devices state save/restore before after kexec.
> > 
> > 
> > This patch together with features in kexec_jump patch can be used for
> > following:
> > 
> > - A simple hibernation implementation without ACPI support. You can
> >   kexec a hibernating kernel, save the memory image of original system
> >   and shutdown the system. When resuming, you restore the memory image
> >   of original system via ordinary kexec load then jump back.
> 
> What part of ACPI's role in hibernation are you trying to avoid
> 1. enabling wake devices
> 2. removing power from the system
> 3. something else?

ACPI S5 is used instead of S4 for this simple hibernation
implementation. That is, before creating the hibernation image, the ACPI
_PTS is not executed, devices are not put into low power state and wake
devices are not enabled. After creating the hibernation image, the image
is saved to disk and system is shutdown (go to S5). When resuming from
hibernated image, ACPI _BFS and _WAK are not executed too.

Best Regards,
Huang Ying

