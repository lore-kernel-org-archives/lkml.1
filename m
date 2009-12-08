Return-Path: <linux-kernel-owner+w=401wt.eu-S966541AbZLHV4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966541AbZLHV4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966530AbZLHV4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:56:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966532AbZLHV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:56:04 -0500
Date: Tue, 8 Dec 2009 13:55:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt dropped transmit data bugfix
Message-Id: <20091208135510.ffd75637.akpm@linux-foundation.org>
In-Reply-To: <1260310010.3764.49.camel@x2.microgate.com>
References: <1260310010.3764.49.camel@x2.microgate.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Dec 2009 16:06:50 -0600
Paul Fulghum <paulkf@microgate.com> wrote:

> +	/* check required buffer space */
> +	bufs_needed = (size/DMABUFSIZE);
> +	if (size % DMABUFSIZE)
> +		++bufs_needed;

	bufs_needed = DIV_ROUND_UP(size, DMABUFSIZE);

?


That unsent_tbufs() call looks like it might be expensive.
