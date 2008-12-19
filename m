Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYLSETV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYLSETV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYLSETE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:19:04 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:44365 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYLSETC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:19:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BmEGKqc15rjGMpTs2FniAS3r1JDBgOrSfd5+c/vXWNv6aLKUjJBp22cdiOioEXYMgJ
         1oiMHEepi80prSR0H92WviD+nWGx48MNUFVyOkcGAFUr8c0o9u9RHxEVQUU6vOlWlj4k
         mhjkB+j7UYRvuuT2cM9NNuM12pr0K6v1l2VOI=
From: crquan@gmail.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] dm-target: target_type improvements
Date: Fri, 19 Dec 2008 12:19:42 +0800
Message-Id: <1229660385-17153-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

The series of patches:
1. use module's refcount instead of self-maintained use field;
2. use pointer reference instead of making a copy of target_type;
3. totally remove tt_internal;

The 3rd patch may be controversial,

On Wed, Dec 17, 2008 at 7:48 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> Target registrations should be rare one-off events.  The existing trade-off
> is
> in favour of a cleaner interface (that does not expose private fields).  The
> struct target_type passed to dm_register_target is always static read-only
> data
> and perhaps that could be enforced and a pointer stored in tt_internal
> instead
> of making a copy.

But I still think it's worth it:
1. current users of struct target_type hasn't been marked with const, just
   static;
2. other similar structures (file_system_type in filesystems, packet_type in
   net core, ) all have internally used list_head for manage purpose;
   this design can avoid memory frag from kmalloc/kfree.

--
Cheng Renquan, Shenzhen, China
