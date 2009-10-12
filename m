Return-Path: <linux-kernel-owner+w=401wt.eu-S933342AbZJLXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342AbZJLXEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbZJLXEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:04:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21056 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZJLXET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=UOsLe0lvN29USXnwQVJ7QrV4m1kAeZYMGNr9sQ2r7xoAl7T2vhF0SVh4+7WA14Zbud
         usi7JRV5sCEw44UhG7uOh0OLXKZzpyk28WkEBIlATaQHFlVhDrUReHOBNnsHxhj9jl32
         Zt1/2wfcg4sXhDiSSC99ANfdoSkV7pmyV5dPg=
MIME-Version: 1.0
In-Reply-To: <20091012222910.GB18195@mit.edu>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com>
	 <20091012222910.GB18195@mit.edu>
Date: Tue, 13 Oct 2009 02:02:31 +0300
Message-ID: <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com>
Subject: Re: Weird ext4 bug: 256P used?
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 1:29 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Oct 12, 2009 at 04:51:31PM +0300, Felipe Contreras wrote:
>> This is what I get with 'du -x --max-depth=3 | sort -n'.
>>
>> 140735340884184       ./var/lib/yum
>> 140735340910320       ./usr/include
>> 140735341711632       ./var/lib
>> 140735342038956       ./var
>> 140735344736432       ./usr
>> 281470691009304       .
>>
>> I did 'touch /forcefsck', rebooted, and didn't get any error, so I
>> guess at least the basic checks are passing.
>
> So if you do "du -x | sort -n", what's the deepest directory that
> shows a very large size, and can you find the files that seems to be
> responsible for these large du reports?

This is the result:
140735340871696	./var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
140735340872268	./var/lib/yum/yumdb/s
140735340884168	./var/lib/yum/yumdb
140735340884184	./var/lib/yum
140735340910320	./usr/include
140735341713520	./var/lib
140735342037100	./var
140735344736432	./usr
281470690029776	.

However, there's no file so big:
ls -lh /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
total 12K
-rw-r--r-- 1 root root 24 2009-07-27 20:52 from_repo
-rw-r--r-- 1 root root  4 2009-07-27 20:52 reason
-rw-r--r-- 1 root root  2 2009-07-27 20:52 releasever

However, there's something messed up with the uid/gid:

ls -ld /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
drwxr-xr-x 2 4294901760 16711680 4096 2009-07-27 20:52
/var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586

ls -l /usr/include/autosprintf.h
-rw-r--r-- 1 4294901760 16711680 4096 2009-06-23 03:53
/usr/include/autosprintf.h

Apparently these are the two files with the problem, and it seems to
be related to the wrong directory size.

-- 
Felipe Contreras
