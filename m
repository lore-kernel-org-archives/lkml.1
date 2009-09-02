Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZIBQGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZIBQGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 12:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZIBQGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 12:06:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62849 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZIBQF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 12:05:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ofOJEdnhrDFJXuzkv2oleaYI06fncxnr4eZdWviNRo7rARm1PuZuMjzsWbHFo1XWj
	ZE/5Z/KqzFLRSpTGhgkCQ==
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0909021748310.25091@fbirervta.pbzchgretzou.qr>
References: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com>
	 <20090902101527.11561.59498.stgit@jazzy.zrh.corp.google.com>
	 <4A9E8711.1070807@trash.net>
	 <b5ddba180909020833w1739bd54t11fded8150007abc@mail.gmail.com>
	 <4A9E90E4.9080805@trash.net>
	 <alpine.LSU.2.00.0909021748310.25091@fbirervta.pbzchgretzou.qr>
Date: Wed, 2 Sep 2009 18:05:54 +0200
Message-ID: <b5ddba180909020905p2dd209ay435c4e161a5d2057@mail.gmail.com>
Subject: Re: [PATCH 1/3] netfilter: xt_ipvs (netfilter matcher for IPVS)
From: Hannes Eder <heder@google.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Patrick McHardy <kaber@trash.net>, lvs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org,
       =?ISO-8859-1?Q?Fabien_Duch=EAne?= <mad_fab@skynet.be>,
       Jean-Luc Fortemaison <jl.fortemaison@uclouvain.be>,
       Julian Anastasov <ja@ssi.bg>, Julius Volz <julius.volz@gmail.com>,
       Laurent Grawet <laurent.grawet@uclouvain.be>,
       Simon Horman <horms@verge.net.au>, Wensong Zhang <wensong@linux-vs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 2, 2009 at 17:49, Jan Engelhardt<jengelh@medozas.de> wrote:
>
> On Wednesday 2009-09-02 17:36, Patrick McHardy wrote:
>>>
>>> Nice, I'll use par->family.
>>>
>>> So in theory I do not even need a check like the following in the beginning?
>>>
>>>      if (family != NFPROTO_IPV4
>>> #ifdef CONFIG_IP_VS_IPV6
>>>          && family != NFPROTO_IPV6
>>> #endif
>>>              ) {
>>>              match = false;
>>>              goto out;
>>>      }
>>
>>With the AF_UNSPEC registration of your match, it might be used
>
> par->family always contains the NFPROTO of the invoking implementation,
> which can never be UNSPEC (except, in future, xtables2 ;-)
>
> par->match->family however may be UNSPEC if the module works that way.
> Which is why we have par->family.
>

I'll a check_entry function:

static bool ipvs_mt_check(const struct xt_mtchk_param *par)
{
	if (par->family != NFPROTO_IPV4
#ifdef CONFIG_IP_VS_IPV6
	    && par->family != NFPROTO_IPV6
#endif
		)
		return false;

	return true;
}

and remove the runtime check in ipvs_mt.
