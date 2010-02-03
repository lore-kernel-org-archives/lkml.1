Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab0BCBtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:49:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932149Ab0BCBtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:49:45 -0500
Date: Tue, 2 Feb 2010 17:48:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Message-Id: <20100202174853.67eeccdd.akpm@linux-foundation.org>
In-Reply-To: <201002030244.23989.rjw@sisk.pl>
References: <alpine.LFD.2.00.1001221841490.2266@localhost>
	<201002011630.04281.rjw@sisk.pl>
	<20100201075706.69b1d2c0.akpm@linux-foundation.org>
	<201002030244.23989.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 02:44:23 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> +static inline gfp_t clear_gfp_allowed_mask(gfp_t mask)
> +{
> +	gfp_t ret = gfp_allowed_mask;
> +	gfp_allowed_mask &= ~mask;
> +	return ret;
> +}

Fair enuf.

Of course, this is all horridly racy/buggy without locking.  Would I be
correct in hoping that all the callers happen when the system is in
everyone-is-frozen mode?

Perhaps we should add some documentation (or even an assertion) to
prevent someone from using these interfaces from within normal code.

