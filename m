Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbXJTELv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbXJTELv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 00:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXJTELo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 00:11:44 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:26081 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751935AbXJTELo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 00:11:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=ZZcSDyMKPwB/3z+DXI8CPLAT94frPX2RLvnp4N0vhuFoK2hlYGiMpQvr6rls2WrRDlzGlZZwBqc7r0PKJR1/UcGikV0O7v7nvgFeGcEoDSzQ15v1NRTBWwXS4Vx9c5mZB4RE6c08WizTkyawBBsyQqh54bBRP/zW4wAnLQJTMA0=  ;
X-YMail-OSG: Tjw.tK8VM1mxX6caWCJ_KPSkIxLMSy0LUTM2Gza6p_E6jxMrbZ9fauym8ibTB_TjWMrDBlBhng--
Date: Fri, 19 Oct 2007 21:11:40 -0700
From: David Brownell <david-b@pacbell.net>
To: rdunlap@xenotime.net
Subject: Re: 2.6.23-git Kconfig regression
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071019184607.06e1eef9.randy.dunlap@oracle.com>
 <20071020015735.270C923A748@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <47196165.8070406@oracle.com>
 <20071019195535.0dbafd39.rdunlap@xenotime.net>
 <20071019202140.ecbc4a0d.rdunlap@xenotime.net>
In-Reply-To: <20071019202140.ecbc4a0d.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071020041140.0E41423A734@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> My (quick, meaning that I may have missed something) testing
> indicates that the problem is in the patches attached.

Yes, reverting this seems to resolve the problem:

> a5bf3d891a6a0fb5aa122792d965e3774108b923
>
> Change kconfig behavior so that mixing bool and tristate config settings in
> a choice is possible and has the desired effect of offering just the
> tristate options individually if the choice gets set to M, and a normal
> boolean selection if the choice gets set to Y.

Reverting this patch also fixes a second problem that I didn't
mention:  various dependent options couldn't be enabled.

Again in drivers/usb/gadget/Kconfig, examples include the
ability to configure the Ethernet gadget to act as an RNDIS
peripheral; or enabling Mass Storage gadget debug options.


Good sleuthing, and thanks!

Now we just need to see that patch reverted before RC1... I don't
know how Linus deals with all his LKML mail, so I cc'd him in
the hope that direct messages get through a bit faster.

- Dave

