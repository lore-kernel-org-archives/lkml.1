Return-Path: <linux-kernel-owner+w=401wt.eu-S934401AbXG0Tkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbXG0Tkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932668AbXG0Tk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:40:29 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:62666 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbXG0Tk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:40:28 -0400
Message-ID: <46AA4A1E.8040302@nortel.com>
Date: Fri, 27 Jul 2007 13:40:14 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
References: <20070717180550.GA24759@enneenne.com> <1185197716.14697.244.camel@pmac.infradead.org> <20070724080013.GA22171@gundam.enneenne.com> <1185284942.14697.319.camel@pmac.infradead.org> <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com>
In-Reply-To: <20070727192848.GW9840@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2007 19:40:17.0664 (UTC) FILETIME=[F5D03800:01C7D085]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:

> What do you mean? Did you find an error into my patch? :-o
> 
> Functions pps_event() and
> pps_register_source()/pps_unregister_source() take accesso to shared
> data, that's why I used spinlocks.

My point is that the lock should be used to protect specific data. 
Thus, it would be more correct to say, "spinlock foo is taken because 
pps_register_source() accesses variable bar".

That way, if someone else wants to access "bar", they know that they 
need to take lock "foo".

Chris
