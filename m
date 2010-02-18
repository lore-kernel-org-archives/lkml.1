Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0BRXXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:23:44 -0500
Received: from mail.perches.com ([173.55.12.10]:1101 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab0BRXXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:23:41 -0500
Subject: Re: printk_ratelimited() not compiling
From: Joe Perches <joe@perches.com>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1266532567.3201.97.camel@localhost.localdomain>
References: <1266531013.3201.86.camel@localhost.localdomain>
	 <1266532567.3201.97.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 15:23:39 -0800
Message-ID: <1266535419.8446.320.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 14:36 -0800, john stultz wrote: 
> > Am I missing something obvious, or did something get broken after this went in?
> Ok. Solved it. I needed to #include <linux/ratelimit.h> in the file I
> was adding the printk_ratelimited usage in, rather then where
> printk_ratelimited is defined.
> 
> Maybe would it be better to move the printk_ratelimited definitions into
> ratelimit.h so this would be more obvious?

That's one option.

Probably the only places I tried it had an
#include <linux/net.h> somewhere which does an
#include <linux/ratelimit.h>

Personally, I think it'd be better to put
#include <linux/ratelimit.h> back in kernel.h
Commit 3fff4c42bd0a89869a0eb1e7874cc06ffa4aa0f5 removed it.


