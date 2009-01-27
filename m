Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZA0Vrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZA0Vrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZA0Vri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:47:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40979 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZA0Vrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:47:37 -0500
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Migration of kernel interfaces to seq_files breaks pread() consumers
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
	<20090124181924.d633523c.akpm@linux-foundation.org>
	<20090125120818.GA4454@x200.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Jan 2009 13:47:44 -0800
In-Reply-To: <20090125120818.GA4454@x200.localdomain> (Alexey Dobriyan's message of "Sun\, 25 Jan 2009 15\:08\:18 +0300")
Message-ID: <m1r62obev3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, linux-kernel@vger.kernel.org, pjt@google.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Sat, Jan 24, 2009 at 06:19:24PM -0800, Andrew Morton wrote:
>> On Fri, 16 Jan 2009 23:51:35 -0800 (PST) Paul Turner <pjt@google.com> wrote:
>> 
>> > 
>> > (Specifically) Several interfaces under /proc have been migrated to use 
>> > seq_files.  This was previously observed to be a problem with VMware's 
>> > reading of /proc/uptime.  We're now running into the same problem on  
>> > /proc/<pid>/stat; we have many consumers performing preads on this 
>> > interface which break under new kernels.
>> > 
>> > Reverting these migrations presents other problems and doesn't scale with 
>> > everyones' pet dependencies over an abi that's been
>> > broken :(
>> 
>> We changed userspace-visible behaviour and broke real applications. 
>> This is a serious matter.  So serious in fact that your report has
>> languished without reply for a week.
>> 
>> Reverting those changes until we have a suitable reimplementation which
>> doesn't bust userspace is 100% justifiable.
>> 
>> In which kernel versions is this regression present?
>> 
>> What would a revert look like?  Big and ugly or small and simple?  Do
>> the original commits (which were they?) still revert OK?
>
> This is bug http://bugzilla.kernel.org/show_bug.cgi?id=11856
> Some of us think what to do here.
>
> Original patch not revertable as is.

Interesting.  This seems like a bug in seq_file plain and simple.
Userspace appears to be acting very reasonable in this case.

Why is there a notion that we have to differentiate between read
and pread in seq_file to fix this.  That doesn't make much sense.

Anyway here is an untested but logically correct patch which should fix
this issue, without nasty special casing of pread.

Eric
