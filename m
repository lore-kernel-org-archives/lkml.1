Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZKVA1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZKVA1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 19:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZKVA1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 19:27:49 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:65493 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZKVA1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 19:27:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l2qkV6ujucucR65KC7BJ2LK+LSt0jEoieWkdweGq6Rxy11935ONmTIyXhcxjxZecpd
         eP2XdC2oF/n6JI88KYhI9fmF7TBbiwvltIpmO6GMrzesHuXY5ECMpMu/LqUQONDdmgUa
         gnsHgLihiTMgX7Q/eoqm8fahclNcLsvBIA3Zc=
Date: Sun, 22 Nov 2009 11:27:48 +1100
From: Robert Swan <swan.r.l@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091122002748.GA6605@swanrl.gmail.com>
Reply-To: swan.r.l@gmail.com
References: <20091121222319.GA3905@swanrl.gmail.com> <20091121232320.3262636c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091121232320.3262636c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 11:23:20PM +0000, Alan Cox wrote:
> > I can provide reasonably stripped down code which demonstrates the
> > problem.  It has been reproduced by one other person, though his delay
> > was about 2ms.
> 
> I would expect that.
> 
> I guess the obvious question would be "why are you using ptys for latency
> sensitive communications ?" They now queue like other ttys which fixes a
> whole ton of stuff but does mean they have normal tty latencies.

I have a client program designed to communicate with an external
device through a serial port.  It polls this device every 20ms or so.
I also have a server to simulate the physical device which allows me
to replay values captured previously (for testing and tuning the
client).  This simulated run doesn't usually need to model the elapsed
time so I can set the inter-polling delay to 0.  Obviously the 8ms
delay I now get drastically slows down these replays.

While I could rewrite the communications to optionally use pipes, or
get the client to reprocess a log file locally, what I have does seem
a reasonable use of ptys.

Have fun,

Rob.
