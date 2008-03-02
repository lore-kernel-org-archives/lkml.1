Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYCBH6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYCBH6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 02:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYCBH6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 02:58:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53061 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYCBH6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 02:58:20 -0500
Date: Sun, 2 Mar 2008 07:58:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Unmatched semaphore usage in fs/super.c
Message-ID: <20080302075818.GV27894@ZenIV.linux.org.uk>
References: <804dabb00803012310s7b76e09bqc6d96c25e0618cf9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00803012310s7b76e09bqc6d96c25e0618cf9@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 03:10:35PM +0800, Peter Teoh wrote:
> Please pardon me if wrong.   In fs/super.c, I saw a down_read()
> without a matching (when sb->s_root is non-zero) up_read() as shown
> below:

Correct.  get_super() and user_get_super() return locked superblock.

> Neither did the get_super() caller remember and correct the semaphore
> either.   Is this a problem?

It would be, if it would be true.  Take a look at drop_super().
