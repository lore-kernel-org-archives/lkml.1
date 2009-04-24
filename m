Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbZDXRtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbZDXRtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZDXRtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:49:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbZDXRtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:49:11 -0400
Date: Fri, 24 Apr 2009 10:46:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
Message-Id: <20090424104651.7c751735.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0904240632240.16107@localhost.localdomain>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain>
	<49F0C817.8050407@caviumnetworks.com>
	<20090423165723.16c9f566.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0904240632240.16107@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 06:40:39 -0400 (EDT) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

>   so it would be a simple matter to define the bit set boolean in
> terms of hweight_long(), yes?  so what about, in bitops.h:
> 
>   static inline bool
>   exactly_one_bit_set(unsigned long w)
>   {
> 	return hweight_long(w) == 1;
>   }
> 
>   static inline bool
>   more_than_one_bit_set(unsigned long w)
>   {
> 	return hweight_long(w) > 1;
>   }
> 
> or something to that effect, *if* people think it's worth it.
> obviously, none of the above is strictly necessary, but it would make
> a lot of code semantically cleaner.
> 

Doing plain old

	if (hweight32(foo) == 1)

(say) at the call sites quite clearly expresses what the code is trying
to do.

> rday
> 
> p.s.  i notice that, even in a single header file like bitops.h, there
> is a mixture of both "inline" and "__inline__".  what's the
> recommended choice these days?

`inline'.  Or uninline the function ;)
