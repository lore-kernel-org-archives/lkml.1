Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYFINi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYFINi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYFINiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:38:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:8494 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYFINiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=El3gaPunn/YxyFWbm7fU78Xjn+KwMaQQP7Mv/JLkWeiu7RYVW9En8umhUc67VYf/o+
         rB0NNSx7qhvdaNkB7Dexx360UUMM2949ICF5U4NsezC9gr2im0IhAxeD51byQVdM6cLa
         ZHHV7Q9YRpw5mkFbXy8Ia0wlLDY85iej/oz4k=
Message-ID: <2f11576a0806090638u445209e7m359c03a4776826be@mail.gmail.com>
Date: Mon, 9 Jun 2008 22:38:19 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm 04/25] free swap space on swap-in/activation
Cc: "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <28c262360806081914v357f4093ra1e1e9e36f487eb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606202838.390050172@redhat.com>
	 <20080606202858.570020389@redhat.com>
	 <20080606180430.38bf1d82.akpm@linux-foundation.org>
	 <28c262360806081914v357f4093ra1e1e9e36f487eb7@mail.gmail.com>
X-Google-Sender-Auth: 04d66b91187536a7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim-san,

>> - Can completely optimise the thing away if !CONFIG_SWAP.
>
> I think we can optimize more and more in case of if !CONFIG_SWAP.
> If system are !CONFIG_SWAP, we can never  swap out anonymous pages.
>
> Don't we manage anonymous pages with list ?
>
> Such system don't need to insert anonymous pages into lru list when fault occur.
> It is just needless overhead.
>
> Also, If we can't reclaim anonymous pages, don't we need anon rmap facility ?
> I don't know well which subsystems used rmap.
>
> If pageout only use anonymous rmap for pageout,
> we can remove anonymous rmapping code in case of !CONFIG_SWAP

You are right.
but I think rmap isn't bottle neck in embedded system.
Why do you want remove that?
