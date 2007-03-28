Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbXC1UpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbXC1UpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932809AbXC1UpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:45:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932808AbXC1UpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:45:15 -0400
Date: Wed, 28 Mar 2007 13:45:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-Id: <20070328134511.0d61ec8f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 13:12:56 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> The benefit of preconstructed pgds and pmds in the i386 arch code seem to
> be debatable. The performance measurements indicate that there may be a slight
> benefit but it seems to almost vanish in the noise ratio.

yeah, I did a couple hours testing with rc5, rc5+quicklists,
rc5+quicklists+qlhack, where "qlhack" is my patch which removes the
quicklists and mysteriously causes i386 to crash.

I was testing 8-way x86_64 with patch-scripts (wildly fork-intensive),
kernel build and lmbench.

Basically I was unable to observe any statistically meaningful-looking
differences between any of them.

I would like to test qlhack on ia64, because ia64 puts pte-pages into the
quicklists as well, but my ia64 machine is presently indisposed.

My (much) preferred way to handle all this is to remove the quicklists from
all architectures: just use alloc_page() and free_page() for pte pages, pmd
pages, etc.  I remain unaware of any testing whcih indicates that this
would be a bad change.

