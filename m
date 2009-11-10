Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbZKJIBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbZKJIBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZKJIBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:01:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47186 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZKJIBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:01:10 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
References: <m1pr7siqjz.fsf@fess.ebiederm.org>
	<m1zl6vvpiv.fsf@fess.ebiederm.org>
	<20091109132830.GF26740@basil.fritz.box>
	<200911091628.47003.arnd@arndb.de>
	<20091109154621.GG26740@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 10 Nov 2009 00:01:07 -0800
In-Reply-To: <20091109154621.GG26740@basil.fritz.box> (Andi Kleen's message of "Mon\, 9 Nov 2009 16\:46\:21 +0100")
Message-ID: <m1r5s6n70c.fsf@fess.ebiederm.org>
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

Andi Kleen <andi@firstfloor.org> writes:

>> can still use the  config option for the compatibility code.
>> There wouldn't even be a performance penalty over new glibc with
>> new kernels which already use procfs.
>
> When he drops the sysctl(2) API completely the old userland will
> be unhappy.

When it comes to breaking user space the issue is not glibc or
anything in a open source distribution.  There are maybe 3 apps that
are affected at all and as far as I can tell they were all fixed long
ago.  Last time I investigated this in 2007 none of the existing
userlands would break if sysctl was disabled completely.

The issue is all of the in-house and 3rd party software, that we don't
have access to.  We have no way of knowing what is used.  So I do not
favor a solution that kills some but not all sysctls.  Either you
might need them or you don't.

So the decision must be made to you break the rare app from the writer
who has given you no feed back after you have given him fair warning,
or do you try and support him forever, with code that no cares about
and no one tests.

I think the solution in sysctl_binary.c strikes a good balance there.
The code is simple and should survive a long time with little to no
maintenance, so it is good if we need decide we are too chicken to
disable the sysctl system call, and at the same time my changes remove
the support overhead from everywhere else.

Further with the existence of a single file for all of the binary
sysctls we can modify it to strike any other balance between long term
maintainability, and removal of unused cruft.

I am happy to see additional patches from anyone else who chooses to seek
a different balance.

Eric
