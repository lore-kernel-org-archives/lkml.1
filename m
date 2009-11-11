Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZKKHrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZKKHrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZKKHrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:47:35 -0500
Received: from gesmail.globaledgesoft.com ([203.76.137.4]:37684 "EHLO
	gesmail.globaledgesoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355AbZKKHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:47:35 -0500
Message-ID: <4AFA6C0D.2020101@globaledgesoft.com>
Date: Wed, 11 Nov 2009 13:17:25 +0530
From: "ramaswamy.bm" <ramaswamy.bm@globaledgesoft.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: kaber@trash.net
CC: arrow.jianqing@gmail.com, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Subject: RE: port bound SAs : ip xfm state command  ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the command to write port based SA's using ip xfrm state.

iam using below command for writing SA's : 
ip xfrm state add src 192.168.1.20 dst 192.168.1.5 proto esp spi 
0x354cb04b mode tunnel reqid 16385 replay-window 32 auth sha1 
0xecf02a5cf6568556e1bdcd961c7ec3f92afd01cc enc aes 
0x5c0cfa9672ce67ba545b593076dfb278 sel src 0.0.0.0/0 dst 0.0.0.0/0  

Thanks in advance 
Ram


he pfkey / xfrm interface throws them away

i fixed racoon to send the port numbers and they were ignored

-----Original Message-----
From: Patrick McHardy [mailto:kaber@...sh.net] 
Sent: Tuesday, January 27, 2009 9:12 AM
To: Paul Moore
Cc: David Miller; netdev@...r.kernel.org
Subject: Re: port bound SAs

Paul Moore wrote:
> i did exactly that (in the original message) and it makes this test
case
> work but as I point out
> 
> a) it should not be necessary 
> b) i get more SAs than I need
> c) i can no longer say that a SA is optional (this is an error in the
> pfkey/xfrm/racoon interface to combine two orthogonal concepts)
> d) I am not convinced that I have resolved all cases. Needs more
testing

IIRC I tested port selectors in SA a few years ago using "ip xfrm"
and they worked fine. The xfrm interface doesn't ignore them 
(copy_from_user_state()), I think the pfkey interface also doesn't.

Please try configuring them manually using "ip xfrm state",
I'm pretty sure the bug is actually in racoon.
--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@...r.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

