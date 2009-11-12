Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZKLIJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZKLIJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZKLIJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:09:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40681 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZKLII6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:08:58 -0500
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sysctl tree build failure
References: <20091112184805.1c0720cb.sfr@canb.auug.org.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 12 Nov 2009 00:08:59 -0800
In-Reply-To: <20091112184805.1c0720cb.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Thu\, 12 Nov 2009 18\:48\:05 +1100")
Message-ID: <m1ljicp3l0.fsf@fess.ebiederm.org>
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

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> Today's linux-next build (powerpc allnoconfig) failed like this:
>
> kernel/built-in.o: In function `get_sysctl':
> sysctl_binary.c:(.text+0x100d4): undefined reference to `dev_get_by_index'
>
> Caused by commit 26a7034b40ba80f82f64fa251a2cbf49f9971c6a ("sysctl:
> Reduce sys_sysctl to a compatibility wrapper around /proc/sys").
>
> CONFIG_NET is not set for this build.
>
> I have used this patch for today:
> (It does produce this warning, though:
>
> kernel/sysctl_binary.c:1253: warning: unused variable 'net'
>
> so needs more work.)

Thank you, and my apologies.  I thought I had tried it with every
applicable compile option but apparently not.

Ugh.  It looks like I have a small refcount leak in that case as
well.  Blind I was.

Thank you very I will have this fixed shortly.

Eric

