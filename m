Return-Path: <linux-kernel-owner+w=401wt.eu-S1422982AbXDYXp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422982AbXDYXp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422987AbXDYXp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:45:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422982AbXDYXp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:45:27 -0400
Date: Wed, 25 Apr 2007 16:45:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: johnpol@2ka.mipt.ru, lkml <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: W1 printk format warning
Message-Id: <20070425164509.715ca5c9.akpm@linux-foundation.org>
In-Reply-To: <20070425162104.168c32b6.randy.dunlap@oracle.com>
References: <20070425162104.168c32b6.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 16:21:04 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> in 2.6.21-rc7-mm1.  Are you aware of this?
> 
> drivers/w1/w1.c:460: warning: too few arguments for format
> 
> 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
> 		&sl->dev.bus_id[0]);
> 

Yeah, that's because Dan's dev_dbg-check-dev_dbg-arguments.patch added
printk arg-checking to dev_dbg() and a bunch of bugs got exposed.  I fixed
a few of them.

Incidentally, there are at least four different drivers which privately do
things like:

#if !defined(DEBUG)
#undef dev_dbg
static inline int __attribute__ ((format (printf, 2, 3))) dev_dbg(
	const struct device *_dev, const char *fmt, ...) {return 0;}
#endif

which can all be removed with Dan's (good) patch in place.
