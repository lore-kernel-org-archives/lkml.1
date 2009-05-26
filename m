Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZEZVRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZEZVRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZEZVRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:17:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbZEZVRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:17:15 -0400
Date: Tue, 26 May 2009 23:13:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Q: do_notify_parent/do_notify_parent_cldstop && info.si_xtime
Message-ID: <20090526211306.GA7065@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_notify_parent() reports .si_Xtime = tsk->Xtime + signal->Xtime,
but do_notify_parent_cldstop() uses .si_Xtime =  tsk->Xtime.

Is this right?

Yes, tsk->Xtime + signal->Xtime does not make much sense for
do_notify_parent_cldstop(), but reporting group_leader->Xtime
(if not traced) doesn't look very right too. IOW, perhaps we
need thread_group_cputime() here?

Ole.

