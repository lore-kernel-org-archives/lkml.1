Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbYGKTY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbYGKTY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYGKTUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:20:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757628AbYGKTUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:20:53 -0400
Date: Fri, 11 Jul 2008 12:20:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 13/17] Use WARN() in drivers/base/
Message-Id: <20080711122011.7ddf42ef.akpm@linux-foundation.org>
In-Reply-To: <20080708095307.6423cb6f@infradead.org>
References: <20080708093800.274504ba@infradead.org>
	<20080708095307.6423cb6f@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 09:53:07 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>Index: linux.trees.git/drivers/base/core.c

A number of these patches had mangled signed-off-by: lines.

Please try to be consistent in the presence and placement of the ^--- line
at the end of the changelog.

I verified that all three copies of "Use WARN() in fs/" were the same.

I've decided that I don't like the whole thing :(  This:

#define WARN(condition, format...) ({					\
	int __ret_warn_on = !!(condition);				\
	if (unlikely(__ret_warn_on))					\
		__WARN_printf(format);					\
	unlikely(__ret_warn_on);					\
})

is not a WARN().  It is a WARN_ON() function.  The use of this name now leaves
us no sensible name under which to implement

#define WARN(format...)


