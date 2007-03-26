Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbXCZKIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbXCZKIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbXCZKIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:08:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51314 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbXCZKIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:08:35 -0400
Date: Mon, 26 Mar 2007 02:08:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
Message-Id: <20070326020823.8630bb07.akpm@linux-foundation.org>
In-Reply-To: <E1HVlZH-00018f-00@dorka.pomaz.szeredi.hu>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	<20070325153508.10922ebd.akpm@linux-foundation.org>
	<E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu>
	<20070326010124.b4513ce2.akpm@linux-foundation.org>
	<E1HVlZH-00018f-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 11:32:47 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Stopping writers which have idle queues is completely unproductive,
> and that is basically what the current algorithm does.

This is because the kernel permits all of its allotment of dirty+writeback
pages to be dirty+writeback against a single device.

A good way of solving the one-device-starves-another-one problem is to
dynamically adjust the per-device dirty+writeback levels so that (for
example) if two devices are being written to, each gets 50% of the
allotment.

I started working on that but got derailed by the usual blah.  I don't
think either of the proposed fixes took that approach, actually.

