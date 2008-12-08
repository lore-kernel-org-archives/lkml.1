Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYLHOau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYLHOau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYLHOam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:30:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:9440 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYLHOal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=E3VB8GXAjqiWTEtKY/YQYDSrI5phjI9K/sb10p/ETRfVNb6oXT0NuafH4Djp9JdzYa
         cUmpM7bg6t6a40pulzkbsgmXh96TfVvAyFaLPMFyHoP7uHCZ2UsQ8VcX32BR25h0+Y0A
         ETGIaRNx8/Q6DcduM+l46GENVl210sLtk1RF4=
Message-ID: <2f11576a0812080630j4327dbbgf0aa0e332156d229@mail.gmail.com>
Date: Mon, 8 Dec 2008 23:30:40 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] memory hotplug: run lru_add_drain_all() on each cpu
Cc: "Dave Hansen" <dave@linux.vnet.ibm.com>, gerald.schaefer@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, npiggin@suse.de
In-Reply-To: <1228744588.22647.32.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228482500.8392.15.camel@t60p> <1228509818.12681.21.camel@nimitz>
	 <20081207133450.53D8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1228744588.22647.32.camel@lts-notebook>
X-Google-Sender-Auth: 0be335245c5e8e18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Lee, Could you read this thread and explain why you add ifdef CONFIG_UNEVICTABLE_LRU?
>> I am not sure about that Dave's proposal is safe change. (but I guess he is right)
>
> I added that back in Patch 17/25 "Mlocked Pages are
> non-reclaimable" [before nonreclaimable became unevictable".  I did this
> because "lru_add_drain_all()" was only used by numa code prior to this,
> and was under #ifdef CONFIG_NUMA".  I called lru_add_drain_all() from
> __mlock_vma_pages_range() [since removed] and I wanted the
> nonreclaimable/unevictable mlocked pages feature to be independent of
> numa.  So, I had to ensure that we defined the function for
> nonreclaimable/unevictable lru as well as numa.
>
> Now it appears that hotplug and memcg also depend on
> lru_add_drain_all(), so making it depend on 'SMP looks reasonable to me.

Thanks a lot.

I'll make that patch.
