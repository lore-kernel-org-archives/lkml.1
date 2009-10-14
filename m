Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbZJNMZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbZJNMZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbZJNMZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:25:21 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:38141 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbZJNMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:25:20 -0400
Date: Wed, 14 Oct 2009 21:24:44 +0900 (JST)
Message-Id: <20091014.212444.179938286.ryov@valinux.co.jp>
Subject: IO controller Mini-Summit 2009
From: Ryo Tsuruta <ryov@valinux.co.jp>, Ryo Tsuruta <ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have summarized the topics for the IO controller mini-summit and
written the ideas seen in the mailing list.

- The place where IO controller should be implemented
  - Block layer in conjunction with the IO scheduler
  - Common layer right above the IO scheduler
  - CFQ enhancement.
  - Both block and common layer, users can select whichever controller
    they want.
  - VFS layer

- What kind of bandwidth control policies are needed?
  - Proportional weight
  - Enforcing upper limit
  - Minimum bandwidth guarantee

- How to handle buffered writes?
  - Add dirt-ratio in the memory controller
  - Add bufferred-write-cgroup to track buffered writebacks
  - A per group per bdi pdflush threads

- Who should be charged for swap activity?
  - who requests a page.
  - who has a page.
  - All swap activities are charged to the root group.

And I would also like to discuss about the followings.

- Extensions of struct bio
  - Make a bio point to the io_context of a process which creates the
    I/O request. This allows to pass the IO scheduling class and
    priority information to IO controller even if the IO is submitted
    by another process which does not create the request, such as a
    worker thread.
  - Add a new flag to struct bio to identify the bio as urgent. This
    gives IO controller a chance to handle the bio as high
    priority. This flag should be set if the bio is created for the
    page-out operation. 

- Common test methods to verify the functionality of IO controller.

Please give me comments and suggestions. I may be missing or
misunderstanding something.

Thanks,
Ryo Tsuruta
