Return-Path: <linux-kernel-owner+w=401wt.eu-S1764434AbXHWQrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764434AbXHWQrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbXHWQrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:47:32 -0400
Received: from relay4.usu.ru ([194.226.235.39]:51423 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365AbXHWQrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:47:31 -0400
Message-ID: <46CDBA3D.7040402@ums.usu.ru>
Date: Thu, 23 Aug 2007 22:47:57 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: madduck@madduck.net
Subject: Re: what does this mean: "kernel: 7.0.0.1:53 L=79 S=0x00 I=39869
   F=0x4000 T=64"
References: <20070823100045.GA18793@piper.oerlikon.madduck.net> <46CDA81C.4060705@ums.usu.ru> <20070823154244.GA15919@piper.oerlikon.madduck.net>
In-Reply-To: <20070823154244.GA15919@piper.oerlikon.madduck.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

martin f krafft wrote:
> also sprach Alexander E. Patrakov <patrakov@ums.usu.ru> [2007.08.23.1730 +0200]:
>>> I am staring at this log message:
>>>   kernel: 7.0.0.1:53 L=79 S=0x00 I=39869 F=0x4000 T=64
>>> and I cannot figure out what it's trying to tell me. Could someone
>>> please enlighten me?
>> Looks like some DNS packet got logged by your firewall rules.
> 
> But my firewall rules certainly do not log DNS packets, and if they
> did, it would look very differently, no? I always prefix my iptables
> LOG messages anyway.

Sorry. Indeed, it differs very much from the normal packet log and 
cannot be obtained by truncation:

Aug 20 13:25:39 dsa kernel: packet trace: IN=eth0 OUT=eth2 
SRC=192.168.0.96 DST=192.36.143.150 LEN=76 TOS=0x00 PREC=0x00 TTL=63 
ID=0 DF PROTO=UDP SPT=123 DPT=123 LEN=56

> This is a Xen client, if it makes a difference.

None of the results of grep -r 'L=%' linux-2.6.22.1 match your string. 
So this must indeed be something out-of-tree - but Xen-3.1.0 or 3.0.4 
doesn't match either. Or function that produced this message in the log 
doesn't use printf-like functions for formatting numbers.

However, the style does look similar to a message in ipw2100.c:

IPW_DEBUG_TX("TX%d V=%p P=%04X T=%04X L=%d\n", i,
              &txq->drv[i],
              (u32) (txq->nic + i * sizeof(struct ipw2100_bd)),
              txq->drv[i].host_addr, txq->drv[i].buf_length);

-- 
Alexander E. Patrakov
