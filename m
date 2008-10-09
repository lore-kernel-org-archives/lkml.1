Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYJIAmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYJIAmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbYJIAm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:42:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32848
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755845AbYJIAm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:42:26 -0400
Date: Wed, 08 Oct 2008 17:42:02 -0700 (PDT)
Message-Id: <20081008.174202.160320028.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2/8 2.6.28] cxgb3 - Allocate multiqueues at init time
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081009003402.13315.18192.stgit@speedy5>
References: <20081009003402.13315.18192.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 08 Oct 2008 17:34:02 -0700

> Allocate a queue set per core, up to the maximum of available qsets.
> Share the queue sets on multi port adapters.
> Rename MSI-X interrupt vectors ethX-N, N being the queue set number.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied, but...

This "num processors" logic and policy belongs in some generic place.
Perhaps "num_possible_cpus()" is more appropriate, who knows right?

Otherwise every stinking driver is going to implement this in
their own way and use their own policy, and from a user experience
perspective that totally sucks.
