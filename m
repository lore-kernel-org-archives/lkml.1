Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0BDCDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:03:50 -0500
Received: from [12.51.93.24] ([12.51.93.24]:45699 "EHLO mail.asimco-na.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab0BDCDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:03:47 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.27.7-9-pae #7 SMP 1/1] networking tcp: Writing tcp socket be atomic
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 4 Feb 2010 10:03:44 +0800
Message-ID: <DB4F116661E3B0428456BB7E379EF4BB3C5F57@MX.asimcotech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.27.7-9-pae #7 SMP 1/1] networking tcp: Writing tcp socket be atomic
Thread-Index: Acqk8T7vjVlNYGhIRK6V4u3vsfawqwATF1ig
References: <474C17045AA24E3F8519EE76BAB47439@JOHNYE1> <20100203.085249.98326242.davem@davemloft.net>
From: "John Ye" <johny@asimco.com.cn>
To: "David Miller" <davem@davemloft.net>
Cc: <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>, <jmorris@namei.org>,
       <kaber@coreworks.de>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Feb 2010 01:51:41.0052 (UTC) FILETIME=[989CE3C0:01CAA53C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Thanks.
The option TCP_ATOMIC is not a must.
We can make atomic be default if the data size is less than a fixed size, just the same as pipe.
For example, if the data size is less than 512, we don't split the data so it goes atomically.

John Ye


-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: 2010Äê2ÔÂ4ÈÕ 0:53
To: John Ye
Cc: kuznet@ms2.inr.ac.ru; netdev@vger.kernel.org; jmorris@namei.org; kaber@coreworks.de; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27.7-9-pae #7 SMP 1/1] networking tcp: Writing tcp socket be atomic


Locking belongs inside of the application, not in the kernel.

As evidenced by the fact that you had to add new socket options, the
application needs to be modified anyways.

It's therefore just as easy to add the appropriate locking to the
sequences where the application writes over the TCP socket.  And
it avoids having to modify the kernel at all.
