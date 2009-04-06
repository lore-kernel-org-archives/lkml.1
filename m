Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZDFVi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZDFVi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZDFViT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:38:19 -0400
Received: from mail.pikewerks.com ([24.96.136.236]:55487 "EHLO
	mail.pikewerks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZDFViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:38:19 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 17:38:19 EDT
Message-ID: <49DA7498.3050000@pikewerks.com>
Date: Mon, 06 Apr 2009 14:31:04 -0700
From: Matt Klein <matt.klein@pikewerks.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: matt.klein@pikewerks.com
Subject: Cached IO Synchronization Question
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me on any responses)

Hi,

I am studying 2.6.27.21 to try to understand the IO synchronization
model used in the Linux kernel.

I have the following question:

How are cached reads/writes synchronized? I assume they are, but I can
not determine how it is done.

1) do_generic_file_read calls find_get_page to get the existing page
cache page if it exists (it uses RCU to prevent the page from being
blown away while reading takes place). Assuming it does, it performs
various checks to make sure the page is up to date before performing an
atomic copy to user mode. The read path does not take the page lock.

2) The write path takes both the inode lock and the page lock to prevent
multiple writers. It also does an atomic copy from user mode into the
page cache page.

>From my reading of the code, the atomic copies are atomic only on a
single processor, not across processors. Right?

If so, what is to prevent one CPU from starting a cached read into a
user mode buffer while another CPU has partially copied data into the
page cache page?

Thanks,
Matt

-- 
Matt Klein
Technical Specialist
Pikewerks
matt.klein@pikewerks.com / 206 327 4515
