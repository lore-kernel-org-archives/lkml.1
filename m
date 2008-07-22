Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYGVMsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYGVMsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYGVMr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:47:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:1367 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYGVMr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vqEUS+JviyoIfKnVqMzpy6b2hwOukq8Mwp1cJXLkD7U2UjV+V9pXWz9XvHAocCOwVT
         87F6uNbGwYK6sVufKGgVa7eNuVBtAyuhoqJH343smWD5jkBGtmnGefyElpiuSEZ7Jnkj
         yJekph3h5GV/wZJBFuz6niOgZJcvcwvC89mws=
Message-ID: <cfd18e0f0807220547w691346ecyd4819fa4b7c23325@mail.gmail.com>
Date: Tue, 22 Jul 2008 14:47:56 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] coredump: format_corename: don't append .%pid if multi-threaded
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Roland McGrath" <roland@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
In-Reply-To: <20080722124314.GA3267@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807210137.m6L1bN0H011138@imap1.linux-foundation.org>
	 <20080721102940.666d733d@the-village.bc.nu>
	 <20080721210121.C5E741541A5@magilla.localdomain>
	 <20080721221416.6d4f9014@lxorguk.ukuu.org.uk>
	 <20080722113731.GA1383@tv-sign.ru> <20080722121824.GB1383@tv-sign.ru>
	 <cfd18e0f0807220521x5faea19bn1f545b23b84ead6a@mail.gmail.com>
	 <20080722124314.GA3267@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 2:43 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> On 07/22, Michael Kerrisk wrote:
>>
>> On Tue, Jul 22, 2008 at 2:18 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>> > If the coredumping is multi-threaded, format_corename() appends .%pid
>> > to the corename. This was needed before the proper multi-thread core
>> > dump support, now all the threads in the mm go into a single unified
>> > core file.
>> >
>> > Remove this special case, it is not even documented and we have "%p"
>> > and core_uses_pid.
>>
>> Hi Oleg,
>>
>> I have not thought about this at any length, but one question that
>> jumps to mind: could this feature still be useful for LinuxThreads,
>> where each thread does indeed have a separate PID?
>
> As far as I know, LinuxThreads use CLONE_VM, right?

Yes.

> The coredump will create the single core file for all processes because
> they have the same ->mm, the "threads" won't dump all over each other.

Yes, looks like you are right.  I had this vague idea that there were
circumstances where a dump of a LinuxThreads m-t process could produce
multipl core files, distinguished by the .PID, but I think I must have
misremembered.

> And, just in case, this patch doesn't make any difference if core_uses_pid
> is set or pid_in_pattern is true.
>
> That said, this is the user-visible change...

True.  Not sure how important that is in this case though.  What is
the reason for making this change (other than tidiness)?

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
