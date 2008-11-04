Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYKDGQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYKDGQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYKDGPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:15:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:33434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYKDGPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:15:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=b09A8wXRXPe8k/ZsH1vgjKVec60yXt2aO/orVTRVZH1ZpAvhUSM8LEdG7RCQ5FCao
	uWhIzHuojHmpfEz1qotgw==
MIME-Version: 1.0
In-Reply-To: <20081031115241.1399d605.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081031115057.6da3dafd.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081031115241.1399d605.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 3 Nov 2008 22:15:41 -0800
Message-ID: <6599ad830811032215j3ce5dcc1g6d0c3e9439a004d@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/5] memcg : force_empty to do move account
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, taka@valinux.co.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 6:52 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> This patch provides a function to move account information of a page between
> mem_cgroups and rewrite force_empty to make use of this.

One part of this that wasn't clear to me - if a cgroup has a lot of
unmapped pagecache sitting around but no tasks, and we try to rmdir
it, then all the pagecache gets moved to the parent too? Or just the
stray mapped pages?

> @@ -597,7 +709,7 @@ static int mem_cgroup_charge_common(stru
>        prefetchw(pc);
>
>        mem = memcg;
> -       ret = mem_cgroup_try_charge(mm, gfp_mask, &mem);
> +       ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);

Isn't this the same as the definition of mem_cgroup_try_charge()? So
you could leave it as-is?

Paul
