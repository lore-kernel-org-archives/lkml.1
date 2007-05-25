Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbXEYIXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbXEYIXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbXEYIWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:22:51 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:36990 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbXEYIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:22:50 -0400
Message-ID: <46569CD8.1000602@s5r6.in-berlin.de>
Date: Fri, 25 May 2007 10:22:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Markus Rechberger <mrechberger@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <2172422218943432279@wsc.cz>	 <d9def9db0705240724p59a48160l8a2338f4d44b0ef6@mail.gmail.com> <4af2d03a0705241607r3c9807c6h3841e87ea4736bd3@mail.gmail.com>
In-Reply-To: <4af2d03a0705241607r3c9807c6h3841e87ea4736bd3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 5/24/07, Markus Rechberger <mrechberger@gmail.com> wrote:
>> On 5/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> [...]
>> > +static int stk1125_camera_asleep(struct stk11xx *dev)
>> > +{
>> > +     int value;
>> > +
>> > +     stk11xx_read_registry(dev, 0x0104, &value);
>> > +     stk11xx_read_registry(dev, 0x0105, &value);
>> > +     stk11xx_read_registry(dev, 0x0106, &value);
>> > +
>>
>> why do you read these values (this is also something in the ongoing
>> code I see, the read value just gets overwritten all the time)?
> 
> Well, as I tested, reads are neccesary, otherwise it doesn't work. And
> when they are needed, you need to read the value to some place in
> memory -- the &value.

Perhaps a few comments are warranted here and there about why some of
those less obvious things are done.

Or do it as more or less self-documenting code like

static inline void
stk11xx_unjam_registry(struct stk11xx *dev, u16 index)
{
	int dummy;

	stk11xx_read_registry(dev, index, &dummy);
}

-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/
