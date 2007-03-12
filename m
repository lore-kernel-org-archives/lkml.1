Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXCLWOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXCLWOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXCLWN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:13:59 -0400
Received: from ozlabs.org ([203.10.76.45]:36955 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738AbXCLWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:13:58 -0400
Subject: Re: [RFC PATCH 1/3] Add ability to keep track of callers of
	symbol_(get|put)
From: Rusty Russell <rusty@rustcorp.com.au>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0703120652100.19670@shell2.speakeasy.net>
References: <1173501095.26213.405.camel@localhost>
	 <20070311000938.80202418.akpm@linux-foundation.org>
	 <Pine.LNX.4.58.0703120652100.19670@shell2.speakeasy.net>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 09:13:00 +1100
Message-Id: <1173737580.10618.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

	Patch looks good, just one comment:

On Mon, 2007-03-12 at 07:07 -0700, Trent Piepho wrote:
> +       use = already_uses(a, b);
> +       if (!use) {
> +           printk(KERN_ERR "module %s trying to un-use a module, %s, which "
> +                  "it is not using", a->name, b->name);
> +            return 0;
> +       }

s/return 0/BUG()/.  This is potentially quite a nasty bug.

Thanks!
Rusty.

