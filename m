Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbXCEQBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbXCEQBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbXCEQA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:00:27 -0500
Received: from tcsfw4.tcs-sec.com ([65.127.223.133]:1164 "EHLO
	tcsfw4.tcs-sec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582AbXCEQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:00:24 -0500
Reply-To: <vyekkirala@TrustedCS.com>
From: "Venkat Yekkirala" <vyekkirala@TrustedCS.com>
To: "'Eric Paris'" <eparis@parisplace.org>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Cc: <davem@davemloft.net>, <jamesm@namei.org>,
       "Venkat Yekkirala" <vyekkirala@tcsfw4.tcs-sec.com>,
       <cxzhang@watson.ibm.com>, <sds@tycho.nsa.gov>, <latten@austin.ibm.com>
Subject: RE: [PATCH] xfrm_policy delete security check misplaced
Date: Mon, 5 Mar 2007 09:33:27 -0600
Message-ID: <001301c75f3b$9efedb00$cc0a010a@tcssec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2911.0)
Importance: Normal
In-Reply-To: <1172860190.31047.11.camel@localhost.localdomain>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1441
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2552,7 +2550,7 @@ static int pfkey_spdget(struct sock 
> *sk, struct sk_buff *skb, struct sadb_msg *h
>  		return -EINVAL;
>  
>  	xp = xfrm_policy_byid(XFRM_POLICY_TYPE_MAIN, dir, 
> pol->sadb_x_policy_id,
> -			      hdr->sadb_msg_type == SADB_X_SPDDELETE2);
> +			      hdr->sadb_msg_type == 
> SADB_X_SPDDELETE2, &err);
>  	if (xp == NULL)
>  		return -ENOENT;
I guess you meant to do this here?
	else if (err)
		return err;

Also, [Joy cc'd] deletions here needn't be audited?
