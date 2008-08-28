Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYH1TiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYH1TiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbYH1Thq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:37:46 -0400
Received: from smtp2f.orange.fr ([80.12.242.152]:49284 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbYH1Tho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:37:44 -0400
X-ME-UUID: 20080828193740766.BB1367000083@mwinf2f18.orange.fr
Message-ID: <48B6FE6C.4080905@cosmosbay.com>
Date: Thu, 28 Aug 2008 21:37:16 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Andi Kleen <andi@firstfloor.org>, Joe Malicki <jmalicki@metacarta.com>,
       David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <20080827.201020.17601834.davem@davemloft.net> <200808281948.52608.denys@visp.net.lb> <48B6F4FE.6010308@cosmosbay.com> <200808282225.57535.denys@visp.net.lb>
In-Reply-To: <200808282225.57535.denys@visp.net.lb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko a écrit :
> On Thursday 28 August 2008, Eric Dumazet wrote:
>> 2) You maybe have a bad program that do something expensive relative to
>> kernel time services.
> No, process list is very short, it is custom semi-embedded linux distro i 
> made, so i know each process running there.  Here is process list (kernel 
> processes/threads and running shell(busybox ash) removed) 
> 
> 1 root     /bin/sh /init
>  1119 root     init
>  2451 root     /sbin/syslogd -R 80.83.17.2
>  2453 root     /sbin/klogd
>  3168 squid    /usr/sbin/zebra -d
>  3175 squid    /usr/sbin/ripd -d
>  3195 root     /usr/sbin/snmpd -c /config/snmpd.conf
>  3208 root     udhcpd /config/udhcp.office.conf -S
>  3550 root     /usr/sbin/sshd -b /etc/banner
>  3566 root     /sbin/getty 38400 tty1
>  3567 root     /sbin/getty 38400 tty2
>  3570 root     /sbin/getty 38400 tty3
>  4055 root     /usr/sbin/sshd -b /etc/banner
> 

OK, please try oprofile with call graph analysis.

> 
>> kernel already provides nanosecond resolution :)
>> Check SO_TIMESTAMPNS and SCM_TIMESTAMPNS
> Maybe this function really must be "heavy" then.

Nope... the contrary :)

Kernel timestamping has nanosec resolution.

SO_TIMESTAMP needs a divide (by 1000), while SO_TIMESTAMPNS is native.





