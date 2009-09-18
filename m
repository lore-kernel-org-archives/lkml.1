Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZIRLPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZIRLPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbZIRLPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:15:22 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:36011 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbZIRLPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:15:21 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chris Ball <cjb@laptop.org>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
References: <20090903232317.GA6760@lst.de>
	<c4e36d110909111445nb6592cfue01543f5d04c2cda@mail.gmail.com>
	<m3eiqdqfnm.fsf@pullcord.laptop.org> <200909120036.41725.rjw@sisk.pl>
Date: Fri, 18 Sep 2009 20:15:17 +0900
In-Reply-To: <200909120036.41725.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 12 Sep 2009 00:36:41 +0200")
Message-ID: <87fxaksdve.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Saturday 12 September 2009, Chris Ball wrote:
>> Hi,
>> 
>>    > Well system could check basic card ids if they match after resume
>> 
>> No.  That (arguably) guarantees that it's the same card, but not that
>> it wasn't modified in another machine during the suspend.
>
> Generally speaking, we'd also need to check superblocks for this to work.
>  
>>    > if some users wants to crash his card by randomly swapping it
>>    > during suspend/resume - I'd have no problem with that....
>> 
>> You should have a problem with it.  Taking a card from a suspended
>> machine and working on it with a different machine is not a bizarre
>> thing to want to do.
>
> Agreed.

Um...

What happen if we moved remove event to resume sequence?  I.e. The
resume generates remove and insert event (or such revalidate).  With
this, I hope the suspend is not bothered by complex one, and the resume
just ignores (if needed) previous state and notify it to userland by
remove/insert event.

And, userland process should unmount for removal devices before suspend
process (as part of userland preparation)?

If we assumed the removable device can be changed before resume, fs
would need to recover process, to make sure in-core and on-disk state
has consistent.

Um..., for now, I feel the umount before suspend is only safe way.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
