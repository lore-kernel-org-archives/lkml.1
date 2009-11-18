Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZKRA2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZKRA2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZKRA2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:28:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59452 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZKRA23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:28:29 -0500
To: David VomLehn <dvomlehn@cisco.com>
Cc: dedekind1@gmail.com, Marco Stornelli <marco.stornelli@gmail.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
References: <1258463404.27437.103.camel@localhost>
	<m1pr7hf93s.fsf@fess.ebiederm.org>
	<20091117235627.GA13469@dvomlehn-lnx2.corp.sa.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 16:28:22 -0800
In-Reply-To: <20091117235627.GA13469@dvomlehn-lnx2.corp.sa.net> (David VomLehn's message of "Tue\, 17 Nov 2009 18\:56\:27 -0500")
Message-ID: <m1iqd8ptg9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn <dvomlehn@cisco.com> writes:

> On Tue, Nov 17, 2009 at 10:45:43AM -0500, Eric W. Biederman wrote:
> ...
>> Why not use the kdump hook?  If you handle a kernel panic that way
>> you get enhanced reliability and full user space support.  All in a hook
>> that is already present and already works.
>
> I'm a big fan of avoiding reinvention of the wheel--if I can use something
> already present, I will. However, I'm not clear about how much of the problem
> I'm addressing will be solved by using a kdump hook. If I understand
> correctly, you'd still need a pseudo-file somewhere to actually get the data
> from user space to kernel space. *Then* you could use a kdump hook to
> transfer the data to flash or some memory area that will be retained across
> boots. Is this the approach to which you were referring? If so, I have a
> couple more questions:
>
> 1. In what ways would this be better than, say, a panic_notifier?

A couple of ways. 

- You are doing the work in a known good kernel instead of the kernel
  that just paniced for some unknown reason.
- All of the control logic is in user space (not the kernel) so you can
  potentially do something as simple as "date >> logfile" to get the
  date.

> 2. Where would you suggest tying in? (Particularly since not all architectures
>    currently support kdump)

No changes are needed kernel side.  You just need an appropriate kernel and
initrd for your purpose.

All of the interesting architectures support kexec, and if an
architecture doesn't it isn't hard to add.  The architecture specific
part is very simple.  A pain to debug initially but very simple.

Eric

