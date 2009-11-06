Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbZKFMz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbZKFMz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 07:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbZKFMz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 07:55:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59361 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbZKFMzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 07:55:25 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] sysctl: Separate the binary sysctl logic into it's own file.
References: <m1tyx8trik.fsf@fess.ebiederm.org>
	<200911061004.01007.borntraeger@de.ibm.com>
	<m18wejanw4.fsf@fess.ebiederm.org> <200911061310.02785.arnd@arndb.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Nov 2009 04:55:23 -0800
In-Reply-To: <200911061310.02785.arnd@arndb.de> (Arnd Bergmann's message of "Fri\, 6 Nov 2009 13\:10\:02 +0100")
Message-ID: <m1ljij24p0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Friday 06 November 2009, Eric W. Biederman wrote:
>> Christian Borntraeger <borntraeger@de.ibm.com> writes:
>> 
>> > Am Freitag 06 November 2009 01:41:44 schrieb Eric W. Biederman:
>> >> From: Eric W. Biederman <ebiederm@xmission.com>
>> >> 
>> >> In preparation for more invasive cleanups separate the core
>> >> binary sysctl logic into it's own file.
>> >> 
>> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> >
>> > Hmm, with your patches on Linus git I get the following on s390:
>> >
>> > kernel/sysctl_binary.c: In function 'SYSC_sysctl':
>> > kernel/sysctl_binary.c:126: error: implicit declaration of function 
>> > 'lock_kernel'
>> > kernel/sysctl_binary.c:129: error: implicit declaration of function 
>> > 'unlock_kernel'
>> 
>> Bah.  A missing smp_lock.h.
>
> BTW, there is a patch in the kill-the-BKL tree to push down the BKL
> further into the sysctl handlers. It may be a good idea to put that
> into your tree, or to redo the same thing there differently, since
> you already have a patch series touching this area.

Thanks for the info.

The primary proc path already doesn't need the lock_kernel().  My next
patch winds up killing the entire binary path and rebuilding on top of
/proc/sys.  Which removes that lock_kernel().

Which I think elegantly solves all of the sysctl BKL lock issues.

Which is probably why I missed the compilation failure.

Eric


