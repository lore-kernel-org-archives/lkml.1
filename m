Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYGXKdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYGXKdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYGXKdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:33:37 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:61537 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbYGXKdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FWs/jDGeZxqye0LYyZWc/UcrA2+7aAq1P0fynFMc81E40sPK1GM/RM2lEfHxBLqNFZ
         6i9pdTGze3C2owFvnK+hoO/DCH95HCnBc0XOP+zdKl59FteQd9RLu2x5l9EgK/ihuTx5
         5zVmloFiFEHb9ubrsZkysYDUNA0ZMHmDYMMnk=
Message-ID: <74d0deb30807240333l565eaf24uf695ce8d01597090@mail.gmail.com>
Date: Thu, 24 Jul 2008 12:33:34 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [patch 44/47] pxamci: fix byte aligned DMA transfers
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Justin Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Domenico Andreoli" <cavokz@gmail.com>, akpm@linux-foundation.org,
       "Randy Dunlap" <rdunlap@xenotime.net>, "Willy Tarreau" <w@1wt.eu>,
       "Chuck Wolber" <chuckw@quantumlinux.com>, alan@lxorguk.ukuu.org.uk,
       "Chuck Ebbert" <cebbert@redhat.com>, "Dave Jones" <davej@redhat.com>,
       "Jake Edge" <jake@lwn.net>, "Michael Krufky" <mkrufky@linuxtv.org>,
       stable@kernel.org, "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>,
       "Pierre Ossman" <drzeus@drzeus.cx>
In-Reply-To: <20080723203250.GA26454@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080722230208.148102983@mini.kroah.org>
	 <20080722231342.GA8282@suse.de> <20080722231735.GS8282@suse.de>
	 <74d0deb30807230001x176e375cq9a8060c20596f36f@mail.gmail.com>
	 <20080723201258.GA26156@kroah.com>
	 <alpine.LFD.1.10.0807231322250.4754@woody.linux-foundation.org>
	 <20080723203250.GA26454@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:32 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Jul 23, 2008 at 01:24:12PM -0700, Linus Torvalds wrote:
>>
>>
>> On Wed, 23 Jul 2008, Greg KH wrote:
>>
>> > On Wed, Jul 23, 2008 at 09:01:34AM +0200, pHilipp Zabel wrote:
>> > >
>> > > There is an ugly typo in the patch below that was fixed by Karl Beldan:
>> > > http://git.kernel.org/?p=linux/kernel/git/drzeus/mmc.git;a=commit;h=28bbe535df5c461c25eb57affb30e007072429c3
>> > >
>> > > Not sure how you handle this, maybe this patch should only go in
>> > > together with the other.
>> >
>> > As the above mentioned patch isn't in Linus's tree yet, I can't take it.
>> >
>> > Care to send it to stable@kernel.org when it does go in?  Or is this
>> > current patch just broken without it and not worth adding at all?
>>
>> Hmm. I think it's commit 4fe16897c59882420d66f2d503106653d026ed6c
>> upstream. I don't know why it has a different SHA1 in the mmc tree, but I
>> assume that it's because the MMC tree has rebased at some point. Ugh.

Thank you, I think when I wrote my mail it wasn't pulled yet.

> Ah, thanks, I missed that.
>
> Hm, that is added post 2.6.26, so I'll add this fixup patch to the
> .25-stable tree, and also add this one to the .26-stable queue.

Ok, thank you.

> Philipp, is that correct, or does this original one also need to get
> added to the .26-stable queue as well?

AFAICT, the original one (97f8571e663c808ad2d01a396627235167291556) is
post-26, too.

Both should be applied together. Although it is unlikely that with the
broken patch MMC accesses will accidentally clear the DALGN bits of
other running (unaligned) DMA chains (I'm not aware of any drivers
using unaligned DMA), the PXA27x developer manual says that this "must
not" be done. If it would result in memory corruption or lockups, I
don't know.

regards
Philipp
