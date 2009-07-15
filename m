Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZGOPuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZGOPuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZGOPuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:50:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37383
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755248AbZGOPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:50:08 -0400
Date: Wed, 15 Jul 2009 08:50:12 -0700 (PDT)
Message-Id: <20090715.085012.223420354.davem@davemloft.net>
To: serue@us.ibm.com
Cc: shemminger@vyatta.com, containers@lists.osdl.org, sachinp@in.ibm.com,
       netdev@vger.kernel.org, matthltc@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] veth: don't free priv->status until
 dev->destructor (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090626162418.GA24828@us.ibm.com>
References: <20090626162418.GA24828@us.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Serge E. Hallyn" <serue@us.ibm.com>
Date: Fri, 26 Jun 2009 11:24:18 -0500

> I haven't been able to reproduce the original oops though (been
> trying to cat the stats sysfs files while rmmoding veth, to no
> avail, and haven't found an original bug report or testcase), so
> can't verify whether this patch prevents the original oops.

If you 'cat' it you're unlikely to trigger the oops.

You have to hold the sysfs files open, and then elsewhere do the
rmmod, wait, and then continue with some access to those open sysfs
file descriptors (f.e. do some reads).

I'd also need this patch to be against current sources as they'll
never apply since I did the revert quite some time ago.

Thanks.
