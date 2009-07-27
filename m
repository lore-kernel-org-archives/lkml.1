Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZG0Krr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZG0Krr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 06:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZG0Krr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 06:47:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62239 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZG0Krq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 06:47:46 -0400
Subject: Re: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to
	volume label
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
To: ext OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <87fxclmhxy.fsf@devron.myhome.or.jp>
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <87fxclmhxy.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jul 2009 13:47:15 +0300
Message-Id: <1248691635.4618.43.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jul 2009 10:47:19.0645 (UTC) FILETIME=[9D6500D0:01CA0EA7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 07:48 +0200, ext OGAWA Hirofumi wrote:
> Jorg Schummer <ext-jorg.2.schummer@nokia.com> writes:
> 
> > Standard FAT implementations cannot store any of the FAT root directory's
> > timestamps. This commit adds the mount option 'rootts', which allows saving
> > the FAT root directory timestamps as the timestamps of the FAT volume label
> > directory entry. At least Mac OS X is known to support the same mechanism
> > and interoperate with this commit.

Hi,

I guess I should have explained a bit more:

> Looks like interesting hack. However, personally, I don't think I want
> this, but I guess it can be only me.

If you don't want this functionality to be used, as pointed out before,
"rootts=ignore" is the default.

If you don't want this patch.. There's probably good reasons not to take
it, especially the amount-of-problem-solving-by-maintenance-cost ratio
might be rather low.

> Well, so, what is this for? If rootdir doesn't have timestamp, some app
> is not working, or something?

To be honest, the only app which I can think of here is some
backup-script which I wrote many years ago and which has not been in use
anymore for a long time. (Maybe rsync or similar could also fail under
some circumstances? Not sure.)

So some backup / synchronisation apps might not work properly. But who's
going to use FAT for sensitive, i.e. backup-worthy data anyway? The
answer is: People who use the same volume in many different machines,
some of which might be able to speak only FAT. Drawback: Just for these
people this patch might not be useful since none of those FAT machines
(except for the apple and possibly the penguin) support root dir
timestamps anyway. So whatever timestamps are found at backup-time, they
cannot be trusted, because the volume might have been in use by standard
FAT implementations.

In summary: If you're not keen on integrating new features which would
make Linux look good in the face of shiny Mac OS, there might not be
much reason to take it in. Unless we get zillions of people replying now
with what wonderful things it would enable them to do.. ;-)

Regards,
Jörg


