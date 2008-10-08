Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYJHSqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYJHSqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 14:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYJHSpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 14:45:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35910
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753087AbYJHSpw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 14:45:52 -0400
Date: Wed, 08 Oct 2008 11:45:27 -0700 (PDT)
Message-Id: <20081008.114527.189056050.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: shemminger@vyatta.com, benny+usenet@amorsen.dk, minyard@acm.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <48ECBBD8.9060602@cosmosbay.com>
References: <20081007160729.60c076c4@speedy>
	<20081007.135548.56141000.davem@davemloft.net>
	<48ECBBD8.9060602@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 08 Oct 2008 15:55:36 +0200

> David Miller a écrit :
> > From: Stephen Hemminger <shemminger@vyatta.com>
> > Date: Tue, 7 Oct 2008 16:07:29 +0200
> > 
> >> The idea of keeping chains short is the problem. That code should
> >> just be pulled because it doesn't help that much, and also creates
> >> bias on the port randomization.
> > I have that patch from Vitaly Mayatskikh which does exactly this.
> > I keep looking at it, but I can't bring myself to apply it since
> > I'm not completely convinced.
> 
> Vitaly patch might be appropriate if only few UDP ports are opened.
> 
> We could zap the code to search short chains and extend Vitaly's
> idea with following patch :

I really like this, and I've applied it to net-next-2.6

I think the "increment until back in range" do/while loop can
be improved a bit.  It can spin for more than 60,000 iterations
in some edge case scenerios as-is :-)

Ugh, there's also that expensive divide in there for the modulus.
