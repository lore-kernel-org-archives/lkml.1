Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYIXCKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYIXCKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 22:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIXCKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 22:10:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:63591 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYIXCJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 22:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pa0MHzBFDFTBMsxaM2WS+aw2eZP1SQ5mE4sVLAVgWIxPpS8DySaq0w1VTL2ukxGoYs
         KFeeNWNP99BKJ6RMWvGxnk3btWZEdFpDnuGQxSa2LtfRl/yOwypc6BQHKmhUT5G0gk4S
         jtpbOZdYsFFEok1bMqWr31sitJimyVeTgelW0=
Message-ID: <661de9470809231909h24ca4a39k470e322f2c1019dc@mail.gmail.com>
Date: Wed, 24 Sep 2008 07:39:58 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 9/13] memcg: lookup page cgroup (and remove pointer from struct page)
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080924084839.f5901719.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080924084839.f5901719.kamezawa.hiroyu@jp.fujitsu.com>
X-Google-Sender-Auth: fa3efc388c538797
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 5:18 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> After sleeping all day, I changed my mind and decided to drop this.
> It seems no one like this.
>

I've not yet looked at the patch in detail, I just got back from a long travel.

> I'll add FLATMEM/DISCONTIGMEM/SPARSEMEM support directly.
> I already have wasted a month on this not-interesting work and want to fix
> this soon.
>

Let's look at the basic requirement, make memory resource controller
not suck with 32 bit systems. I have been thinking of about removing
page_cgroup from struct page only for 32 bit systems (use radix tree),
32 bit systems can have a maximum of 64GB if PAE is enabled, I suspect
radix tree should work there and let the 64 bit systems work as is. If
performance is an issue, I would recommend the 32 bit folks upgrade to
64 bit :) Can we build consensus around this approach?

> I'm glad if people help me to test FLATMEM/DISCONTIGMEM/SPARSEMEM because
> there are various kinds of memory map. I have only x86-64 box.

I can help test your patches on powerpc 64 bit and find a 32 bit
system to test it as well. What do you think about the points above?

Balbir
