Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYIWTXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYIWTXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYIWTWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:22:53 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53541 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYIWTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qSAZKSmvk+Gd7j+B+aFeBIPznmTl/Z+pW4ldELdNfzRSZFAdSt35heWa0QGMJo9N8+
         HZ8MelHO87bwB0aEgmDwZTp40/BaTf7o8t2c1IKmELXSJGiZIl2i0FPaguCHgTagh716
         Y+oEngyrru8eppProWrsKQtJNyZAwXYOKtw8I=
Message-ID: <43e72e890809231222r21396433j88074d5514ef56f0@mail.gmail.com>
Date: Tue, 23 Sep 2008 12:22:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0809230022v582df76esa8df8c747ab600df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com>
	 <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com>
	 <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com>
	 <20080922065453.GD19580@tesla>
	 <f488382f0809220026u9afa355g1ff2cc7a3fe88333@mail.gmail.com>
	 <20080922080632.GA20446@tesla>
	 <f488382f0809220811y46e9daf3r5db5a7c76df87800@mail.gmail.com>
	 <43e72e890809220901y162636fu63ed133f0a0c235@mail.gmail.com>
	 <f488382f0809230022v582df76esa8df8c747ab600df@mail.gmail.com>
X-Google-Sender-Auth: 221b57b3e4f9f19a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/23 Steven Noonan <steven@uplinklabs.net>:

> Okay. I'm in Seattle now.
>
> Yes, it solved the issue, but surely an #if 0 isn't a proper solution.

For 2.6.27 it will be unless people are willing to accept a patch to
enable ANI support for 2.6.27.

> What's the actual bug here? I'm afraid the meaning of what's going on
> here isn't exactly intuitive.

Check linux-wireless for my patch on MIB event comments. But I'll
summarize here for you. We get MIB interrupts to update statistics on
a number of PHY related elements. We then use this information to
process ANI -- some automatic noise immunity work. If you don't
process the information for ANI it seems you get the hardware treating
this as untreated and hence you get an interrupt storm. So since
2.6.27 doesn't have ANI implemented the MIB interrupts are not useful
except to collect internal statistics.

Since you are so eager to test this with a "proper" solution I will
send you a patch to test ANI for 2.6.27. We'll leave it up to the
maintainers and distributions to decide whether or not to pick this
up. But for that let's leave that for another thread.

  Luis
