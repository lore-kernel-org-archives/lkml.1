Return-Path: <linux-kernel-owner+w=401wt.eu-S964817AbYCEBWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbYCEBWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934583AbYCEBUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:20:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763093AbYCEBUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:20:51 -0500
Date: Wed, 5 Mar 2008 01:19:45 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, kay.sievers@vrfy.org,
       Greg KH <gregkh@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>,
       dm-devel@redhat.com, "Zhang, Rui" <rui.zhang@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Re: 2.6.25-rc regression: kernel panic on boot
Message-ID: <20080305011945.GP1788@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, kay.sievers@vrfy.org,
	Greg KH <gregkh@suse.de>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Alexey Dobriyan <adobriyan@sw.ru>, dm-devel@redhat.com,
	"Zhang, Rui" <rui.zhang@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu> <20080304104312.457ba3a8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304104312.457ba3a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 10:43:12AM -0800, Andrew Morton wrote:
> Isn't the device-mapper kernel code capable of detecting the older userspace
> version and loudly warning about it?  That at least would prevent us from
> wasting lots of people's time like this.
 
It's not a device-mapper problem: It's between userspace LVM2 and kernel
sysfs.

LVM2 userspace expects a particular sysfs layout.  That layout got
changed without offering sufficient lead time (>6-9 months) for the
required userspace changes to propagate into the main versions of the
distros people use.

LVM2 userspace version 2.02.29 (released 5th December 2007) can handle
old and new layouts.  The patch was in the CVS head for a while before
that.  Earlier versions of LVM2 require CONFIG_SYSFS_DEPRECATED.  A
less-efficient workaround is to disable the use of sysfs in the LVM2
config: 'devices { sysfs_scan = 0 }'.

(I think the root cause of this mess was changing what
CONFIG_SYSFS_DEPRECATED did instead of adding a new setting that could
be enabled by default.)

Alasdair
-- 
agk@redhat.com
