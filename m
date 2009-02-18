Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZBRJPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZBRJPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZBRJPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:15:25 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:52110 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZBRJPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:15:24 -0500
MIME-Version: 1.0
In-Reply-To: <200902181528.29697.rusty@rustcorp.com.au>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
Date: Wed, 18 Feb 2009 10:15:21 +0100
Message-ID: <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 05:58, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tuesday 17 February 2009 22:23:25 Kay Sievers wrote:
>> Monolithic versus modular kernels usually
>> make about 2+ seconds difference on a recent laptop.
>
> Thanks for the fact injection.  How about a megamodule then?

Sounds interesting. The ability to load multiple modules with a single
call may help, if such a call could be handled faster than individual
calls. Modprobe's modules added by dependencies of the requested
module, or modprobe -a could probably use such a facility.

Or do you think, the time the kernel needs to be locked can be
minimized somehow, so we get more parallelism and less serialization?

The current load_module() wraps ~400 lines of pretty heavy code in
stop_machine(), if we could possibly make that window smaller, so that
multiple instances could prepare some of the work in parallel, and
only a fraction of the current work would need to be serialized?

If that could be improved for the common distro case of running ~90
modprobe calls on bootup, many of them running in parallel, linking
~100 modules in, all in a time-frame of ~2-3 seconds -- that maybe
would attack the real "problem"?

Thanks,
Kay
