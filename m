Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYIKOBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYIKOBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYIKOBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:01:07 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:32140 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751935AbYIKOBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:01:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yJhjBLi9WuL+jHTIgn+zTFDQWFCfTw52MI2AU5vGUvTtTH3+5ll9g1VmKfDYJtN4wXB9ykN5u+srOD2yOStRyJQ0TFuDsWuv2QdBkF/BTY0yc53V+ElYs+pYrvdGeXms1HTXX33PwuP5YRSqERFTSMB5WEDC+v7mWukGdmOsdsQ=  ;
X-YMail-OSG: 1HgayZIVM1mwycZ4WHvJZYp58dqhFkRQz9s1U.MKMPU1oMFcKGOyq.U60C3Bah_XvNMJ8M7G2_ZvrEgrI0cIWr0CJnNjtjQ2Tyit3dCNgjSXQ1z0vLe_yPVS.oANMX2dvGk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH 8/9] memcg: remove page_cgroup pointer from memmap
Date: Fri, 12 Sep 2008 00:00:37 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com> <20080911202249.df6026ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080911202249.df6026ae.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809120000.37901.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 21:22, KAMEZAWA Hiroyuki wrote:
> Remove page_cgroup pointer from struct page.
>
> This patch removes page_cgroup pointer from struct page and make it be able
> to get from pfn. Then, relationship of them is
>
> Before this:
>   pfn <-> struct page <-> struct page_cgroup.
> After this:
>   struct page <-> pfn -> struct page_cgroup -> struct page.

So...

pfn -> *hash* -> struct page_cgroup, right?

While I don't think there is anything wrong with the approach, I
don't understand exactly where you guys are hoping to end up with
this?

I thought everyone was happy with preallocated page_cgroups because
of their good performance and simplicity, but this seems to be
going the other way again.

I'd worry that the hash and lookaside buffers and everything makes
performance more fragile, adds code and data and icache to fastpaths.
