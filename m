Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZEMFjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZEMFjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZEMFjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:39:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbZEMFi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:38:59 -0400
Date: Tue, 12 May 2009 22:35:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jens.axboe@oracle.com, Max Kellermann <max@duempel.org>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] splice: implement default splice_read method
Message-Id: <20090512223500.d7ef4648.akpm@linux-foundation.org>
In-Reply-To: <20090507133748.161689790@szeredi.hu>
References: <20090507133734.450612199@szeredi.hu>
	<20090507133748.161689790@szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 May 2009 15:37:36 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> +	for (i = 0; i < spd.nr_pages; i++) {
> +		kunmap(pages[i]);

It is deadlockable if any thread of control holds more than a single
kmap at a time.

Because there are a finite number of kmaps available, and if one is
unavailable, kmap() waits for one to become free.  If the number of
waiting threads equals the number of available slots, nobody makes any
progress.



