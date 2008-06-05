Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYFETJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYFETJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYFETJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:09:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54211 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYFETJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:09:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PoCFuOF/9JcnKqEZuQQ0HksQOVCN93Y5iTYPXlHm450IpOLxg3MAMyJu0GIKbPXoy
	9nf8ZzCuBKsI3ZjJY92/Q==
Message-ID: <4ca0a85e0806051209u68f60b40wfc77a3a895280821@mail.gmail.com>
Date: Thu, 5 Jun 2008 15:09:35 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] pagemap: Modify add_to_pagemap to use copy_to_user instead of put_user.
In-Reply-To: <1212692763.3953.196.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
	 <20080605120221.c09dc274.akpm@linux-foundation.org>
	 <1212692763.3953.196.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 3:06 PM, Matt Mackall <mpm@selenic.com> wrote:
> On Thu, 2008-06-05 at 12:02 -0700, Andrew Morton wrote:
>> On Thu, 5 Jun 2008 11:04:21 -0400
>> "Thomas Tuttle" <ttuttle@google.com> wrote:
>>
>> > While fiddling with pagemap, I discovered a bug in add_to_pagemap.
>>
>> so...  afaict we have some fairly significant problems in here and a
>> version 2 of the patchset is in order?
>>
>> If so, when preparing that patchset please do have a think about which
>> of the fixes you believe should be backported into 2.6.25.x and prepare
>> the patches so that those fixes come first, to ease that backporting.
>
> For 2.6.25.x, we should probably just add a cast to the put_user dest.
> Thomas?

Okay, I've written a new patchset.  Patch 1/4 simply changes things to
use u64 pointers.  It's not that big a patch, but if you're really
uncomfortable backporting it, just stick a (u64*) before pm->out in
2.6.25.x.

Other than that, I don't believe any of the other fixes need to be
backported.  They just tweak a couple of things (error code on
unaligned reads, and which values show up in kpagecount), but don't
repair any particularly broken bits.

Please take a look at the new patchset and see if it fixes things to
your satisfaction.

--ttuttle
