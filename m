Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZGENT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZGENT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbZGENTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:19:46 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:63898 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbZGENTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nFYqPoEtT/B2eQS8E33Z1y5Yt0hz5OboSmes6NqWc77rjnoQqVtGWCJZgClP7OzMpu
         1gODdbufv2eXikGlQn0KGl53P9sVyUMgdvrrDN4f6/2d8wdtIn1MORm3ng2aqULXGBLS
         5wsl0lsV5gbgEhGbijNYEoGg64vbiWJTWfla4=
MIME-Version: 1.0
In-Reply-To: <20090705130200.GA6585@localhost>
References: <20090705182533.0902.A69D9226@jp.fujitsu.com>
	 <20090705121308.GC5252@localhost>
	 <20090705211739.091D.A69D9226@jp.fujitsu.com>
	 <20090705130200.GA6585@localhost>
Date: Sun, 5 Jul 2009 22:19:47 +0900
X-Google-Sender-Auth: df827bc40124cbde
Message-ID: <2f11576a0907050619t5dea33cfwc46344600c2b17b5@mail.gmail.com>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > + printk("%ld total anon pages\n", global_page_state(NR_ANON_PAGES));
>> > >   printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
>> >
>> > Can we put related items together, ie. this looks more friendly:
>> >
>> >         Anon:XXX active_anon:XXX inactive_anon:XXX
>> >         File:XXX active_file:XXX inactive_file:XXX
>>
>> hmmm. Actually NR_ACTIVE_ANON + NR_INACTIVE_ANON != NR_ANON_PAGES.
>> tmpfs pages are accounted as FILE, but it is stay in anon lru.
>
> Right, that's exactly the reason I propose to put them together: to
> make the number of tmpfs pages obvious.
>
>> I think your proposed format easily makes confusion. this format cause to
>> imazine Anon = active_anon + inactive_anon.
>
> Yes it may confuse normal users :(
>
>> At least, we need to use another name, I think.
>
> Hmm I find it hard to work out a good name.
>
> But instead, it may be a good idea to explicitly compute the tmpfs
> pages, because the excessive use of tmpfs pages could be a common
> reason of OOM.

Yeah,  explicite tmpfs/shmem accounting is also useful for /proc/meminfo.
