Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZABKAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZABKAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbZABKAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:00:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:8703 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbZABKAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=RR4c6y/jdVJFOC/S6f1ykj+rZslK1uE1bzEta1uGjFAGTXf7w/XgQqY0tH+syssS0U
         L5qWUNljf4inMZvecnThHMmpV97hCk61ZqBgrirkV2nBXWYlNlcIoZK9kHbe7PwAOB8f
         sXSt8eS5ngB8MkmmTBXjqIsVfxvbNwXBi+ehg=
Message-ID: <2f11576a0901020200t3a6dadf5qa944432cd9fd8873@mail.gmail.com>
Date: Fri, 2 Jan 2009 19:00:41 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [PATCH] mm: stop kswapd's infinite loop at high order allocation take2
Cc: "Mel Gorman" <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "wassim dagash" <wassim.dagash@gmail.com>
In-Reply-To: <28c262360901020155l3a9260b5h3c79d4b23a213825@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081231115332.GB20534@csn.ul.ie>
	 <20081231215934.1296.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090101021240.A057.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <28c262360901020155l3a9260b5h3c79d4b23a213825@mail.gmail.com>
X-Google-Sender-Auth: 657d5a0cf9778e54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, kosaki-san.
>
> I read the previous threads now. It's rather late :(.
>
> I think it's rather awkward that sudden big change of order from 10 to 0.
>
> This problem causes zone_water_mark's fail.
> It mean now this zone's proportional free page per order size is not good.
> Although order-0 page is very important, Shouldn't we consider other
> order allocations ?
>
> So I want to balance zone's proportional free page.
> How about following ?
>
> if (nr_reclaimed < SWAP_CLUSTER_MAX) {
>   if (order != 0) {
>     order -=1;
>     sc.order -=1;
>   }
> }
>
> It prevents infinite loop and do best effort to make zone's
> proportional free page per order size good.
>
> It's just my opinion within my knowledge.
> If it have a problem, pz, explain me :)

Please read Nick's expalin. it explain very kindly :)
