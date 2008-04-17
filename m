Return-Path: <linux-kernel-owner+w=401wt.eu-S1765709AbYDQM6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765709AbYDQM6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbYDQM6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:58:41 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:37577 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbYDQM6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=FDw83UA463av1bYgJjZvCNFmbH9/adSpfpD37cVPy5WzZMmarcNL9qWIBodqbKlky1dAQO42tr2K64eKjDgRYq9pmQyz1RnAPcWtrlyj3BxgEj5w0nLX1ceQ9XasQTuc+1jAO9xhySbAh7vZConF7bC0Ys8QwNSy9XsXrhVS+8k=
Subject: Re: [PATCH] NET: catch signed nla_len() retval in tcf_simp_init()
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, 12o3l@tiscali.nl,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4806D847.2030806@trash.net>
References: <4806C501.20300@tiscali.nl>
	 <20080416.213712.78410382.davem@davemloft.net> <4806D847.2030806@trash.net>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 08:58:33 -0400
Message-Id: <1208437113.4420.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-17-04 at 06:55 +0200, Patrick McHardy wrote:

> The change is also unnecessary because the attribute was
> already validated and the length can not be less than zero.

Since act_simple is an academic example:
I think that a better solution is to add TCA_DEF_DATA (which is a
string) to the nla_policy. nla_policy is defined but at the moment it is
not used in the call to nla_parse_nested() - might as well use it.

Roel, would you like to take a crack at that? You will need to define
the max size of the string that TCA_DEF_DATA can hold (if you want to do
it cleanly then define it in include/linux/tc_act/tc_defact.h). This MAX
size will appear in the nla_policy.

cheers,
jamal

