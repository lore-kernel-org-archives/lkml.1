Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZBXEDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZBXEDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZBXEDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:03:34 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:47386 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751711AbZBXEDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:03:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DFeXoPo+Llx6GLUVIaQbt/bpS1jffT+uYgDxOq4eD5oxHPpqiyuFtwHzDH/qUqMzr6IzjYV2m0UKzi0ZyNs22rmFo4HcV06QyJrRkO99lInqP9NUgZ/DVh37/XKBYjH/vb0ZO6YCJCxe4wWnocP2AsDjdlsEzBHsuMV3pSqNtuY=  ;
X-YMail-OSG: dZdLdCIVM1mGD3bjOBImiQUMOTM80U.Eh6ykI_oz2sM_UcMfkoOLPRgwuflsuParQnwTIaIWCbJV_In5cgLUfFj6VIIvI7UzaBFwQWkWO.YGAnuv4WfcqWUTwnIkjMqSZjmDUhjYy2w4Mtm6GOujhUSWInm3uajosj9W_jz9BsXyVXvire4VgY1FVjMeUQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] v2 Teach RCU that idle task is not quiscent state at boot
Date: Tue, 24 Feb 2009 15:02:56 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, mingo@elte.hu,
       stable@kernel.org, akpm@linux-foundation.org, npiggin@suse.de,
       penberg@cs.helsinki.fi
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com>
In-Reply-To: <20090223204332.GA19861@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241502.57833.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 07:43:32 Paul E. McKenney wrote:

> @@ -80,6 +81,10 @@ void wakeme_after_rcu(struct rcu_head  *head)
>  void synchronize_rcu(void)
>  {
>  	struct rcu_synchronize rcu;
> +
> +	if (num_online_cpus() == 1)
> +		return;  /* If UP, synchronize_rcu() is a grace period! */
> +

Nice patch... May I just suggest a comment to say that this is
also a correctness requirement due to the grace period holdoff
for early boot?

