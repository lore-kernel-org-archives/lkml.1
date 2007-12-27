Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbXL0CdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbXL0CdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 21:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXL0CdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 21:33:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:5033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbXL0Cc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 21:32:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,209,1196668800"; 
   d="scan'208";a="257134579"
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071227015716.GA6718@redhat.com>
References: <1198222399.1965.15.camel@caritas-dev.intel.com>
	 <20071227015716.GA6718@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Dec 2007 10:33:13 +0800
Message-Id: <1198722793.7320.15.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 27 Dec 2007 02:32:55.0116 (UTC) FILETIME=[C93198C0:01C84830]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-26 at 20:57 -0500, Vivek Goyal wrote:
[...]
> > 9. Now, you are in the original kernel again. You can read/write the
> >    memory image of kexeced kernel via /proc/kimgcore.
> > 
> 
> Why do we need two interfaces, /proc/vmcore and /proc/kimgcore? Can't
> we have just one say /proc/vmcore. Irrespective of what kernel you are
> in /proc/vmcore gives you the access to the memory of kernel which was
> previously booted.

In theory we can kexec another kernel even in a kexeced kernel, that is,
in kernel A kexec kernel B, and in kernel B kexec another kernel C. In
this situation, both /proc/vmcore and /proc/kimgcore has valid contents.
So I think, it may be better to keep two interfaces.

In fact, current kexec jump implementation use a dummy "jump back helper
image" in kexeced kernel to jump back to the original kernel. The "jump
back helper image" has no PT_LOAD segment, it is used to provide a
struct kimage (including control page, swap page) and entry point to
jump back.

Best Regards,
Huang Ying
