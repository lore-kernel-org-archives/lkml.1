Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbXLQRsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbXLQRsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXLQRsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:48:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:42234 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbXLQRsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RPc78GqJNo+b9F8aJ+OX744+sRU6pKrHc354+/P7SN5fr40FpmzSqCpFrTt/R7inybiRAKR0SsI3+PQT9Kqbbn/AtJK7xB9fQtx7Nt/y2s5GI0IB/elkRZblcnSqxQaZ7YRKkrKqzHML2IthQMED/bSp1egT8akJ/ZTaR9kvFeU=
Message-ID: <82e4877d0712170947v45929acv92e0d34c86d82c6d@mail.gmail.com>
Date: Mon, 17 Dec 2007 12:47:59 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: init_timer_deferrable conversion
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       "David Miller" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20071217090000.64499fba@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712162149220.4622@mini.warudkars.net>
	 <20071217095504.b02241ee.dada1@cosmosbay.com>
	 <20071217152943.10470215.dada1@cosmosbay.com>
	 <20071217090000.64499fba@deepthought>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 12:00 PM, Stephen Hemminger
<shemminger@linux-foundation.org> wrote:
> > > >
> > > > a) drivers/net/sky2.c - watchdog_timer. This was showing up high on
> > > > Powertop's list of things that cause routine wakeups from idle. After
> > > > converting to init_timer_deferrable() the wakeups went down and this one
> > > > no longer shows up in powertop's list. 25% reduction.
>
> This surprises me because it is a 1 hz timer and uses round_jiffies() in
> the current kernel.

I am using the current git and I already have low wakeups per second
to begin with - 5-7  and out of that 25% are attributed to sky2. Not
sure if that matches up with the 1 hz + round_jiffies() logic.

But is it conceptually ok to make this deferrable? I suppose yes as
it's just a watchdog that checks if the link is up and delaying that
would not make a difference?

Thanks
Parag
