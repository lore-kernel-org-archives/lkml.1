Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZKFN6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZKFN6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZKFN6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:58:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50473 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZKFN6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:58:44 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] sysctl: Separate the binary sysctl logic into it's own file.
References: <m1tyx8trik.fsf@fess.ebiederm.org>
	<200911061310.02785.arnd@arndb.de> <m1ljij24p0.fsf@fess.ebiederm.org>
	<200911061411.19580.arnd@arndb.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Nov 2009 05:58:43 -0800
In-Reply-To: <200911061411.19580.arnd@arndb.de> (Arnd Bergmann's message of "Fri\, 6 Nov 2009 14\:11\:19 +0100")
Message-ID: <m1vdhnzre4.fsf@fess.ebiederm.org>
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

Arnd Bergmann <arnd@arndb.de> writes:

> On Friday 06 November 2009, Eric W. Biederman wrote:
>> The primary proc path already doesn't need the lock_kernel().  My next
>> patch winds up killing the entire binary path and rebuilding on top of
>> /proc/sys.  Which removes that lock_kernel().
>> 
>> Which I think elegantly solves all of the sysctl BKL lock issues.
>
> Yes, that sounds like an excellent plan, but I'm not completely sure
> if the lack of the BKL in the procfs case is intentional. As a
> particular case that I stumbled over, 'core_pattern' is read
> with the BKL held to protect against sysctl changing it, but
> it is changed with proc_dostring without the BKL.

Then that is a bug.  The bottom line is sys_sysctl never gets used
in practice, making the proc interface normative.

> Most uses of intvec or string seem to be racy and probably need
> a proper serialization method anyway.

That sounds familiar.  Of course in practice the changes are rare
enough and are of static variables that don't get reallocated
that I would be surprised if the lack of lacking ever causes
more more than temporary strange behavior.

Eric
