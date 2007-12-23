Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXLWJcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXLWJcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 04:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXLWJcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 04:32:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38517 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXLWJcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 04:32:45 -0500
Date: Sun, 23 Dec 2007 09:32:41 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: clameter@sgi.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: tlb_finish_mmu() bogisity
Message-ID: <20071223093241.GR8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
makes no sense whatsoever.  How the hell can you ever get the address of
__get_cpu_var(quicklist)[0].nr_pages to be NULL?  Postfix operators have
higher precedence than prefix ones, so that's
	&(((__get_cpu_var(quicklist))[0]).nr_pages)

What did you intend here?  s/&//, perhaps?
