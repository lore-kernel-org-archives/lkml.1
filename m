Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYHYVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYHYVk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYHYVkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:40:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:27345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYHYVkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RpHtD7yrCyeiyyVBVeTIMw7rk20aSavCed2XfTMZXI/fPUaCJTRKLKjxxyuyzdxEFW
         Sdl3hzYNDWNEL9cLrms9fJukgm0wbqwK4VKW9gBUsaR3wMZPuFsI+yT7vi52uuAyA7AX
         kB7m+4T3Y4agrTjP76lL5mPjpP/QxHewlt888=
Message-ID: <48B32683.5040203@gmail.com>
Date: Mon, 25 Aug 2008 16:39:15 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       John Ronciak <john.ronciak@gmail.com>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, bfields@fieldses.org, linux-nfs@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>	 <1219087258.7192.19.camel@localhost>	 <1219400624.18774.67.camel@zakaz.uk.xensource.com>	 <1219428489.6919.21.camel@localhost>	 <1219428818.27921.43.camel@localhost.localdomain>	 <56a8daef0808221233h68853587n6015ca7d809b17e1@mail.gmail.com>	 <1219435207.27921.51.camel@localhost.localdomain>	 <1219440202.9097.14.camel@localhost>	 <1219441041.27921.57.camel@localhost.localdomain>	 <1219442213.9097.25.camel@localhost>	 <1219603981.27921.145.camel@localhost.localdomain>	 <1219605422.14389.2.camel@localhost>  <1219605596.14389.5.camel@localhost> <1219615789.27921.152.camel@localhost.localdomain>
In-Reply-To: <1219615789.27921.152.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> (added some quoting from previous mail to save replying twice)
> 
> On Sun, 2008-08-24 at 15:19 -0400, Trond Myklebust wrote:
>> On Sun, 2008-08-24 at 15:17 -0400, Trond Myklebust wrote:
>>> >From the tcpdump, it looks as if the NFS server is failing to close the
>>> socket, when the client closes its side. You therefore end up getting
>>> stuck in the FIN_WAIT2 state (as netstat clearly shows above).
>>>
>>> Is the server keeping the client in this state for a very long
>>> period?
> 
> Well, it had been around an hour and a half on this occasion. Next time
> it happens I can wait longer but I'm pretty sure I've come back from
> time away and it's been wedged for at least a day. How long would you
> expect it to remain in this state for?
> 
>> BTW: the RPC client is closing the socket because it detected no NFS
>> activity for 5 minutes. Did you expect any NFS activity during this
>> time?
> 
> It's a mythtv box so at times where no one is watching anything and
> there isn't anything to record I expect NFS activity is pretty minimal.
> 
> Ian.
> 

Ian,

Do you have a recording group setup on the NFS partition that mythtv is
going to be accessing?

I have seen similar funny stuff happen, it used to happened around 2.6.22*
(on each end), and quit happening around 2.6.24* and now has started happening
again with 2.6.25* on both ends.

Similar to what you have the only thing I see is "NFS server not responding" and 
  restarting the NFS server end (/etc/init.d/nfs restart) appears to get things to
continue on the NFS client.    No other messages appear on either end that 
indicate that anything is wrong, other non-nfs partitions on the client work 
find, the machine is still up, and the NFS server is still up and fine, and 
after a restart things will again work for a while (hours or days).

                             Roger
