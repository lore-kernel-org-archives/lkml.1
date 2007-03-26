Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbXCZSlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbXCZSlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbXCZSlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:41:23 -0400
Received: from alnrmhc15.comcast.net ([204.127.225.95]:50708 "EHLO
	alnrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbXCZSlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:41:22 -0400
Date: Mon, 26 Mar 2007 11:01:55 -0700
From: Christopher Li <sparse@chrisli.org>
To: Russ Cox <rsc@swtch.com>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH] Add const to pointer qualifiers for __chk_user_ptr and __chk_io_ptr.
Message-ID: <20070326180155.GA24764@chrisli.org>
References: <ee9e417a0703260823k55c6de8ay715be1db11692355@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee9e417a0703260823k55c6de8ay715be1db11692355@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 11:23:56AM -0400, Russ Cox wrote:
> Change prototypes for  __chk_user_ptr and __chk_io_ptr
> to take const void* instead of void*, so that code can pass
> const void* to them.  (Right now sparse does not warn
> about passing const void* to void* functions, but that
> is a separate bug that I believe Josh is working on,
> and once sparse does check this, the changed prototypes
> will be necessary.)

I don't think it is needed. The __user has noderef attribute.
Which means it is not allow to dereference the pointer. The
const qualifier allow read dereference, only write is not allowed.

Adding const here will likely force the caller to do a cast at
the pointer arguments. Which defeats the checker.

Sparse allow passing const void* to void* is a different issue.

Chris

