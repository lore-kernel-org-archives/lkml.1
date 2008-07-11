Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbYGKWvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbYGKWvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGKWvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:51:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:56055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYGKWvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:51:05 -0400
Date: Fri, 11 Jul 2008 15:51:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 13/17] Use WARN() in drivers/base/
Message-ID: <20080711155105.70eb496a@infradead.org>
In-Reply-To: <20080711151110.ab2b5401.akpm@linux-foundation.org>
References: <20080708093800.274504ba@infradead.org>
	<20080708095307.6423cb6f@infradead.org>
	<20080711122011.7ddf42ef.akpm@linux-foundation.org>
	<20080711135409.6638498d@infradead.org>
	<20080711151110.ab2b5401.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 15:11:10 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> I don't suppose there's any way of tricking the preprocessor into
> supporting
> 
> 	WARN_ON(foo == 42);
> 
> as well as
> 
> 	WARN_ON(foo == 42, "bite me!");
> 

after reading preprocessor docs from gcc and trying some things:
We can do this. It comes at a price: the price is a blank line in the
WARN trace for the "no printk comments" case, and we lose the ability
to override the printk level. (which you can argue is a feature by just
setting it to KERN_WARNING).

(and some interesting but otherwise non-harmful preprocessor stuff in
headers)

Is this is price worth paying to not have a second macro?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
