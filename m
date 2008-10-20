Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYJTW20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYJTW20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbYJTW1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:27:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55651 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbYJTW1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:27:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 0/4] Audit support for file capabilities
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: viro@zeniv.linux.org.ok, sgrubb@redhat.com, serue@us.ibm.com,
       morgan@kernel.org
Date: Mon, 20 Oct 2008 18:25:57 -0400
Message-ID: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements audit support for file capabilities.  Audit
emits relevant fcaps infor for all path records, any time fcaps actually
escalate permissions, and we now print the arguments to sys_capset for when a
process tries to modify cap info.

---

Eric Paris (4):
      AUDIT: emit new record type showing all capset information
      AUDIT: audit when fcaps increase the permitted or inheritable capabilities
      AUDIT: output permitted and inheritable fcaps in PATH records
      CAPABILITIES: add cpu endian vfs caps structure


 include/linux/audit.h      |   22 +++++
 include/linux/capability.h |   12 +++
 kernel/auditsc.c           |  201 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/capability.c        |    3 +
 security/commoncap.c       |  131 ++++++++++++++++-------------
 5 files changed, 308 insertions(+), 61 deletions(-)
