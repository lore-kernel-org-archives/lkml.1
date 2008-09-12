Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYILTd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYILTd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYILTdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:33:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14132 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbYILTdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:33:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=g/Yh8NxMO7NED99mUnyl/DOpNIxNI4U2fnGw0B1C4/fMldbYdjbRnSdGBbIxhd+1p
	uPXrLhFtIoytdEO1ANe6w==
Message-ID: <6599ad830809121233l6c58f879l6a483f368fc09aa5@mail.gmail.com>
Date: Fri, 12 Sep 2008 12:33:37 -0700
From: "Paul Menage" <menage@google.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
Cc: "Li Zefan" <lizf@cn.fujitsu.com>, "Lai Jiangshan" <laijs@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080912155804.GB3610@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AA684B.7000704@cn.fujitsu.com>
	 <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com>
	 <48C72E7C.8080302@cn.fujitsu.com> <20080910050112.GA2897@kroah.com>
	 <6599ad830809092231h90712a6mc95b81229d64d6bc@mail.gmail.com>
	 <20080910061717.GA6301@kroah.com> <48C76875.50007@cn.fujitsu.com>
	 <20080910062951.GA6779@kroah.com>
	 <6599ad830809100803w1bbbb331qa6741b9f42204dcf@mail.gmail.com>
	 <20080912155804.GB3610@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 8:58 AM, Greg KH <greg@kroah.com> wrote:
>> If you're opposed to the addition of kref_put_and_write_lock() then
>> yes, I'll replace kref with a custom refcount.
>
> It just seems messy, but if you want to try it, I'll be glad to look at
> the code.  Oh wait, was that the patch that you sent out last time?

Yes - that patch replaced kref with a plain refcount. We weren't
really using kref as anything other than an atomic_dec_and_test()
wrapper anyway.

Paul
