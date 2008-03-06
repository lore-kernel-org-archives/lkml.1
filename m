Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbYCFVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbYCFVU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYCFVUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:20:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56983 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYCFVUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:20:02 -0500
Date: Thu, 6 Mar 2008 22:20:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pawel Plociennik <paplociennik@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306212028.GB1747@elf.ucw.cz>
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D00B16.6040004@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-06 07:17:42, H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> Pawel Plociennik wrote:
>>>> Hi Andrew and other *real* hackers,
>>>>
>>>> I have sent a *last* version of a patch which it has added a new kernel parameter chroot=
>>>> It were discusioned a *long time* on a lkml so I hope that it will has been applied.
>>> It has been discussed and *rejected* a large number of times.
>>>
>>> This is completely useless bloat.
>>
>> why is it useless? Would it be more acceptable were it made dependent on a 
>> .config option?
>>
>
> It's useless because it's exactly and trivially replaceable with:
>
> 	init=/path/to/any/sbin/chroot /newroot /sbin/init

No, that will not work, if you don't have libraries at /. This should
be exact replacement:

init=/working_distro/lib/ld-linux.so.2 --library-path /working_distro/lib /working_distro/usr/sbin/chroot /working_distro/ /sbin/init

...assuming your chroot uses ld-linux.so.2. I believe above is ugly
enough to warrant merge of chroot= option.

...heck, how many tries would it take to get that right? Is chroot
/usr/sbin or /sbin?

This really should be in kernel, I should not have to partition my
disk to get booting to few different distros.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
