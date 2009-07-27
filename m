Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZG0NDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZG0NDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZG0ND3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:03:29 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25984 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZG0ND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:03:28 -0400
Subject: Re: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to
	volume label
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
To: ext OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <87ljmas5ym.fsf@devron.myhome.or.jp>
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <87fxclmhxy.fsf@devron.myhome.or.jp>
	 <1248691635.4618.43.camel@jorg-desktop>
	 <87ljmas5ym.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jul 2009 16:03:05 +0300
Message-Id: <1248699785.4618.77.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jul 2009 13:03:07.0493 (UTC) FILETIME=[95E3F150:01CA0EBA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 13:47 +0200, ext OGAWA Hirofumi wrote:
> Jörg Schummer <ext-jorg.2.schummer@nokia.com> writes:

> > If you don't want this patch.. There's probably good reasons not to take
> > it, especially the amount-of-problem-solving-by-maintenance-cost ratio
> > might be rather low.

> BTW, the patch has several bugs. fat_get_label_entry() doesn't check
> IS_FREE(), is it right? fat_create_label_entry() doesn't initialize all
> timestamp in the case of msdos. spin_lock() usage is wrong. and more...

You got good points there. I'll fix these on the chance that somebody
decides to use it.

> > In summary: If you're not keen on integrating new features which would
> > make Linux look good in the face of shiny Mac OS, there might not be
> > much reason to take it in. Unless we get zillions of people replying now
> > with what wonderful things it would enable them to do.. ;-)
> 
> Yes, we would really want to know whether people want to use this. Is
> there any info from Mac OS people?
> 
> BTW, my thinking is, the option is why default is "rootts=ignore" if
> it's really good?

That's because this feature does not seem to be part of most generally
accepted FAT implementations. So I thought that the default should try
to behave as people would expect FAT to behave: Forget about root dir
timestamps.
On the other hand, except for 'save', none of the options makes 'real'
fs changes, so maybe 'preserve' could be the default. (People who are
used to the 'standard' behaviour should not be harmed by that - once the
bugs are gone, that is..)

> Or 4 rootts=* options is really needed, and what is
> reason? 

I thought 'ignore' should be there in order to provide the
'standard'-FAT behaviour. And 'save' possibly creates a volume label,
which might be not be wanted. But 'load' is not so necessary, indeed.
The behaviour of Mac OS seems to be like 'preserve', btw.

>  Or if it's not good by some reasons, why is it added? ...

The patch was created merely because one guy figured out that FAT can't
save root dir timestamps by default and another guy knew that Mac OS X's
FAT implementation can. So I thought, what the heck, let's enable linux
to do the same thing.

Like mentioned before, this was not created because it would solve many
people's problems. So I seriously do understand if you decide not to
take it in. But still I would appreciate if you could take another look
at my next - hopefully less buggy - version.

Thanks for your comments,
Jörg


