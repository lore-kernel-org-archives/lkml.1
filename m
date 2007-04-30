Return-Path: <linux-kernel-owner+w=401wt.eu-S1946655AbXD3TEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946655AbXD3TEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946654AbXD3TEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:04:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:13853 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946655AbXD3TEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W9Col58tOF+RawNn5rAZnoTTi/QaR1AIC5tn6G5BXYJGS/g7Nf7BRBDtJZ3qXJDgiECSlZBJeqROyJJPw8+F70cyxqtYp2swuYDYX6nej0/3OIj/kLJJ8XCS1TNxrG4gM4bXggi60OtuwFsgKWfhWvPv0DY5Tn3Ns16sc85doDE=
Message-ID: <a781481a0704301204i247a5123r1e6146c99b2e467e@mail.gmail.com>
Date: Tue, 1 May 2007 00:34:10 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same time?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070430182135.0fae7b89@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
	 <20070430001311.84d0291f.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>
	 <20070430100225.353e3030.akpm@linux-foundation.org>
	 <20070430182135.0fae7b89@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> i2o/device.c should be GFP_KERNEL as far as I can tell. It was meant to
> be that way and the callers appear to all be calling it in sleep capable
> contexts.
>
> aic7xxx_old.c should probably be GFP_KERNEL as ->slave_alloc methods
> appear to be able to sleep (although some drivers use GFP_ATOMIC here and
> some GFP_KERNEL).

Yes, none of the above appear to be atomic contexts. GFP_KERNEL in
that case would've been a bug. If they were atomic contexts, someone
somewhere would've been seeing a lot of "BUG: sleeping function called
from invalid context" messages and would've probably brought it to
lkml's notice already ;-) So the GFP_ATOMIC seems to be redundant
thing here in both cases.
