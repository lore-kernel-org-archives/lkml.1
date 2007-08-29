Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbXH2HOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbXH2HOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 03:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXH2HOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 03:14:36 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46888 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751089AbXH2HOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 03:14:35 -0400
Message-ID: <388371672.15782@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 29 Aug 2007 15:14:32 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to find out how many other processes share VM with $PID?
Message-ID: <20070829071432.GA5777@mail.ustc.edu.cn>
References: <200708271256.31874.vda.linux@googlemail.com> <200708271426.50675.vda.linux@googlemail.com> <388259805.10631@ustc.edu.cn> <200708282100.41443.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708282100.41443.vda.linux@googlemail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 09:00:41PM +0100, Denys Vlasenko wrote:
> On Tuesday 28 August 2007 01:10, Fengguang Wu wrote:
> > > > There is a nice LWN article on this issue:
> > > >         ELC: How much memory are applications really using?
> > > >         http://lwn.net/Articles/230975/
> > > >
> > > > Another helpful patch could be:
> > > >         maps: PSS(proportional set size) accounting in smaps
> > > >         http://lkml.org/lkml/2007/8/19/23
> > >
> > > Thanks a lot, very useful pages indeed.
> > >
> > > However they still don't explain how I can avoid counting memory
> > > twice for /proc/PID1 and /proc/PID2 when PID2 is a child of PID1,
> > > created with CLONE_VM.
> > >
> > > The example: I allocate 1234k, dirty it, then clone with CLONE_VM.
> > > I will seemingly have two processes, each using 1234k, _privately_
> > > (i.e., pages are not shown as shared in smaps) -
> > > which is technically correct, pages are not shared with other VMs,
> > > but they ARE shared by means of these two processes having the same VM!
> > >
> > > How userspace tools can figure out that these processes have shared VM?
> > >
> > > IOW: do we need "VMsharecount: N" in addition to "Threads: N"
> > > in /proc/PID/status?
> >
> > A full solution would require two parameters, i.e. VmUsers/VmMagic.
> >
> > But please make sure the new lines won't break important tools like
> > ps/top/pmaps/...
> 
> Should be safe - tools skip lines they do not recognize.

Except yours ;-)

FYI, I found another tool that depends on status: atop.

> Ok, we have "Threads: N".
> 
> I can cook up a patch which adds count of processes
> which share VM with us - it's just atomic_read(&current->mm->mm_users).

Yeah, the code itself would be simple.

> What name do you like? 
> 
> SharedVmCount: N
> VmUsers: N
> other?

I'd prefer VmUsers: that's the choice of source code.

Fengguang

