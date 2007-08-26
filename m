Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXHZRD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXHZRD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 13:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXHZRDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 13:03:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:12878 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbXHZRDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 13:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GMiqpRW3C9qQyZ4l7hNI/MIVP7wF8kMhp+CoyVp7MgPcRRPIVf3AROvNmxqOZufa4jj7yAv74oaI6SJkKqzRQmrpeJgOoCbcqhXb9X0EM7tI2aoSvp1OmaPx9xOPr62o5l1ZIwYvPReAE9m8ghjHzUddaEPsae4vzPhI15NroP8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Fred Tyler" <fredty8@gmail.com>
Subject: Re: Slow, persistent memory leak in 2.6.20
Date: Sun, 26 Aug 2007 18:03:12 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com> <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr> <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com>
In-Reply-To: <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708261803.12717.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 August 2007 17:16, Fred Tyler wrote:
> So, I guess it worked? (I don't know what was supposed to happen, but
> memory usage dropped significantly when I did this.)

If you can reclaim "leaked" memory this way, it means that
you found a bug where cached data is incorrectly kept
in RAM in preference of other data.
(I'm assuming that you do have real problems after some time
of "leaking" memory - you mention that you get swap storms
and eventually machine is dead.)

> However, I'm not sure this staging machine has been up long enough or
> doing enough to exhibit the problem. I can try this on my production
> servers (the ones I provided graphs for) late tonight, but how safe is
> running this command? Does it permanently disable file caching? Do I

Yes, it's safe to do, anytime.

It's just a command to kernel to drop as much of currently
accumulated filesystem cache as it can. It is strictly
a debugging/benchmarking aid.

If you end up needing to do it once in a while to keep your machine
alive, something is definitely wrong.
--
vda
