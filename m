Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbYEZBlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbYEZBlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 21:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYEZBlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 21:41:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54826 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYEZBlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 21:41:21 -0400
Message-ID: <483A153F.7000907@garzik.org>
Date: Sun, 25 May 2008 21:41:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Cache coherency,
 transactions, parallels.
References: <20080525134055.GA30630@2ka.mipt.ru>
In-Reply-To: <20080525134055.GA30630@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote on the blog page:
> Probably there will be some kind of a status messages for servers (i.e.
> going offline, do not send me data, or I'm becoming slow, do not read
> from me and so on). 

Often you can capture this information in a more scalable manner, by 
having the clients measure an observable _output_ such as latency, over 
time.

Each transaction gives the client new feedback about the server(s) being 
offline (i.e. timeout), becoming slow, etc.


Another potential tool is having the server(s) send an abstract number, 
from 0-100, indicating their level of desire for new { read | write } 
transactions.  Let us call this client hint "weight".  Rather than have 
a bunch of status messages that indicate server load average, or 
do-not-read state, summarize this information into read_weight and 
write_weight hints to the client.

With just a few (two?) simple variables, the client is given the ability 
to automatically balance and scale load across the cluster, work around 
failing servers, etc.

Write balancing need not be overly complex...

	Jeff


