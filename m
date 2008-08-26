Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbYHZT2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbYHZT2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbYHZT1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:27:40 -0400
Received: from mail.fieldses.org ([66.93.2.214]:32947 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbYHZT1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:27:38 -0400
Date: Tue, 26 Aug 2008 15:27:11 -0400
To: Tom Tucker <tom@opengridcomputing.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Ian Campbell <ijc@hellion.org.uk>,
       John Ronciak <john.ronciak@gmail.com>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
Message-ID: <20080826192711.GJ4380@fieldses.org>
References: <1219435207.27921.51.camel@localhost.localdomain> <1219440202.9097.14.camel@localhost> <1219441041.27921.57.camel@localhost.localdomain> <1219442213.9097.25.camel@localhost> <1219603981.27921.145.camel@localhost.localdomain> <1219605422.14389.2.camel@localhost> <1219605596.14389.5.camel@localhost> <1219615789.27921.152.camel@localhost.localdomain> <1219616136.14389.12.camel@localhost> <48B2D7F8.5020206@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B2D7F8.5020206@opengridcomputing.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 11:04:08AM -0500, Tom Tucker wrote:
> Trond Myklebust wrote:
>> On Sun, 2008-08-24 at 23:09 +0100, Ian Campbell wrote:
>>> (added some quoting from previous mail to save replying twice)
>>>
>>> On Sun, 2008-08-24 at 15:19 -0400, Trond Myklebust wrote:
>>>> On Sun, 2008-08-24 at 15:17 -0400, Trond Myklebust wrote:
>>>>> >From the tcpdump, it looks as if the NFS server is failing to close the
>>>>> socket, when the client closes its side. You therefore end up getting
>>>>> stuck in the FIN_WAIT2 state (as netstat clearly shows above).
>>>>>
>>>>> Is the server keeping the client in this state for a very long
>>>>> period?
>>> Well, it had been around an hour and a half on this occasion. Next time
>>> it happens I can wait longer but I'm pretty sure I've come back from
>>> time away and it's been wedged for at least a day. How long would you
>>> expect it to remain in this state for?
>>
>> The server should ideally start to close the socket as soon as it
>> receives the FIN from the client. I'll have a look at the code.
>>
>
> I don't think it should matter how long the connection stays in FIN WAIT,
> the client should reconnect anyway.
>
> Since the client seems to be the variable, I would think it might be an
> issue with the client reconnect logic?
>
> That said, 2.6.25 is when the server side transport switch logic went in.

Any chance you could help Trond figure out why the server might be doing
this?

If not, I'll get to it, but not as soon as I should.

--b.
