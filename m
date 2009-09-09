Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbZIINV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbZIINV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZIINV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:21:56 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:51426 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZIINVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:21:55 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Christoph Hellwig <hch@lst.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
	<200908312119.12121.rjw@sisk.pl>
	<c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
	<c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
	<20090903232317.GA6760@lst.de> <87ljkvmt71.fsf@devron.myhome.or.jp>
	<c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com>
	<87iqfx5mss.fsf@devron.myhome.or.jp> <20090907125130.GA1595@ucw.cz>
Date: Wed, 09 Sep 2009 22:21:56 +0900
In-Reply-To: <20090907125130.GA1595@ucw.cz> (Pavel Machek's message of "Mon, 7
	Sep 2009 14:51:30 +0200")
Message-ID: <87ljko5k3v.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

>> It seems
>> 
>>     1) sync() (probabry "sync" command)
>>     2) sync as part of suspend sequence
>>     3) sync_filesystem() by mmc remove event
>> 
>> I guess the root-cause of the problem would be 3). However, it would not
>> be easy to fix, at least, we would need to think about what we want to
>> do for it. So, to workaround it for now, I've made this patch.
>
> MMC driver trying to synchronize filesystems looks like ugly layering
> violation to me. Why are we doing that?

There is no _layering violation_ here. IIRC, mmc just tells card removed
event to another layer (on some points of view, to tell event can be
wrong though). The partition (block) layer does it by event.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
