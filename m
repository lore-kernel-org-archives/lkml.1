Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYCQG7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYCQG7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYCQG7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:59:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57977 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYCQG7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:59:43 -0400
Date: Mon, 17 Mar 2008 08:02:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Message-ID: <20080317070208.GC27015@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015825.0C0171B41E0@basil.firstfloor.org> <86802c440803161919h20ed9f78k6e3798ef56668638@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803161919h20ed9f78k6e3798ef56668638@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> node_boot_start is not page aligned?

It is, but it is not necessarily GB aligned and without this
change sometimes alloc_bootmem when requesting GB alignment
doesn't return GB aligned memory. This was a nasty problem
that took some time to track down.

-Andi
