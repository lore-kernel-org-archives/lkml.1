Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYAKDnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYAKDnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYAKDnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:43:15 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:29885 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753420AbYAKDnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:43:14 -0500
Date: Fri, 11 Jan 2008 12:42:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roel Kluin <12o3l@tiscali.nl>, Al Viro <viro@ZenIV.linux.org.uk>,
       Mathieu Segaud <mathieu.segaud@regala.cx>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Message-ID: <20080111034240.GA29861@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roel Kluin <12o3l@tiscali.nl>, Al Viro <viro@ZenIV.linux.org.uk>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	Richard Knutsson <ricknu-0@student.ltu.se>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int> <20080105051817.GD27894@ZenIV.linux.org.uk> <4786883E.30604@tiscali.nl> <20080111030945.27954.qmail@cdy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111030945.27954.qmail@cdy.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 04:09:45AM +0100, Peter Stuge wrote:
> On Thu, Jan 10, 2008 at 10:03:58PM +0100, Roel Kluin wrote:
> > -#define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
> > +#define DEBUG(x, args...)	printk("%s: ", __func__, x, ##args)
> 
> Can this really be expected to work when x contains conversions?
> 
> How about:
> 
> #define DEBUG(x, args...) printk("%s: " x, __func__, ##args)
> 
How about throwing out hand-rolled debug printk wrappers for the
brain-damage they are and using the ones the kernel provides instead?

dev_dbg() and pr_debug() both manage to get these semantics right, and
you can even bury the #define DEBUG underneath some Kconfig silliness if
you're the kind of person that leans that way.

Maybe we can just amend checkpatch to delete a patch out of protest if it
introduces printk() wrappers..
