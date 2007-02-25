Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbXBYA4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbXBYA4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbXBYA4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:56:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57205
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932887AbXBYA4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:56:32 -0500
Date: Sat, 24 Feb 2007 16:56:31 -0800 (PST)
Message-Id: <20070224.165631.78711967.davem@davemloft.net>
To: wli@holomorphy.com
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070224225631.GA9222@holomorphy.com>
References: <20070224042444.GU21484@holomorphy.com>
	<20070224050937.GA16601@wotan.suse.de>
	<20070224225631.GA9222@holomorphy.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Lee Irwin III <wli@holomorphy.com>
Date: Sat, 24 Feb 2007 14:56:31 -0800

> just do it on a per-directory basis so you don't intermix children
> of different parents in some boot-time -allocated global trainwreck
> and you're home free.  Benchmarking is probably needed to gauge
> which performs best.

The original dentry implementation in the kernel did things
per-directory and it sucked.

The problem you run into is that you end up with recursive algorithms
all over the place, which chew up and overflow the kernel stack.

So it would be a regression to go to a per-directory type
lookup data structure for dentries.
