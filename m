Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZBWQmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZBWQmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZBWQmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:42:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:13163 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZBWQmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:42:31 -0500
MIME-Version: 1.0
In-Reply-To: <200902202202.13994.rusty@rustcorp.com.au>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <ac3eb2510902191359o3e32c424h830e78cd0ace446a@mail.gmail.com>
	 <200902201128.55959.rusty@rustcorp.com.au>
	 <200902202202.13994.rusty@rustcorp.com.au>
Date: Mon, 23 Feb 2009 17:42:28 +0100
Message-ID: <ac3eb2510902230842n278503a7w33d5ac2e622ec711@mail.gmail.com>
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

On Fri, Feb 20, 2009 at 12:32, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Friday 20 February 2009 11:28:55 Rusty Russell wrote:
>> +     /* Unlink carefully: kallsyms could be walking list. */
>> +     __list_del(&mod->list);
>> +     synchronize_sched();
>
> That should be list_del_rcu() of course.

Rusty,
are you taking care, that this patch gets merged somewhere, and shows
up in -next?

I still get a ~10% improvement without the mutex, and traces show some
parallelism from different modprobe processes. Any idea how to safely
minimize the time we need to hold it?

Thanks,
Kay
