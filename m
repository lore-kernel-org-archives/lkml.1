Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbZD3U0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbZD3U0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 16:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZD3U0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 16:26:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37748 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZD3U0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 16:26:31 -0400
From: =?ISO-8859-2?Q?T=F3th_L=E1szl=F3_Attila?= <panther@elte.hu>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20090430.093909.157285653.davem@davemloft.net>
Subject: Re: [PATCH] xt_socket: checks for the state of nf_conntrack
References: <1241105755-10017-1-git-send-email-panther@balabit.hu> <20090430.093909.157285653.davem@davemloft.net>
Message-Id: <3512771A-B2D4-48F5-90A6-AF0FAA1633D5@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Date: Thu, 30 Apr 2009 22:26:24 +0200
Cc: panther@balabit.hu, kaber@trash.net, mingo@elte.hu, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, hidden@sch.bme.hu,
       linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.930.3)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -7.6
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-7.6 required=5.9 tests=ALL_TRUSTED,BAYES_00,L_AUTH,SPF_NEUTRAL autolearn=ham SpamAssassin version=3.2.5
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-5.0 L_AUTH                 Caesar auth
	0.7 SPF_NEUTRAL            SPF: sender does not match SPF record (neutral)
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 2009.04.30., at 18:39, David Miller wrote:

> From: Laszlo Attila Toth <panther@balabit.hu>
> Date: Thu, 30 Apr 2009 17:35:55 +0200
>
>> xt_socket can use connection tracking, and checks whether it is a  
>> module.
>>
>> Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
>
> I don't understand why we want what this is doing....
>

Most of the time the source / destination addresses and ports of the  
packet are enough to lookup the corresponding socket. With the SNAT  
target this kind of lookup is broken. The socket match is in the  
mangle table, before nat, thus it can see only the destination address  
set by the SNAT target (this is the reply direction). If we want to  
support SNAT, we need nf_conntrack.  But this is optional, if  
connection tracking is not in the kernel, the socket match will  
compiled without it....

>> +	depends on !NF_CONNTRACK || NF_CONNTRACK
>
> This means that if NF_CONNTRACK is modular, it won't allow
> the xt_socket code to be built.
>

I checked that if NF_CONNTRACK is disabled, the socket match will be  
allowed to be built either into a module, or into vmlinuz. If  
NF_CONNTRACK is "y", it is exactly the same. If NF_CONNTRACK=m, the  
socket match can only be a module.

> However, all of this stuff should be buildable modular.

--
Attila