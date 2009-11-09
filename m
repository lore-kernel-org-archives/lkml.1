Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZKID1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZKID1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZKID1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:27:19 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33804 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZKID1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:27:11 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Leo Chen <leochen@broadcom.com>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
	<m1pr7siqjz.fsf@fess.ebiederm.org> <m1hbt4ipni.fsf@fess.ebiederm.org>
	<20091108164855.595ec70d@infradead.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 19:27:07 -0800
In-Reply-To: <20091108164855.595ec70d@infradead.org> (Arjan van de Ven's message of "Sun\, 8 Nov 2009 16\:48\:55 -0800")
Message-ID: <m1tyx49y44.fsf@fess.ebiederm.org>
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

> On Sun, 08 Nov 2009 15:05:05 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> >
>> > The practical difference is that /proc support now must be compiled
>> > in to support sys_sysctl.
>> 
>> But thanks for the reminder that I need to go into glibc and fix this
>> before we disable the sys_sysctl emulation by default.
>
> how are you dealing with existing glibcs ? Or with static linked
> binaries? or.. or ..
>
> breaking a heavily used ABI like this is not going to be pretty
> or even sane, no matter which way you hate the current one.

sysctl_binary.c has all of the code to continue to provide the
existing ABI.

sys_sysctl is not heavily used at all, and this is the responsible
removal of a practically unused ABI.  Last I check (and this was
before I shouted to the world that sys_sysctl is going away) I could
count on one hand all of the users of sys_sysctl.

/proc/sys will definitely continue to exist.

I just took a look and the use in linux threads that I don't warn
about is used by glibc-2.8 but not by glibc-2.10.  glibc-2.11 has just
been released. so by next year when the removal is scheduled we are
looking at multiple releases of glibc that don't use sys_sysctl.  So I
expect shortly I can warn about all uses of sys_sysctl without anyone
seeing a warning.

The one unfixed case I know about is fixing ioperm on arm, in the glibc
ports tree, and that will need to happen before sys_sysctl is disabled
by default.  Which is all I intend to do when we reach that point in
feature removal schedule now that I have refactored the code so that
sys_sysctl no longer imposes a maintenance burden on the sane sysctl
users.

I don't hate sysctl, in fact for global tuneables I would argue for
all it's faults sysctl it is one of the better interfaces we have.  I
just figure the implementation needs to be optimized for the way
sysctl is used today, the via /proc/sys.

Eric
