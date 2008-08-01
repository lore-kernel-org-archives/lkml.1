Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYHAUEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYHAUEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYHAUEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:04:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYHAUEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:04:31 -0400
Subject: Re: [PATCH] firmware: avoiding multiple replication for same
	firmware file
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1217570459.2902.1.camel@jaswinder.satnam>
References: <1217570459.2902.1.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 21:04:28 +0100
Message-Id: <1217621068.3454.501.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 11:30 +0530, Jaswinder Singh wrote:
> Now when request_firmware will be called it will check whether firmware
> is already allocated or not. If already allocated then it provide handle
> of old firmware handle and increase count of firmware.
> 
> release_firmware will decrease count of firmware, if count is one only then
> firmware will be release.

I like this. It means that when you have multiple similar devices, you
only need one copy of the firmware in memory for _all_ of them. Because
we've now made fw->data constant, we know it's safe to share them now.

I wonder if we should change the implementation of 'built-in firmware'
to use your new implementation -- just set the use count on the built-in
firmware to 1 when we start up, and then it should never go away.

Unless we're _really_ clever with linker tricks it would mean we'd have
an init function which takes the built-in stuff and builds it into the
linked list, but I think that might be worth the runtime simplification.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



