Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZBXEuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZBXEuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZBXEuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:50:09 -0500
Received: from kuber.nabble.com ([216.139.236.158]:47981 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZBXEuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:50:08 -0500
Message-ID: <22175803.post@talk.nabble.com>
Date: Mon, 23 Feb 2009 20:50:05 -0800 (PST)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Copy on write and page initialization
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

As far as I understand, Linux uses the COW optimization so parent and child
process share the same address space, till one of them writes to it, at
which point the kernel creates a copy of the page written to. This is done
through the function do_wp_page which in turn calls cow_user_page. 

I created a simple program, where the child and parent process write to a
variable differently. I have instrumented the kernel at cow_user_page. On
inserting the kprobe module and running the fork program, I do not get a
call to cow_user_page. I had several questions:
1. Does this mean that the kernel is not doing COW optimization? 
2. Is COW enabled by default, if not, how do we turn it on? 
3. Any other point in the kernel, where cow is done, other than
cow_user_page?

Regarding page initialization, if I understand it correctly, the kernel
calls get_zeroed_page when it has to allocated a zeroed page, once again in
my kernel module, I have probes the kernel at get_zeroed_page, but get no
calls, even on running the system for a long time, any other place where the
kernel gets zeroed pages to return the applications ?



Any help would be appreciated, thanks in advance
SC
-- 
View this message in context: http://www.nabble.com/Copy-on-write-and-page-initialization-tp22175803p22175803.html
Sent from the linux-kernel mailing list archive at Nabble.com.

