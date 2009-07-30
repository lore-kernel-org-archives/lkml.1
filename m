Return-Path: <linux-kernel-owner+w=401wt.eu-S1751992AbZG3JRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbZG3JRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZG3JRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:17:00 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42013 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbZG3JQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:16:59 -0400
Subject: Re: Possible memory leak via alloc_pid()
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090730003658.GA27040@us.ibm.com>
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com>
	 <20090729170315.f62066c0.akpm@linux-foundation.org>
	 <20090730003658.GA27040@us.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 30 Jul 2009 10:16:15 +0100
Message-Id: <1248945375.3376.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 09:16:16.0729 (UTC) FILETIME=[647B6C90:01CA10F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 19:36 -0500, Serge E. Hallyn wrote:
> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Wed, 8 Jul 2009 22:33:31 +0100
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > There's a kmemleak report of a struct pid allocation in alloc_pid()
> > > which somehow gets lost:
[...]
> > > This is the gdm fork for starting Xorg (with pid 2739). It first
> > > logged me in automatically, after which I logged out and gdm started
> > > another Xorg. The pid structure for the first Xorg is reported as a
> > > leak. The Xorg with pid 2739 is no longer present on my system.
> > > 
> > > Using gdb vmlinux /proc/kcore shows that the pid->count is 2, so
> > > that's why it probably wasn't freed by put_pid():
[...]
> thanks for the report.  Note that kernel modules can increment those
> counds through find_get_pid().  

It is possible that there are more *get_pid() calls than put_pid() but I
couldn't track them.

> Can you send your kernel .config and
> the output of lsmod?

I logged this as http://bugzilla.kernel.org/show_bug.cgi?id=13868. I
uploaded the ARM .config file (no modules loaded). I'll upload the x86
config as well later today (it's on my home machine but it's pretty much
the default Ubuntu 9.04 .config with CONFIG_KMEMLEAK enabled).

Thanks.

-- 
Catalin

