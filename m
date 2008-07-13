Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYGMNeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYGMNeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 09:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYGMNd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 09:33:57 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35414 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbYGMNd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 09:33:56 -0400
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after
	media change and delay
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
In-Reply-To: <5a4c581d0807120508m758df950i76fabdb70dfa2d07@mail.gmail.com>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806131932350.30730@vixen.sonytel.be>
	 <5a4c581d0806180147qf8fc731y527c79bfb73401b2@mail.gmail.com>
	 <Pine.LNX.4.64.0806181156460.13297@vixen.sonytel.be>
	 <5a4c581d0806180515g5f24e9d9m85369bfa0a5f2228@mail.gmail.com>
	 <5a4c581d0806210718m77be63c9l444d8d7d7a5266bd@mail.gmail.com>
	 <Pine.LNX.4.64.0806221018220.9736@vixen.sonytel.be>
	 <5a4c581d0806220614seab6598ufa798d8642295495@mail.gmail.com>
	 <5a4c581d0807111425r72e39528w841e24a9b956c245@mail.gmail.com>
	 <5a4c581d0807120508m758df950i76fabdb70dfa2d07@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 13 Jul 2008 08:33:51 -0500
Message-Id: <1215956031.4326.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-12 at 14:08 +0200, Alessandro Suardi wrote:
> On Fri, Jul 11, 2008 at 11:25 PM, Alessandro Suardi
> sr0: rw=0, want=3291928, limit=2097151
> [asuardi@sandman sdlmame0126]$ h | grep siz
>   958  cat /sys/block/sr0/size
>  1031  h | grep siz
> [asuardi@sandman sdlmame0126]$ !958
> cat /sys/block/sr0/size
> 6993536
> 
> <eject, remount DVD>
> 
> [asuardi@sandman sdlmame0126]$ !mount
> mount -r /cdrom
> [asuardi@sandman sdlmame0126]$ cat /sys/block/sr0/size
> 6993536
> 
> <now everything works fine>
> 
> Possibly a new bug then - since size is always the same ?

It looks like a re-manifestation of Geert's bug.

You said everything worked in -rc7, and there actually have been no sr
changes at all between then and now, so I'm a bit confused as to how it
could reappear.  Could you try a bisection search for it (first
re-verify -rc7 is OK, just in case that's a false negative).

Thanks,

James


