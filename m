Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZG0Lrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZG0Lrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZG0Lrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:47:32 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54615 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZG0Lrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:47:31 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: =?iso-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to volume label
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<87fxclmhxy.fsf@devron.myhome.or.jp>
	<1248691635.4618.43.camel@jorg-desktop>
Date: Mon, 27 Jul 2009 20:47:29 +0900
In-Reply-To: <1248691635.4618.43.camel@jorg-desktop> (=?iso-8859-1?Q?=22J?=
 =?iso-8859-1?Q?=F6rg?= Schummer"'s
	message of "Mon, 27 Jul 2009 13:47:15 +0300")
Message-ID: <87ljmas5ym.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörg Schummer <ext-jorg.2.schummer@nokia.com> writes:

> Hi,

Hi,

> If you don't want this patch.. There's probably good reasons not to take
> it, especially the amount-of-problem-solving-by-maintenance-cost ratio
> might be rather low.

Also, the option is easy to add, but really hard to delete by backward
compatible reason. This is why I'm so careful to it.

BTW, the patch has several bugs. fat_get_label_entry() doesn't check
IS_FREE(), is it right? fat_create_label_entry() doesn't initialize all
timestamp in the case of msdos. spin_lock() usage is wrong. and more...

>> Well, so, what is this for? If rootdir doesn't have timestamp, some app
>> is not working, or something?
>
> To be honest, the only app which I can think of here is some
> backup-script which I wrote many years ago and which has not been in use
> anymore for a long time. (Maybe rsync or similar could also fail under
> some circumstances? Not sure.)
>
> So some backup / synchronisation apps might not work properly. But who's
> going to use FAT for sensitive, i.e. backup-worthy data anyway? The
> answer is: People who use the same volume in many different machines,
> some of which might be able to speak only FAT. Drawback: Just for these
> people this patch might not be useful since none of those FAT machines
> (except for the apple and possibly the penguin) support root dir
> timestamps anyway. So whatever timestamps are found at backup-time, they
> cannot be trusted, because the volume might have been in use by standard
> FAT implementations.
>
> In summary: If you're not keen on integrating new features which would
> make Linux look good in the face of shiny Mac OS, there might not be
> much reason to take it in. Unless we get zillions of people replying now
> with what wonderful things it would enable them to do.. ;-)

Yes, we would really want to know whether people want to use this. Is
there any info from Mac OS people?

BTW, my thinking is, the option is why default is "rootts=ignore" if
it's really good? Or 4 rootts=* options is really needed, and what is
reason?  Or if it's not good by some reasons, why is it added? ...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
