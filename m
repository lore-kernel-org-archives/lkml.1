Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbYFZXBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbYFZXBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 19:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYFZXBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 19:01:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYFZXBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 19:01:37 -0400
Date: Thu, 26 Jun 2008 15:59:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: righi.andrea@gmail.com
Cc: balbir@linux.vnet.ibm.com, menage@google.com, chlunde@ping.uio.no,
       axboe@kernel.dk, matt@bluehost.com, roberto@unbit.it,
       randy.dunlap@oracle.com, dpshah@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i/o bandwidth controller infrastructure
Message-Id: <20080626155948.34f30751.akpm@linux-foundation.org>
In-Reply-To: <486419FE.6070600@gmail.com>
References: <1213956335-29866-3-git-send-email-righi.andrea@gmail.com>
	<20080625172900.6cfe79cf.akpm@linux-foundation.org>
	<486419FE.6070600@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 00:36:46 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> > Does all this code treat /dev/sda1 as a separate device from /dev/sda2?
> >  If so, that would be broken.
> 
> Yes, all the partitions are treated as separate devices with
> (potentially) different limiting rules, but I don't understand why it
> would be broken... dev_t has both minor and major numbers, so it would
> be possible to select single partitions as well.

Well it's functionally broken, isn't it?  A physical disk has a fixed
IO bandwidth and when the administrator wants to partition that
bandwidth amongst control groups he will need to consider the entire
device when doing so?

I mean, the whole point of this feature and of control groups as a
whole is isolation.  But /dev/sda1 and /dev/sda2 are very much _not_
isolated.  Whereas /dev/sda and /dev/sdb are (to a large degree)
isolated.

