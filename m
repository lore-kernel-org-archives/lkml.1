Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbXCZNaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbXCZNaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 09:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXCZNaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 09:30:35 -0400
Received: from amsfep15-int.chello.nl ([62.179.120.10]:60763 "EHLO
	amsfep15-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXCZNae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 09:30:34 -0400
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, dgc@sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070326020823.8630bb07.akpm@linux-foundation.org>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	 <20070325153508.10922ebd.akpm@linux-foundation.org>
	 <E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu>
	 <20070326010124.b4513ce2.akpm@linux-foundation.org>
	 <E1HVlZH-00018f-00@dorka.pomaz.szeredi.hu>
	 <20070326020823.8630bb07.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 15:30:27 +0200
Message-Id: <1174915828.6792.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 02:08 -0800, Andrew Morton wrote:
> On Mon, 26 Mar 2007 11:32:47 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Stopping writers which have idle queues is completely unproductive,
> > and that is basically what the current algorithm does.
> 
> This is because the kernel permits all of its allotment of dirty+writeback
> pages to be dirty+writeback against a single device.
> 
> A good way of solving the one-device-starves-another-one problem is to
> dynamically adjust the per-device dirty+writeback levels so that (for
> example) if two devices are being written to, each gets 50% of the
> allotment.

This is exactly what happens with my patch if both devices write at the
same speed. (Or at least, that is what is supposed to happen ;-)

