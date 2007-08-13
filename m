Return-Path: <linux-kernel-owner+w=401wt.eu-S934151AbXHMW6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbXHMW6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759035AbXHMW6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:58:07 -0400
Received: from shakespeare.ccsl.carleton.ca ([134.117.225.11]:48810 "EHLO
	shakespeare.ccsl.carleton.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758225AbXHMW6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:58:04 -0400
X-Greylist: delayed 3145 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 18:58:04 EDT
Message-ID: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
Date: Mon, 13 Aug 2007 18:05:35 -0400
From: hinoue@ccsl.carleton.ca
To: linux-kernel@vger.kernel.org
Subject: System call interposition/unprotecting the table
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about changing the page attributes of the
system call table.

I am writing a kernel module that does some system call interposition.
This works fine on my debian system, but apparently the stock Fedora
kernel (2.6.22) has the system call table write protected.  So I would like
the module to add write permissions to the system call table before
it modifies it.

This is the code in my init_module that is problematic:

// Storing the original call
orig_kill = sys_call_table[__NR_kill];

// Change to write
pg = virt_to_page(sys_call_table);
change_page_attr(pg, 1, PAGE_KERNEL);
global_flush_tlb();

// Test write, should change nothing, but oopses instead
sys_call_table[__NR_kill] = (void*)orig_kill;

I imagine that I'm doing something obviously wrong; I've only been looking
at kernel code for a couple weeks.  Can someone please explain what my
error is?

-Hajime Inoue
