Return-Path: <linux-kernel-owner+w=401wt.eu-S1764331AbYFHLWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764331AbYFHLWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbYFHLWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:22:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:37431 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617AbYFHLWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HNa2leYeikoJxbWt87L3/N0LkLntnIjEjlHxNw0M7wLYrhhBOU5e4askAFgpz7d1O4
         ctlkY9RVBfFqE89hI2TckMjXD/JyMP3LnQzpE9WxkCKqAS78S292z+xlZCLIz83WD4xq
         XKE7o6wS1CPygH+f728aBH7lpFHK5bcmmXZ8k=
Message-ID: <2f11576a0806080422t3661596at567da2a557ff190a@mail.gmail.com>
Date: Sun, 8 Jun 2008 20:22:08 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH -mm 02/25] Use an indexed array for LRU variables
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, clameter@sgi.com
In-Reply-To: <20080607104740.6c12a324@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606202858.449902618@redhat.com>
	 <20080606180426.89989a07.akpm@linux-foundation.org>
	 <20080607144105.9C52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080607104740.6c12a324@bree.surriel.com>
X-Google-Sender-Auth: e3871ca3ecd03ffb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > @@ -1,40 +1,51 @@
>> > >  static inline void
>> > > +add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
>> > > +{
>> > > + list_add(&page->lru, &zone->list[l]);
>> > > + __inc_zone_state(zone, NR_INACTIVE + l);
>> >
>> >                                ^ that's a bug, isn't it?
>>
>> this is definitely bug.
>
> I believe this is correct, actually.   I will rename/alias it to
> VMSCAN_BASE or something along those lines.

Ah, sorry. you are right.
