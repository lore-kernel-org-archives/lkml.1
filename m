Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXBRAph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXBRAph (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXBRAph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:45:37 -0500
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:40257 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965472AbXBRApg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:45:36 -0500
References: <200702162110.03355.kernel@kolivas.org> <200702171417.28376.kernel@kolivas.org> <45D74D34.5020201@redhat.com> <200702180800.07393.kernel@kolivas.org> <20070217154746.7ff10870.akpm@linux-foundation.org> <f44c5fdf0702171641l43fb62d9h73df322634ae26d6@mail.gmail.com>
Message-ID: <cone.1171759517.348623.14045.501@kolivas.org>
X-Mailer: http://www.courier-mta.org/cone/
From: Con Kolivas <kernel@kolivas.org>
To: Radoslaw Szkodzinski <astralstorm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, michael chang <thenewme91@gmail.com>,
       ck mailing list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-ck1
Date: Sun, 18 Feb 2007 11:45:17 +1100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Radoslaw Szkodzinski writes:

> On 2/18/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> Generally, the penalties for getting this stuff wrong are very very high:
>> orders of magnitude slowdowns in the right situations.  Which I suspect
>> will make any system-wide knob ultimately unsuccessful.
>>
> 
> Yes, they were. Now, it's an extremely light and well-tuned patch.
> kprefetchd should only run on a totally idle system now.
> 
>> The ideal way of getting this *right* is to change every application in the
>> world to get smart about using sync_page_range() and/or posix_fadvise(),
>> then to add a set of command-line options to each application in the world
>> so the user can control its pagecache handling.
> 
> We don't live in a perfect world. :-)
> 
>> Obviously that isn't practical.  But what _could_ be done is to put these
>> pagecache smarts into glibc's read() and write() code.  So the user can do:
>>
>>         MAX_PAGECACHE=4M MAX_DIRTY_PAGECACHE=2M rsync foo bar
>>
>> This will provide pagecache control for pretty much every application.  It
>> has limitations (fork+exec behaviour??) but will be useful.
> 
> Not too useful for interactive applications with unpredictable memory
> consumption behaviour, where swap-prefetch still helps.

Hey Radoslaw, your points are valid but Andrew was referring to the tail 
large files patch in this email.

--
-ck

