Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYI3H2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYI3H2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYI3H2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:28:14 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:31342 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751489AbYI3H2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:28:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eISpQaz4yjGPKbKMW8HUSE+1lJVRWqoSweS25ALTxfbLIetUc+kQ3Ldb+T158QD0qzgdm52ebqrbu+0jtmhlMBkIoq34ISLs+hYdJ0qJ1hQAwGxhkeZkAfIv/LWRHwUllv4LXgsSEHtlgiJY51wSyXw96Ce4bxFF4YtNJw5Ocz8=  ;
X-YMail-OSG: VAAD9tMVM1lwnYez8YvaarEjLfKTdv7mZ3AuDbntnxwACGOhOz.lcZOQdpwCcKIeM.slo7tnWcYkP6FypkN098rUjnq3gK.8hj9FDoP4xUXwezhe65P4zZ6yiQl3LSIJI5q1_hzKZf4gsZCMQNbbTkPbZXUU.g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct - v3
Date: Tue, 30 Sep 2008 17:28:01 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
References: <20080913000003.732756000@linux-os.sc.intel.com> <48D966AE.1040008@linux-foundation.org> <20080924155332.GA29041@linux-os.sc.intel.com>
In-Reply-To: <20080924155332.GA29041@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301728.02269.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2008 01:53, Venki Pallipadi wrote:

>  /*
> + * RED-PEN:  TODO: Add PageReserved() check as well here,
> + * once we add SetPageReserved() to all the drivers using
> + * set_memory_* or set_pages_*.
> + *
> + * This will help prevent accidentally freeing pages
> + * before setting the attribute back to WB.
> + */

I'd rather we didn't add any more uses of PageReserved without a
really good reason.

At this point in time (or at least last time I looked, a year or
two ago), it isn't a whole lot of work to remove PG_reserved
completely. If the waters get muddied up again, it could require
another significant rework to remove it in future...

Thanks,
Nick
