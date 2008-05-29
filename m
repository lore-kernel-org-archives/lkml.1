Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYE2JMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYE2JMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYE2JMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 05:12:08 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:29769
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbYE2JMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 05:12:07 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2008 05:12:07 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4BACMOPkh8qN9Z/2dsb2JhbAAIr2A
X-IronPort-AV: E=Sophos;i="4.27,560,1204470000"; 
   d="scan'208";a="335742160"
Subject: async userspace gpio api [WAS: Re: PXA board chips control]
From: Ben Nizette <squidgit@iinet.net.au>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 19:02:14 +1000
Message-Id: <1212051734.4780.26.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[bringing lkml in on this]

On Wed, 2008-05-28 at 00:37 -0700, David Brownell wrote:
> No, very different.  Those are more like device nodes, which
> get added and removed as part of routine operations (like
> physical connect/disconnect).
> 
> 
> > I would have thought -EINVAL was sufficient, no?
> 
> Surprising to see a read return a value at one moment, then
> fail with EINVAL the next, then return a value later ...
> no, there should be some distinguished value for "that mode
> would be meaningless right now".

Actually my thought (though I didn't come close to expressing it just
now) was to have an async behaviour control file (taking irq/poll/none
options) which wouldn't be writable while the gpio was an output.

The more I think about it though, the more I'm inclined to just allow
the user to select any of those options on any gpio regardless of
direction and trust them to know whether that makes sense for the
underlying hardware (sanity checking as needed).

	--Ben.
