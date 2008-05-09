Return-Path: <linux-kernel-owner+w=401wt.eu-S1765561AbYEIF1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561AbYEIF1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYEIF07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:26:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:18357 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYEIF06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SyvUxz+n6jsqNHi5EPsMHmfsDWO5x6e/vIn0HwBVPqi7wqvSugy9ZVSG1SHCjtllb8Y7qwVymko6l/SLsDI38a3xwg3RRDWNZfT7Zog3jyHVLvP5KHWNK4ZP99idMvSkKFptsqipWjqaq7+5JtWfgaVhBj2OQAe1adwK6oUITUA=
Message-ID: <170fa0d20805082226pa75ae7r65a04d494b65cbf5@mail.gmail.com>
Date: Fri, 9 May 2008 01:26:58 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.clements@steeleye.com
In-Reply-To: <170fa0d20805082208y5ad10fe6xbbbaddcbcb7a4736@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	 <18464.134.236488.251879@notabene.brown>
	 <170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	 <18466.39418.578722.92979@notabene.brown>
	 <170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	 <18467.43895.220708.254814@notabene.brown>
	 <170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
	 <170fa0d20805082208y5ad10fe6xbbbaddcbcb7a4736@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2008 at 1:08 AM, Mike Snitzer <snitzer@gmail.com> wrote:
> On Fri, May 9, 2008 at 12:42 AM, Mike Snitzer <snitzer@gmail.com> wrote:
>
>  >  Was I supposed to use this latest patch in combination with your
>  >  previous patch (to validate_super)?  Because you'll note that with
>  >  your most recent patch nbd0's events (ev1) is still one less than
>  >  sdq's events_cleared.  As such the validate_super's "ev1 <
>  >  mddev->bitmap->events_cleared" check triggers a full rebuild.
>  >
>  >  The kernel log shows:
>  >  md: md0 stopped.
>  >  md: bind<nbd0>
>  >  md: bind<sdq>
>  >  md: kicking non-fresh nbd0 from array!
>  >  md: unbind<nbd0>
>  >  md: export_rdev(nbd0)
>  >  raid1: raid set md0 active with 1 out of 2 mirrors
>  >  md0: bitmap initialized from disk: read 13/13 pages, set 0 bits, status: 0
>
>  Also, no bits were set in the bitmap.. bitmap_create() must've thrown
>  away the dirty bits.  Given your latest patch, does bitmap_create()'s
>  "bitmap->events_cleared == mddev->events" check need to be adjusted?
>
>  Before I would always see something like:
>  md0: bitmap initialized from disk: read 13/13 pages, set 1 bits, status: 0

Actually, the mdadm -X output I provided shows that sdq's bitmap
doesn't have any bits set:
Bitmap : 409600 bits (chunks), 0 dirty (0.0%)

This can't be right, considering nbd0 was marked faulty and the array
became degraded, can it?
