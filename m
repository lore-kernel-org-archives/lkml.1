Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbXCPMzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbXCPMzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 08:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933618AbXCPMzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 08:55:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:60274 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612AbXCPMzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 08:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I1OngsvbfClXEatCyHqy4PM9E/4enLRdxGBpyswHLQHMUxNJp14YWfCkiGyTXRsIk+iTTDCpX+HhGGWJolVthnc4/t3vwRvRChZPWcptVkkivTtniiJNqMp2/Yy4rkvWgOCGMiWaXskyaFFo98ZpHwRcy9ew/U2KpXX+tiPtLWk=
Message-ID: <2f4958ff0703160555rb7fd37cv4dedc6e39cdbd8c2@mail.gmail.com>
Date: Fri, 16 Mar 2007 08:55:19 -0400
From: "=?ISO-8859-2?Q?Grzegorz_Ja=B6kiewicz?=" <gryzman@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: pcap app causes kernel panic on 2.4.33.3 right after "NETDEV WATCHDOG: eth1: transmit timed out"
In-Reply-To: <2f4958ff0703120410j321c88a0pad91f78778520fc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f4958ff0703120410j321c88a0pad91f78778520fc8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I would really appreciate someone looking at that oops below, and just
giving me some hints to the problem please.

> Oops:
>
> Unable to handle kernel paging request at virtual address 909fe955
>  c013b582
>  *pde = 00000000
>  Oops: 0000
>  CPU:   0
>  eax: 909fe93d  ebx: 00000001 ecx: 909fe93d  edx: 00000000
>  esi: cf4e6d90  edi: 00000000 ebp: 00000000  esp: c3701c58
>  ds: 0018   es: 0018  ss: 0018
>  Process postmaster (pid:3838, stackpage=c3701000)
>  Stack: c031a7ec 00000000 cf4e6d80 cf4e6d80 c031a847 cf4e6d80 c3701c94 cf4e6d80
>         c7ad6810 c031a9ae cf4e6d80 00000000 cf4e6d80 c0339a6d cf4e6d80 c031f187
>         00000000 c0468a5c 00000046 c0468a6c 00000246 cf4e6d80 cfd03740 00000000
>  Call Trace:    [<c031a7ec>] [<c031a847>] [<c031a9ae>] [<c0339a6d>] [<c031f187>]
>    [<c031f70e>] [<c031f810>] [<c031f97f>] [<c0122586>] [<c033cad0>] [<c0329c28>]
>    [<c033cad0>] [<c033e58f>] [<c033cad0>] [<c035dfe2>] [<c035dc50>] [<c01868dd>]
>    [<c017e6fb>] [<c03169e4>] [<c03167bc>] [<c0317be4>] [<c018bbb8>] [<c0186d68>]
>    [<c0186e9c>] [<c0317c53>] [<c0318637>] [<c0108eff>]
>  Code: 8b 40 18 f6 c4 40 75 0b f0 ff 49 14 0f 94 c0 84 c0 75 01 c3
> Using defaults from ksymoops -t elf32-i386 -a i386
>
>
> >>esi; cf4e6d90 <_end+f026bf8/10603ec8>
> >>esp; c3701c58 <_end+3241ac0/10603ec8>
>
> Trace; c031a7ec <skb_release_data+4c/90>
> Trace; c031a847 <kfree_skbmem+17/80>
> Trace; c031a9ae <__kfree_skb+fe/160>
> Trace; c0339a6d <ip_rcv+ad/4e0>
> Trace; c031f187 <netif_rx+97/1f0>
> Trace; c031f70e <netif_receive_skb+20e/270>
> Trace; c031f810 <process_backlog+a0/140>
> Trace; c031f97f <net_rx_action+cf/180>
> Trace; c0122586 <do_softirq+76/e0>
> Trace; c033cad0 <output_maybe_reroute+0/10>
> Trace; c0329c28 <.text.lock.netfilter+b6/ce>
> Trace; c033cad0 <output_maybe_reroute+0/10>
> Trace; c033e58f <ip_build_xmit+3af/440>
> Trace; c033cad0 <output_maybe_reroute+0/10>
> Trace; c035dfe2 <udp_sendmsg+232/4a0>
> Trace; c035dc50 <udp_getfrag+0/100>
> Trace; c01868dd <journal_dirty_metadata+15d/220>
> Trace; c017e6fb <ext3_do_update_inode+19b/450>
> Trace; c03169e4 <sock_sendmsg+74/d0>
> Trace; c03167bc <sockfd_lookup+1c/90>
> Trace; c0317be4 <sys_sendto+f4/130>
> Trace; c018bbb8 <log_wait_commit+68/b0>
> Trace; c0186d68 <journal_stop+168/230>
> Trace; c0186e9c <journal_force_commit+6c/90>
> Trace; c0317c53 <sys_send+33/40>
> Trace; c0318637 <sys_socketcall+167/280>
> Trace; c0108eff <system_call+33/38>
>
> Code;  00000000 Before first symbol
> 00000000 <_EIP>:
> Code;  00000000 Before first symbol
>    0:   8b 40 18                  mov    0x18(%eax),%eax
> Code;  00000003 Before first symbol
>    3:   f6 c4 40                  test   $0x40,%ah
> Code;  00000006 Before first symbol
>    6:   75 0b                     jne    13 <_EIP+0x13>
> Code;  00000008 Before first symbol
>    8:   f0 ff 49 14               lock decl 0x14(%ecx)
> Code;  0000000c Before first symbol
>    c:   0f 94 c0                  sete   %al
> Code;  0000000f Before first symbol
>    f:   84 c0                     test   %al,%al
> Code;  00000011 Before first symbol
>   11:   75 01                     jne    14 <_EIP+0x14>
> Code;  00000013 Before first symbol
>   13:   c3                        ret
>
>  <0>Kernel panic: Aiee, killing interrupt handler!


-- 
GJ
