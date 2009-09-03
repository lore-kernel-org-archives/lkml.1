Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZICQKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZICQKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZICQKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZICQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:10:44 -0400
Date: Thu, 3 Sep 2009 18:05:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 0/1] exec: do not sleep in TASK_TRACED under
	->cred_guard_mutex
Message-ID: <20090903160510.GA23638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I cc'ed Linus and stable, but I don't know how to really test this patch
and I don't really understand the new creds management.

Please review.


load_flat_shared_library() does something strange (but hopefully this
patch doesn't break it). I do not understand why does it create the
new bprm. Afaics, it could reuse bprm pointer which comes as an argument
of ->load_binary(), all we need is to temporary change/restore bprm->file
for load_flat_file().

Oleg.

