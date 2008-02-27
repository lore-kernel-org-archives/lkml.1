Return-Path: <linux-kernel-owner+w=401wt.eu-S1760528AbYB0VEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbYB0VEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759232AbYB0VBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:01:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665AbYB0VBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:01:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: Jiri Kosina's message of  Wednesday, 27 February 2008 16:22:06 +0100 <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20080227210038.93AFC2700FD@magilla.localdomain>
Date: Wed, 27 Feb 2008 13:00:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you observed an actual problem?  I don't think the "race" you seem to
be concerned about is a problem at all.

The comment refers to the necessary atomicity of posting the signal along
with doing the wakeups.  Those are done together with the siglock held.
It does not matter that the siglock was dropped and reacquired before
there.  All that matters is that we hold the siglock continuously from
before the wake_up_state calls made in handle_stop_signal through until
after the signal-posting done by its callers.

Can you enumerate the specific sequence of events that would result in
error under the current code?


Thanks,
Roland
