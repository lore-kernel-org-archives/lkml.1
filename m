Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZBSLlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZBSLlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZBSLlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:41:05 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:42894 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbZBSLlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:41:04 -0500
MIME-Version: 1.0
In-Reply-To: <200902192145.10616.rusty@rustcorp.com.au>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <200902182227.14686.rusty@rustcorp.com.au>
	 <ac3eb2510902180557p3b65fad5i933eed9d3e3d0b3b@mail.gmail.com>
	 <200902192145.10616.rusty@rustcorp.com.au>
Date: Thu, 19 Feb 2009 12:41:02 +0100
Message-ID: <ac3eb2510902190341y7eb4e938nf5f28ac094a68818@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 12:15, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thursday 19 February 2009 00:27:58 Kay Sievers wrote:
>> some modules wait for 200-500 milliseconds to
>> get the lock released, some larger modules spend 50 milliseconds in
>> load_module(), many of them around 20 milliseconds.
>
> OK, this is an untested hack (don't try unloading modules, not sure symbol
> resolution isn't racy now I've killed the lock).  Does it change the numbers?

That changes it dramatically. The numbers from the sycall until the
linked-in module are now down to 15-25 milliseconds, and for a few
large modules 50-100.

(One crazy exception is ipv6, which takes 620 milliseconds to link, no
idea what it needs to do.)

I'll compare a few bootup times with and without the patch, and come
back later today with the real numbers.

Thanks a lot,
Kay
