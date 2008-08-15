Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYHOHfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYHOHfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 03:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbYHOHfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 03:35:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753333AbYHOHfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 03:35:16 -0400
Date: Fri, 15 Aug 2008 00:34:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       snakebyte@gmx.de
Subject: Re: [PATCH 2/2] omfs: fix oops when file metadata is corrupted
Message-Id: <20080815003416.acc05f01.akpm@linux-foundation.org>
In-Reply-To: <1218770022-31956-2-git-send-email-me@bobcopeland.com>
References: <1218770022-31956-2-git-send-email-me@bobcopeland.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 23:13:42 -0400 Bob Copeland <me@bobcopeland.com> wrote:

> +out_brelse:
> +	brelse(bh);

btw, put_bh() is the fashionable way of dropping a buffer refcount.  We
still use brelse() when the pointer might be NULL, but often it is
known to not be.

