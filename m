Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbYBNDdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbYBNDdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 22:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYBNDdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 22:33:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:3039 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYBNDdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 22:33:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bt7ElE+C/yh5/pPo9R6FsBdEoejb2AacEhEwq4fHpUMVwmy8PO2oLhFwa9YjgCUi4L6mXy5JttKYh8vvjhdaaN3USVwJeQdtiEunPmydc4xBl7MdkzwnxCLeJ9XR8cfYHzn/CFNW6gX2eohm4MpKWiNiuK2bzxVtDcqTqClMwPY=
Message-ID: <12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com>
Date: Wed, 13 Feb 2008 19:33:42 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Cc: mingo@elte.hu, rdreier@cisco.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080213.170452.68851396.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080213125725.GC6344@elte.hu>
	 <20080213.050340.64342037.davem@davemloft.net>
	 <12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
	 <20080213.170452.68851396.davem@davemloft.net>
X-Google-Sender-Auth: d0cd6aa2b2541593
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's right.  I thought you guys had something that would handle that
> early on, but looking at how the trick works in the vmlinux.lds.S ia64
> uses that isn't the case.

We try to get things set up pertty early ... but I agree this is
fragile.  Adding code to printk() to not provide a timestamp
before some safe point in boot is a workaround to the
current problem.  But it may come back to haunt us if
other per-cpu data is added that needs to be accessed
early during boot.

There are some changes going on at the moment on how
we allocate the space for the per-cpu area.  It is likely that
for a non-boot cpu we might be able to get everything that
we need for per-cpu access to work done in head.S before
we can get to any C code.  Boot cpu may be harder unless
we statically allocate space for its per-cpu area in
vmlinux.lds.S

I'll take a closer look at what is needed tomorrow.

-Tony
