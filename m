Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbXLSQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbXLSQfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXLSQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:35:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:60021 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXLSQfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:35:33 -0500
Message-ID: <4769483E.4070600@windriver.com>
Date: Wed, 19 Dec 2007 10:35:10 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ramagudi Naziir <naziirr@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: a problem with NETPOLL/KGDBoE
References: <dfb262380712061022h43eab6eaxe231b1f81f54d433@mail.gmail.com>	 <20071206183423.GZ19691@waste.org> <dfb262380712190822l48f706b5k345762e233b693ae@mail.gmail.com>
In-Reply-To: <dfb262380712190822l48f706b5k345762e233b693ae@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2007 16:35:11.0967 (UTC) FILETIME=[203316F0:01C8425D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ramagudi Naziir wrote:
> On 12/6/07, Matt Mackall <mpm@selenic.com> wrote:
>   
>> netpoll will ignore incoming UDP -from- the wrong port/ip/mac, since
>> it's otherwise bypassing the firewall layer.
>>     
> I have checked it out.
> Seems like there is absolutely no way to configure the source
> port gdb uses for the udp connection. So one must invoke a
> "target remote udp:ip:port" command, see what was the
> chosen source port (tcpdump/netstat), and reconfigure kgdb on the target.
> While this works, it is rather awkward.
>
> Do you think there is/can be another way to solve this issue
> (like allowing NETPOLL to listen to a wildcard udp source port) ?
>
>   

What module parameters did you pass to kgdboe and what kernel are you
using and are you using the kgdb source forge patches?

I had not looked to see if anything changed in the latest net poll api,
but previously with the 2.6.21 kernel as example, the net poll api
ignored the source port parameter entirely.  If this has changed, I
would be happy to make a further change to zero out the port or do what
is needed to make it dynamic again, in a similar fashion to the way the
MAC address parsing is dynamic for KGDB + the net poll api.

Jason.

Also you can omit the linux-kernel mailling and take this up at:
kgdb-bugreport@lists.sourceforge.net if you are using the source forge
patches.
