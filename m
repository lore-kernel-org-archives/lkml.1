Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYACSkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYACSkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbYACSjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:39:53 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:48354 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYACSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:39:52 -0500
Date: Thu, 03 Jan 2008 13:39:50 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
In-reply-to: <adak5mqu5i8.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Message-id: <1199385590.7561.11.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <adak5mqu5i8.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 10:29 -0800, Roland Dreier wrote:
> Linus, please pull from
> 
>     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
> 
> This tree is also available from kernel.org mirrors at:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
> 
> This will pull one fix for an oops caused by reloading the ib_srp module:
> 
> David Dillow (1):
>       IB/srp: Fix list corruption/oops on module reload

If we've got time before 2.6.24 final, I'd wait on this a bit.
ib_srp:srp_remove_work() has them reversed as well, and I'm currently
tracking down why it oopses when the srp_remove_host() happens before
the scsi_remove_host(), which is the documented call sequence.

This "fixes" the oops I see on unload, but I'm sure it is a correct fix.

