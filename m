Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYFICPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYFICPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 22:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYFICO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 22:14:57 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:40645 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbYFICO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 22:14:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qQTlD7DtGloDmO7Ztm8gn3xq5uCTZgW3u+PFQL+JFaNPbydO7MDEQ4FwwgCkluMA2P
         6knOng1gdm+g9T9+LB8eQWaAvQIw57g7c2qolJ1hblvt64EV0BeKSY0MZseMnTzh6BhA
         eg7KBEZ7MlGHxkY2C80XomGnJE4kFrmTTB1j8=
Message-ID: <28c262360806081914v357f4093ra1e1e9e36f487eb7@mail.gmail.com>
Date: Mon, 9 Jun 2008 11:14:55 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH -mm 04/25] free swap space on swap-in/activation
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <20080606180430.38bf1d82.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606202838.390050172@redhat.com>
	 <20080606202858.570020389@redhat.com>
	 <20080606180430.38bf1d82.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - Can completely optimise the thing away if !CONFIG_SWAP.
>

I think we can optimize more and more in case of if !CONFIG_SWAP.
If system are !CONFIG_SWAP, we can never  swap out anonymous pages.

Don't we manage anonymous pages with list ?

Such system don't need to insert anonymous pages into lru list when fault occur.
It is just needless overhead.

Also, If we can't reclaim anonymous pages, don't we need anon rmap facility ?
I don't know well which subsystems used rmap.

If pageout only use anonymous rmap for pageout,
we can remove anonymous rmapping code in case of !CONFIG_SWAP

How about your opinion ?

-- 
Kinds regards,
MinChan Kim
