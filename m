Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZBYSNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZBYSNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZBYSM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:12:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:22455 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZBYSMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:12:55 -0500
MIME-Version: 1.0
In-Reply-To: <200902251733.57069.rusty@rustcorp.com.au>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <200902202202.13994.rusty@rustcorp.com.au>
	 <ac3eb2510902230842n278503a7w33d5ac2e622ec711@mail.gmail.com>
	 <200902251733.57069.rusty@rustcorp.com.au>
Date: Wed, 25 Feb 2009 19:12:52 +0100
Message-ID: <ac3eb2510902251012t4d1a8c88m2c1eb2a6c761fee@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 08:03, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tuesday 24 February 2009 03:12:28 Kay Sievers wrote:
>> Rusty,
>> are you taking care, that this patch gets merged somewhere, and shows
>> up in -next?
>
> Yep, already done.

Nice. Thanks!

>> I still get a ~10% improvement without the mutex, and traces show some
>> parallelism from different modprobe processes. Any idea how to safely
>> minimize the time we need to hold it?
>
> OK, let's do that then.
>
> <hack hack>
>
> Here's a backported version which you should be able to simply apply; it'll
> be good to check that we still win...

It's a little bit faster, and the traces show a bit less serialization
and more overlapping code execution.

The difference is very small though, and hard to notice -- loading of
all the 39 modules triggered by a udev coldplug run finishes after
0.23 seconds. After calling init, the last of these modules goes
"live" after 0.26 seconds. Most of the time the modules need is spent
in simplify_symbols().

Thanks,
Kay
