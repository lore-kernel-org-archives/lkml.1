Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZG0Ket@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZG0Ket (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 06:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZG0Kes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 06:34:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38943 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbZG0Ker (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 06:34:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DpjltUl/UvG9PvOFjAPMA/F5Yr6AecKYngW2Jp7PFgR/bDR3080RWPNoQlBRM3eyO
	fN2nbdGO/+oYgWYejsSew==
MIME-Version: 1.0
In-Reply-To: <4A6D7285.9080909@gmail.com>
References: <20090727090741.16509.35291.stgit@jazzy.zrh.corp.google.com>
	 <4A6D7285.9080909@gmail.com>
Date: Mon, 27 Jul 2009 12:34:42 +0200
Message-ID: <b5ddba180907270334m4bc4e968m85c16ea4756c3f5d@mail.gmail.com>
Subject: Re: [PATCH] IPVS: logging sizeof(struct ip_vs_conn) on startup
From: Hannes Eder <heder@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, lvs-users@linuxvirtualserver.org,
       malcolm@loadbalancer.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 11:25, Eric Dumazet<eric.dumazet@gmail.com> wrote:
> Well, ip_vs_conn_cache uses SLAB_HWCACHE_ALIGN, so this should be rounded up
> to L1 cache size. Or add "at least" like in line 1080
> of net/netfilter/ipvs/ip_vs_conn.c :
>
> IP_VS_DBG(0, "Each connection entry needs %Zd bytes at least\n",
>           sizeof(struct ip_vs_conn));

Good point.  Is there an easy way to figure out how much memory is
wasted for alignment by the slab allocator?  Otherwise I vote for the
"at least" approach.

-Hannes
