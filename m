Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbZAMXNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbZAMXNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbZAMXLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:11:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:28747 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbZAMXLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:11:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gUrtg08FAVOs+wMQZGQDE0PvpBWTTK0b8K/W6gnjKIPcJ5hp66n5VoV7imV9DPfli5
         kLdGhIY/KrluBpWDIzDu227WGOPyH24CTFaE/gcI2Lf/7OZbpXjHam5z+EQ6jpJ+e7gP
         G+2ZT0zMvXhBG/gvO80oWGttTRKHFRbUA2Hq8=
Message-ID: <195c7a900901131511l7077eebar8396267e3f2b670b@mail.gmail.com>
Date: Wed, 14 Jan 2009 00:11:32 +0100
From: "Bastien ROUCARIES" <roucaries.bastien@gmail.com>
To: "Jesper Nilsson" <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       "David Miller" <davem@davemloft.net>
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
In-Reply-To: <20090113.144521.97357573.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090113.131030.207355839.davem@davemloft.net>
	 <20090113221235.GD19262@axis.com>
	 <2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com>
	 <20090113.144521.97357573.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:45 PM, David Miller <davem@davemloft.net> wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 14 Jan 2009 07:40:19 +0900
>
>> > It may be that we've worked around the other spots, although I haven't
>> > seen anything like that, we might just have been lucky until now.
>> >
>> > Can you recall another place where this trick is used?
>>
>> rmap.
>> Don't CRIS use mmu?
>
> I'm beginning to suspect the issue is only with objects
> in the kernel image itself.  Dynamically allocated memory
> is properly aligned and therefore the "low bit status bits
> in pointer" trick works.

Perhaps using a pointerhackalign trick on this structure where
#define pointerhackalign(x) __attribute__ ((aligned (x)))
and declare
struct klist_node {
...
}  pointerhackalign(2);

Because  __attribute__ ((aligned (x))) could only increase alignment
it will safe to do that and serve as documentation purpose :)

Regards

Bastien
