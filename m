Return-Path: <linux-kernel-owner+w=401wt.eu-S1763980AbYD2OxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763980AbYD2OxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYD2OxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:53:00 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:2289 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbYD2Ow7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZlSVbwrOg40HxkE9mUm2siMTCNedcxm1bvkzfnye/8Lp/0eBz+UQWEDBATHO/IsNWiohVNajDTbp8srO/i+wOo7jMwSfKJ/5UI5JyB/YwEGXIbXIr0IMHD3T/3yZL+hjdCwLCqNB+67qczK2UtzhR6y5267Qj1HU7kIXlzgPOE8=
Message-ID: <661de9470804290752w1dc0cfb3k72e81d828a45765e@mail.gmail.com>
Date: Tue, 29 Apr 2008 20:22:58 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: Page Faults slower in 2.6.25-rc9 than 2.6.23
Cc: "Ross Biro" <rossb@google.com>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0804291447040.5058@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d43160c70804290610t2135a271hd9b907529e89e74e@mail.gmail.com>
	 <Pine.LNX.4.64.0804291447040.5058@blonde.site>
X-Google-Sender-Auth: c6282ae0bfc8ba8b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 7:27 PM, Hugh Dickins <hugh@veritas.com> wrote:
> On Tue, 29 Apr 2008, Ross Biro wrote:
>  > I don't know if this has been noticed before.  I was benchmarking my
>  > page table relocation code and I noticed that on 2.6.25-rc9 page
>  > faults take 10% more time than on 2.6.22.  This is using lmbench
>  > running on an intel x86_64 system.  The good news is that the page
>  > table relocation code now only adds a 1.6% slow down to page faults.
>
>  Do you have CONFIG_CGROUP_MEM_RES_CTLR=y in 2.6.25?
>  That added about 20% to my lmbench "Page Fault" tests (with
>  adverse effect on several others e.g. the fork, exec, sh group).
>

Hmm.. strange.. I don't remember the overhead being so bad (I'll
relook at my old numbers). I'll try and git-bisect this one


>  Try the same kernel with boot option "cgroup_disable=memory",
>  that should recoup most (but not quite all) of the slowdown;
>  or rebuild with n to CGROUP_MEM_RES_CTLR.
>
>  But your "Mmap Latency" went up 425% ??
>

That's really way of the mark

>  Hugh
>

Balbir
