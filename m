Return-Path: <linux-kernel-owner+w=401wt.eu-S934614AbYBNBAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934614AbYBNBAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934254AbYBNA7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:59:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:41331 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbYBNA7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:59:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qHhjoka6pwkxolaA5MOskDTEgNGzqV885s81QfZeUOIkLRzlzrm3D4Jxw7g6CDMwzB81+Yqmq6dcUGpFUYIcYzZj7Fyjf7SMOu6SrgtT+quHt5ORwJqUe58T50f/6CZaUu28zsrSIdpb/rGkAgpdNBISOJAO+g6j8+iqcB7x91I=
Message-ID: <12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
Date: Wed, 13 Feb 2008 16:59:30 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Cc: mingo@elte.hu, rdreier@cisco.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080213.050340.64342037.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adazlu5tlve.fsf@cisco.com>
	 <20080212.230156.33759433.davem@davemloft.net>
	 <20080213125725.GC6344@elte.hu>
	 <20080213.050340.64342037.davem@davemloft.net>
X-Google-Sender-Auth: 0b059e25c93b92a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is legal to access per-cpu data as early as you like,
> it just evaluates to the static copy in the per-cpu section
> of the kernel image until the per-cpu areas are setup.

On ia64 per-cpu variables are mapped into the top 64K
of the address space.  Accessing them before the
resources to handle the access to that virtual address
have been set up would cause problems.

-Tony
