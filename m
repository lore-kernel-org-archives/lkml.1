Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZI2VA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZI2VA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZI2VA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:00:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbZI2VAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:00:25 -0400
Date: Tue, 29 Sep 2009 13:59:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, rolandd@cisco.com, cesarb@cesarb.net,
       dwalker@fifo99.com
Subject: Re: [PATCH] WARN_ONCE(): use bool for condition
Message-Id: <20090929135947.7ccc3d8c.akpm@linux-foundation.org>
In-Reply-To: <1254075912-17557-1-git-send-email-cesarb@cesarb.net>
References: <4ABFAB27.1040608@cesarb.net>
	<1254075912-17557-1-git-send-email-cesarb@cesarb.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 15:25:12 -0300
Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> Use the type bool for __ret_warn_once and __ret_warn_on, instead of int
> with a double negation. This matches the intent of the code better and
> should allow the compiler to generate better code, like in commit
> 70867453092297be9afb2249e712a1f960ec0a09. However, some versions of gcc
> seems to pessimize the code instead when the condition is not trivial.
> 
> Cc: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  arch/avr32/include/asm/bug.h    |    2 +-
>  arch/blackfin/include/asm/bug.h |    2 +-
>  arch/parisc/include/asm/bug.h   |    2 +-
>  arch/powerpc/include/asm/bug.h  |    2 +-
>  arch/s390/include/asm/bug.h     |    2 +-
>  arch/sh/include/asm/bug.h       |    4 ++--
>  include/asm-generic/bug.h       |   12 ++++++------

There's a small reject in include/asm-generic/bug.h against current
mainline, easily fixed.

It would be nice if we had some accurate numbers on the kernel size
reductions from this, please.  I assume that the patch is still of
benefit in 2.6.32-rc1(2?), but it's always good to confirm.


