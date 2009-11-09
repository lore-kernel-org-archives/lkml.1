Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbZKIFh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbZKIFh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 00:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZKIFh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 00:37:57 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59837 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZKIFh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 00:37:56 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
	<m1pr7siqjz.fsf@fess.ebiederm.org> <m1hbt4ipni.fsf@fess.ebiederm.org>
	<20091108164855.595ec70d@infradead.org>
	<m1tyx49y44.fsf@fess.ebiederm.org>
	<20091108205725.28778016@infradead.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 21:37:58 -0800
In-Reply-To: <20091108205725.28778016@infradead.org> (Arjan van de Ven's message of "Sun\, 8 Nov 2009 20\:57\:25 -0800")
Message-ID: <m1hbt45kcp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Sun, 08 Nov 2009 19:27:07 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> I just took a look and the use in linux threads that I don't warn
>> about is used by glibc-2.8 but not by glibc-2.10.  glibc-2.11 has just
>> been released. so by next year when the removal is scheduled we are
>> looking at multiple releases of glibc that don't use sys_sysctl.  So I
>> expect shortly I can warn about all uses of sys_sysctl without anyone
>> seeing a warning.
>
> hmmmmm it's still an ABI break, and while you say "oh it's 3 glibcs
> ago".. there's the static linking case.
>
> to be honest, I don't think we can ever remove things that are used by
> glibc during its startup....

The glibc pthread code that uses sysctl has no problems if sys_sysctl
is gone.  It both falls back to reading /proc/sys and it just controls
an optimization and the code works with either result.  Been there,
done that.

The only reason sys_sysctl remains is because there are a handful of
other apps that needed an appropriate warning time, and we weren't
doing anything that had a reasonable chance of notifying them.

I think it is worth getting us to the point where we can run with
sysctl disabled.  At the same time, this patchset gets 99%+ of the
benefit.  It isolates the entire binary interface into sysctl_binary.c
so outside of that one file we have no maintenance overhead in
maintaining the binary interface, and anyone who is trying to optimize
for kernel size can trivially turn it off.

Which allows the kernel development to proceed as if the sysctl binary
interface does not exist, as it has largely always done.

Eric
