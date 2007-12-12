Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXLLRib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXLLRib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbXLLRiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:38:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbXLLRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:38:20 -0500
Date: Wed, 12 Dec 2007 09:38:19 -0800 (PST)
Message-Id: <20071212.093819.205755031.davem@davemloft.net>
To: gallatin@myri.com
Cc: joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <47601A73.5010804@myri.com>
References: <47601A73.5010804@myri.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Gallatin <gallatin@myri.com>
Date: Wed, 12 Dec 2007 12:29:23 -0500

> Is the netif_running() check even required?

No, it is not.

When a device is brought down, one of the first things
that happens is that we wait for all pending NAPI polls
to complete, then block any new polls from starting.
