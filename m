Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbXHQHyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbXHQHyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbXHQHys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:54:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47351 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXHQHyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:54:47 -0400
Date: Fri, 17 Aug 2007 09:54:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: GolovaSteek <golovasteek@gmail.com>
cc: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>, linux-kernel@vger.kernel.org
Subject: Re: nanosleep() accuracy
In-Reply-To: <f40fb4250708170044q9a259c3wb50186880d6b7f51@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708170946270.5492@fbirervta.pbzchgretzou.qr>
References: <f40fb4250708161552ub87bf8ve8168eec1b3955e7@mail.gmail.com> 
 <46C54787.1010909@stud.feec.vutbr.cz> <f40fb4250708170044q9a259c3wb50186880d6b7f51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1470424275-1187337286=:5492"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1470424275-1187337286=:5492
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 17 2007 11:44, GolovaSteek wrote:
>> How do you measure this?
>> If you want to have something done every 300 microseconds, you must not
>> sleep for 300 microseconds in each iteration, because you'd accumulate
>> errors. Use a periodic timer or use the current time to compute how long
>> to sleep in each iteration. Take a look how cyclictest does it.
>
>no. I just want my programm go to sleep sometimes and wake up in correct time.

Would it be acceptable to use an optimistic strategy, like the one below?

Let's say that the following tasks happen at each time: A at 0, B at 300, C at
600, D at 900, E at 1200, F at 1500. Assume sleeping takes 500 µs.
Then B and C could be run at 500, D at 1000 and E,F at 1500.


	Jan
-- 
---699020219-1470424275-1187337286=:5492--
