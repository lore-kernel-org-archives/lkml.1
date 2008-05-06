Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbYEFBBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbYEFBBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYEFBB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:01:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:61158 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYEFBB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GSZPMvOBUNkMnyFcfDWhjiRG6Fgj2G+YMQuKOIztsmLAe2YSXkfm4ino5iZrBxu3hkXph9pZLBYmdtQVH7pE+4GQW0b/cC+M/f8tH4tE4yXrNPGHTVG8tkomSEXv7BU8Vn8O4MxWj8pBQQkKsPfWP5jatwuVgyZMDAxH1ZXb3aw=
Message-ID: <2f11576a0805051801xf144478pb7b04799f148db29@mail.gmail.com>
Date: Tue, 6 May 2008 10:01:26 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [-mm][PATCH 4/5] core of reclaim throttle
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080505204318.3f95c83c@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504215819.8F5E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080505175142.7de3f27b@cuia.bos.redhat.com>
	 <2f11576a0805051523h730fce0foa51f1fdbf9c46cbe@mail.gmail.com>
	 <20080505204318.3f95c83c@bree.surriel.com>
X-Google-Sender-Auth: 2ed07dcfd9b28f1c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > hmmm, AFAIK,
>  > on current kernel, sometimes __GFP_IO task wait for non __GFP_IO task
>  > by lock_page().
>  > Is this wrong?
>
>  This is fine.
>
>  The problem is adding a code path that causes non __GFP_IO tasks to
>  wait on __GFP_IO tasks.  Then you can have a deadlock.

Ah, OK.
I'll add __GFP_FS and __GFP_IO check at next post.

Thanks!


>  > therefore my patch care only recursive reclaim situation.
>  > I don't object to your opinion. but I hope understand exactly your opinion.
>
>  I believe not all non __GFP_IO or non __GFP_FS calls are recursive
>  reclaim, but there are some other code paths too.  For example from
>  fs/buffer.c

absolutely.
