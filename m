Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbXJHSln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbXJHSln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbXJHSld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:41:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33000 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432AbXJHSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:41:31 -0400
Date: Mon, 8 Oct 2007 11:06:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@localhost.localdomain>
Subject: [patch 11/12] SELinux: clear parent death signal on SID transitions
Message-ID: <20071008180640.GL7627@kroah.com>
References: <20071008180406.052382073@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="selinux-clear-parent-death-signal-on-sid-transitions.patch"
In-Reply-To: <20071008180551.GA7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

commit 4ac212ad4e8fafc22fa147fc255ff5fa5435cf33 upstream.

Clear parent death signal on SID transitions to prevent unauthorized
signaling between SIDs.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Eric Paris <eparis@parisplace.org>
Signed-off-by: James Morris <jmorris@localhost.localdomain>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/hooks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1906,6 +1906,9 @@ static void selinux_bprm_post_apply_cred
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
+	/* Always clear parent death signal on SID transitions. */
+	current->pdeath_signal = 0;
+
 	/* Check whether the new SID can inherit resource limits
 	   from the old SID.  If not, reset all soft limits to
 	   the lower of the current task's hard limit and the init

-- 
