Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbZHXGUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbZHXGUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZHXGUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:20:39 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:33429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750848AbZHXGUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:20:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: Re: [PATCH] fix race copy_process() vs de_thread()
In-Reply-To: Roland McGrath's message of  Sunday, 23 August 2009 23:14:20 -0700 <20090824061420.341A9414DF@magilla.sf.frob.com>
References: <4A9210A4.4010108@ct.jp.nec.com>
	<20090824061420.341A9414DF@magilla.sf.frob.com>
Emacs: the only text editor known to get indigestion.
Message-Id: <20090824062001.0E526414DF@magilla.sf.frob.com>
Date: Sun, 23 Aug 2009 23:20:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I see.  This happens when the copy_process() thread was the old
group_leader itself.  Then it never does release_task() itself.

Your fix seems adequate.  Another approach would be to have some place
like exit_signals() check for the group_exit_task case.

Oleg, what do you think?


Thanks,
Roland
