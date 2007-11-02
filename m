Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXKBW6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXKBW6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 18:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXKBW62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 18:58:28 -0400
Received: from palrel13.hp.com ([156.153.255.238]:55641 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbXKBW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 18:58:27 -0400
Message-ID: <472BAB90.8020306@hp.com>
Date: Fri, 02 Nov 2007 15:58:24 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: bizarre network timing problem
References: <20071017205127.GA21334@codeblau.de> <47167BDE.4000103@redhat.com>	<20071017220019.GA22765@codeblau.de> <471689BF.2040909@hp.com>	<20071018094230.GA2978@codeblau.de> <4717964A.8080100@hp.com>	<20071102221146.GA4354@codeblau.de> <472BA5BC.6000901@hp.com> <20071102223856.GA5121@codeblau.de>
In-Reply-To: <20071102223856.GA5121@codeblau.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Felix von Leitner wrote:
> Thus spake Rick Jones (rick.jones2@hp.com):
> 
>>>Oh I'm pretty sure it's not my application, because my application performs
>>>well over ethernet, which is after all its purpose.  Also I see the
>>>write, the TCP uncork, then a pause, and then the packet leaving.
>>
>>Well, a wise old engineer tried to teach me that the proper spelling is 
>>ass-u-me :) so just for grins, you might try the TCP_RR test anyway :)  And 
>>even if your application is correct (although I wonder why the receiver 
>>isn't sucking data-out very quickly...) if you can reproduce the problem 
>>with netperf it will be easier for others to do so.
> 
> 
> My application is only the server, the receiver is smbget from Samba, so
> I don't feel responsible for it :-)

Might want to strace it anyway... no good deed (such as reporting a potential 
issue) goes unpunished :)

> Still, when run over Ethernet, it works fine without waiting for
> timeouts to expire.

Past performance is no guarantee of current correctness :)  And over an 
Ethernet, there will be a very different set of both timings and TCP segment 
sizes compared to loopback.

My guess is that you will find setting the lo mtu to 1500 a very interesting 
experiment.

> 
> To reproduce this:
> 
>   - smbget is from samba, you probably already have this
>   - gatling (my server) can be gotten from
>     cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co dietlibc libowfat gatling
> 
> dietlibc is not strictly needed, but it's my environment.
> First built dietlibc, then libowfat, then gatling.
> 
> Felix

