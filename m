Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbZFVO0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbZFVO0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZFVO0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:26:47 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47792 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbZFVO0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:26:47 -0400
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sudeep K N <sudeepholla.maillist@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
In-Reply-To: <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
	 <20090619134446.GI24573@n2100.arm.linux.org.uk>
	 <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 22 Jun 2009 15:26:29 +0100
Message-Id: <1245680789.15580.85.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 14:26:30.0416 (UTC) FILETIME=[6F682900:01C9F345]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 19:43 +0530, Sudeep K N wrote:
> Thanks for the suggestion.
> With the logs it is clear that crash is in the userspace.
> I am getting one of the 2 logs(below) randomly.

This sounds familiar: SMP -> writealloc cache policy (could be forced by
hardware) -> cache corruption in user space with ext2.

Does you driver use the DMA API? If not, does your eMMC driver flush the
cache (in case you hit one of the long-standing problems with PIO
drivers).

It's worth trying this hack:

http://article.gmane.org/gmane.linux.ports.arm.kernel/51556

-- 
Catalin

