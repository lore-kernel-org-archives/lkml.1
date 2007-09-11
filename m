Return-Path: <linux-kernel-owner+w=401wt.eu-S1764098AbXIKNU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764098AbXIKNU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXIKNUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:20:52 -0400
Received: from web52008.mail.re2.yahoo.com ([206.190.48.57]:32404 "HELO
	web52008.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757755AbXIKNUv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:20:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ZG3K80xGeWlc415JREYDEtXpUyk/H3NcdOjOjfTyPGeP9pj4wqEWHupjlvagPORwa7q9G2TIJIbEu5kCXvuyTwOMJMtx/Q2SJo/QcHNIwRbTWZ4O/chZ20tfuOgg4U2Zutw3T7eCMkL1FJJyw1x1QILumxIxpWVh0SyHOxIsFoQ=;
X-YMail-OSG: aYoaF0UVM1lFVEgTKTfNLj6Hqg3XiDo3cMBvYeUFuWWs87EFQHmUyaI2siPFu9o2Pw--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Tue, 11 Sep 2007 06:20:51 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: Do not deprecate binary semaphore or do allow mutex in software interrupt contexts
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <11531.17274.qm@web52008.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I thought of a scenario where it seems appropriate to use a binary semaphore or a mutex in a software interrupt context. If a device cannot interrupt when some important variable changes, it can be polled occasionally to update e.g. LEDs to indicate status. Such polling can be done most efficiently in timers that are software interrupts. Timers are more efficient than works because they do not have so much context switching overhead. If the access to the variables of the device must be serialized, a binary semaphore or a mutex is a natural choice. If user-space writing to the device is likely to change the status, it can make sense not to poll the status of the device at the same time. The timer could therefore sensibly call mutex_trylock. Therefore, it seems wrong to me to deprecate binary semaphores and disallow the use of mutexes in software interrupt contexts.




      __________________________________  
Yahoo! Clever: Sie haben Fragen? Yahoo! Nutzer antworten Ihnen. www.yahoo.de/clever

