Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYKQIcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYKQIcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKQIce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:32:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:52942 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYKQIcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:32:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SXnBVB0coXiZDbsNTSxkZz6OU5sNpK5wF0deARY0ewnWM85qk89bRTjPmlo5FUkpHS
         4JEXIX15HAw7Wp4RA/L/B2MQxG1xSuZRzUxwQUCOPToeLXJDnv5edeTYcHG35c+UZ18P
         lJLoPd7J/kiQ8e8uU1EdeOUw2BC1+xW+P5xoY=
Message-ID: <2f11576a0811170032i6548e03die47f9e341f3ef9a@mail.gmail.com>
Date: Mon, 17 Nov 2008 17:32:32 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <20081117172202.343e1b35.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081115210039.537f59f5.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org>
	 <49208E9A.5080801@redhat.com>
	 <20081116204720.1b8cbe18.akpm@linux-foundation.org>
	 <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com>
	 <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f11576a0811162303t51609098o6cd765c04d791581@mail.gmail.com>
	 <20081117172202.343e1b35.kamezawa.hiroyu@jp.fujitsu.com>
X-Google-Sender-Auth: a76ceda83f29fd2d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > How about resetting zone->recent_scanned/rotated to be some value calculated from
>> > INACTIVE_ANON/INACTIVE_FILE at some time (when the system is enough idle) ?
>>
>> in get_scan_ratio()
>>
> But active/inactive ratio (and mapped_ratio) is not handled there.

Yes.
I think akpm pointed out just this point.


> Follwoing 2 will return the same scan ratio.
> ==case 1==
>  active_anon = 480M
>  inactive_anon = 32M
>  active_file = 2M
>  inactive_file = 510M
>
> ==case 2==
>  active_anon = 480M
>  inactive_anon = 32M
>  active_file = 480M
>  inactive_file = 32M
> ==

Yes.
the patch handle this situation by special priority.


Umm..
Perhaps, I am missing your point?
