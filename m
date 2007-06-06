Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbXFFJvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbXFFJvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbXFFJu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:50:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXFFJu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:50:56 -0400
Message-ID: <4666832D.8080603@redhat.com>
Date: Wed, 06 Jun 2007 11:49:33 +0200
From: Miloslav Trmac <mitr@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Steve Grubb <sgrubb@redhat.com>, Alexander Viro <aviro@redhat.com>
Subject: [PATCH] Audit: Add TTY input auditing
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

Add TTY input auditing, used to audit system administrator's actions.
TTY input auditing works on a higher level than auditing all system
calls within the session, which would produce an overwhelming amount of
mostly useless audit events.

Add an "audit_tty" attribute, inherited across fork ().  Data read from
TTYs by process with the attribute is sent to the audit subsystem by the
kernel.  The audit netlink interface is extended to allow modifying the
audit_tty attribute, and to allow sending explanatory audit events from
user-space (for example, a shell might send an event containing the
final command, after the interactive command-line editing and history
expansion is performed, which might be difficult to decipher from the
TTY input alone).

Because the "audit_tty" attribute is inherited across fork (), it would
be set e.g. for sshd restarted within an audited session.  To prevent
this, the audit_tty attribute is cleared when a process with no open TTY
file descriptors (e.g. after daemon startup) opens a TTY.

See https://www.redhat.com/archives/linux-audit/2007-June/msg00000.html
for a more detailed rationale document for an older version of this patch.

