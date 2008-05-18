Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbYERV6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbYERV6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 17:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbYERV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 17:58:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:43385 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYERV55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 17:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G6ju0balj2TehUg6nWD1Dez9Wfee5bOix70iXTI/CA618GL3OOdGyTY7cuhj4C/AQjTyJcQZ2aNX+3hPyWldnLi1qK9bx1SGHeV3uogfdm2eUJMyK6RxYwf+IaniA64Sbr2LrlaA9rl2C1K6ZJnXELmO7bp8C79YcS3mh8JmprA=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/6] Sanity checks for ERR_PTR argument
Date: Sun, 18 May 2008 23:56:52 +0200
Message-Id: <1211147818-16056-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080513201813.GA5869@joi>
References: <20080513201813.GA5869@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little patchset adds sanity checks to ERR_PTR.

[PATCH 1/6] ERR_PTR: if errno value is known at compile time, make sure it's valid
[PATCH 2/6] ERR_PTR: add ERR_OR_0_PTR
[PATCH 3/6] vfs: open_exec cleanup
[PATCH 4/6] procfs: switch ERR_PTR to ERR_OR_0_PTR when "error" might be 0
[PATCH 5/6] vfs: fix ERR_PTR abuse in generic_readlink
[PATCH 6/6] ERR_PTR: warn when ERR_PTR parameter is not errno value

The most important are patches 1 and 6. 2nd patch adds another ERR_PTR-like helper.
The rest (3-5) fix false positives found by 6th patch.

---
 fs/exec.c           |   44 ++++++++++++++++++++++----------------------
 fs/namei.c          |   15 ++++++++-------
 fs/proc/base.c      |    4 ++--
 include/linux/err.h |   14 +++++++++++++-
 4 files changed, 45 insertions(+), 32 deletions(-)
---
