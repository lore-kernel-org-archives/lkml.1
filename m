Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYHYQEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYHYQEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYHYQEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:04:10 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:37017 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbYHYQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:04:09 -0400
Message-ID: <48B2D7F8.5020206@opengridcomputing.com>
Date: Mon, 25 Aug 2008 11:04:08 -0500
From: Tom Tucker <tom@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Ian Campbell <ijc@hellion.org.uk>, John Ronciak <john.ronciak@gmail.com>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, bfields@fieldses.org, linux-nfs@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>	 <1219087258.7192.19.camel@localhost>	 <1219400624.18774.67.camel@zakaz.uk.xensource.com>	 <1219428489.6919.21.camel@localhost>	 <1219428818.27921.43.camel@localhost.localdomain>	 <56a8daef0808221233h68853587n6015ca7d809b17e1@mail.gmail.com>	 <1219435207.27921.51.camel@localhost.localdomain>	 <1219440202.9097.14.camel@localhost>	 <1219441041.27921.57.camel@localhost.localdomain>	 <1219442213.9097.25.camel@localhost>	 <1219603981.27921.145.camel@localhost.localdomain>	 <1219605422.14389.2.camel@localhost>  <1219605596.14389.5.camel@localhost>	 <1219615789.27921.152.camel@localhost.localdomain> <1219616136.14389.12.camel@localhost>
In-Reply-To: <1219616136.14389.12.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Sun, 2008-08-24 at 23:09 +0100, Ian Campbell wrote:
>> (added some quoting from previous mail to save replying twice)
>>
>> On Sun, 2008-08-24 at 15:19 -0400, Trond Myklebust wrote:
>>> On Sun, 2008-08-24 at 15:17 -0400, Trond Myklebust wrote:
>>>> >From the tcpdump, it looks as if the NFS server is failing to close the
>>>> socket, when the client closes its side. You therefore end up getting
>>>> stuck in the FIN_WAIT2 state (as netstat clearly shows above).
>>>>
>>>> Is the server keeping the client in this state for a very long
>>>> period?
>> Well, it had been around an hour and a half on this occasion. Next time
>> it happens I can wait longer but I'm pretty sure I've come back from
>> time away and it's been wedged for at least a day. How long would you
>> expect it to remain in this state for?
> 
> The server should ideally start to close the socket as soon as it
> receives the FIN from the client. I'll have a look at the code.
> 

I don't think it should matter how long the connection stays in FIN WAIT,
the client should reconnect anyway.

Since the client seems to be the variable, I would think it might be an
issue with the client reconnect logic?

That said, 2.6.25 is when the server side transport switch logic went in.

Tom

> Trond
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

