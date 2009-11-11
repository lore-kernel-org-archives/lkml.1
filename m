Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZKKCbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZKKCbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbZKKCbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:31:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42043 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbZKKCbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:31:51 -0500
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
Date: Tue, 10 Nov 2009 18:31:51 -0800
In-Reply-To: <20091109154621.GG26740@basil.fritz.box> (Andi Kleen's message of "Mon\, 9 Nov 2009 16\:46\:21 +0100")
Message-ID: <m18wedeqqw.fsf@fess.ebiederm.org>
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

>> Can you name one binary sysctl value that gets accessed more
>> than a few times during the execution of a vaguely common
>> application? We're talking about microseconds for typically
>> write-once or read-once settings.
>
> For example shell scripts tend to execute programs quite a lot.
>
>> The question is just how many sysctl values you regard as both
>> common and performance critical.
>
> Very little, I suspect in fact it's only one.

I just took a second look, attempting to figure out how much startup
overhead my sysctl used.  I failed because I don't have a user space
old enough that it calls sysctl. I had to go back all of the way to
glibc-2.4 to find a version of nptl that calls sysctl at startup.
glibc-2.5 on i386 uses uname and all other architectures uses either
assumes smp is true or false without performing a system call.

I don't believe an inuse version of glibc exists that uses sysctl
except the ioperm implementation on arm.  So I can't see how being
a little slower will impact anyone.

Eric
