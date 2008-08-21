Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbYHUHgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbYHUHgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYHUHgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:36:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:34460 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbYHUHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mqJ+fwx57WjaxIBzVxrVoTgR/Tr1/fWCrWXwge25x0NqIzsRBh2IcPWqcYje6rP0/K
         XVeo/fYdy4YJSd93JZl3xHlcdwmmgNGZvo61xdqtan8oOShgzzAyPeg3gO3Xcc960l1f
         gIxa1Ntltumzt/9qHLqD26v0mHfDe8XTkQduY=
Message-ID: <2f11576a0808210036icd9b61eue58049f15381bcc8@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:36:00 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/2] Show quicklist at meminfo
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
In-Reply-To: <20080820113559.f559a411.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080820200607.12ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080820113559.f559a411.akpm@linux-foundation.org>
X-Google-Sender-Auth: a49470d9b110c3c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> quicklist_total_size() is racy against cpu hotplug.  That's OK for
> /proc/meminfo purposes (occasional transient inaccuracy?), but will it
> crash?  Not in the current implementation of per_cpu() afaict, but it
> might crash if we ever teach cpu hotunplug to free up the percpu
> resources.

First, Quicklist doesn't concern to cpu hotplug at all.
it is another quicklist problem.

Next, I think it doesn't cause crash. but I haven't any test.
So, I'll test cpu hotplug/unplug testing today.

I'll report result tommorow.

> I see no cpu hotplug handling in the quicklist code.  Do we leak all
> the hot-unplugged CPU's pages?

Yes.


Thanks!
