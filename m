Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZBJONX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZBJONX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZBJONP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:13:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:2515 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZBJONO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qOBBygIZgSIfYXC4bbB5duwnreX1hkjMhsEFYM7wYGyzyk1BMO0Oxc5tPDFlzw4p17
         G3nJ/MSX5xxAgDmLE1nqNs9wVSc785WcR5+xAYdMtKDENv2OzUoxPe2TQyrEcnqlK5kL
         mGfGn/xQ5BUH1z4CbGK99r2353UHexK1oZOM0=
MIME-Version: 1.0
In-Reply-To: <20090210135050.GB4023@csn.ul.ie>
References: <20090210162220.6FBC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090210135050.GB4023@csn.ul.ie>
Date: Tue, 10 Feb 2009 23:13:12 +0900
X-Google-Sender-Auth: f42fb80ecbe60a9b
Message-ID: <2f11576a0902100613g311f8387sb23f866c94bd48bf@mail.gmail.com>
Subject: Re: [PATCH] introduce for_each_populated_zone() macro
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>> +#define for_each_populated_zone(zone)                        \
>> +     for (zone = (first_online_pgdat())->node_zones; \
>> +          zone;                                      \
>> +          zone = next_zone(zone))                    \
>> +             if (!populated_zone(zone))              \
>> +                     ; /* do nothing */              \
>> +             else
>> +
>> +
>> +
>> +
>
> There is tabs vs whitespace damage in there.

??
I'm look at it again. but I don't found whitespace damage.

> Multiple empty lines are introduced for no apparent reason.

Will fix. thanks.

> It's not clear why you did not use if (populated_zone(zone))
> instead of an if/else.

Good question.
if we make following macro,

#define for_each_populated_zone(zone)                        \
     for (zone = (first_online_pgdat())->node_zones; \
          zone;                                      \
          zone = next_zone(zone))                    \
             if (populated_zone(zone))

and, writing following caller code.

if (always_true_assumption)
  for_each_populated_zone(){
     /* some code */
  }
else
  panic();

expand to

if (always_true_assumption)
  for()
     if (populated_zone() {
     /* some code */
  }
else
  panic();

then, memoryless node cause panic().


>
> Otherwise, I did not spot anything out of the ordinary. Nice cleanup.
