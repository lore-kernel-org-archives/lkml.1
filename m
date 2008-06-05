Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbYFEQGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbYFEQGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYFEQGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:06:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYFEQGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:06:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=At+KFG9+sA4wQYIKcfenc9My4hvwHeD5sE/umM5tOxZ5SV6T+Jd1XIJ5cagntrmhc
	pOBSp/BgIobma/p32hPGQ==
Message-ID: <4ca0a85e0806050905j6cf33f3dx9143333aa0a8b6e7@mail.gmail.com>
Date: Thu, 5 Jun 2008 12:05:51 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH 3/5] pagemap: Make pagemap_read enforce reading in multiples of 8
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1212681822.3953.162.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ca0a85e0806050806r38de18dft8927e093a8e47abd@mail.gmail.com>
	 <1212681822.3953.162.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 12:03 PM, Matt Mackall <mpm@selenic.com> wrote:
>
> On Thu, 2008-06-05 at 11:06 -0400, Thomas Tuttle wrote:
>> Since kpagecount and kpageflags require reads in multiples of 8, and
>> it simplifies add_to_pagemap significantly, I added the same
>> requirement to /proc/pid/pagemap.
>
> I'm generally fine with this. Another approach that's perhaps more
> friendly is when someone tries to do a 24-byte read, do a 16-byte read,
> leaving the file pointer aligned. Not sure if that's completely kosher
> though.

This doesn't require that they read exactly 8 bytes, just that they
read some multiple of 8 bytes.  (They can read 8, 16, 24, etc..., just
not something like 12.)

--ttuttle
