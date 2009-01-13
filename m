Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZAMBzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZAMBzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZAMBzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:55:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38390 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbZAMBzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:55:21 -0500
Message-ID: <496BF48F.2030300@redhat.com>
Date: Mon, 12 Jan 2009 20:55:27 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [RFC][PATCH -mm 0/6] kprobes: Per-probe disabling support
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, kprobes can disable all probes at once, but can't disable it
individually (not unregister, just disable an kprobe, because unregistering
needs to wait for scheduler synchronization).
These patches introduce APIs for on-the-fly per-probe disabling and
re-enabling by dis-arming/re-arming its breakpoint instruction.

These patches can be applied on the latest -mm tree including my previous
bugfix patch (http://lkml.org/lkml/2009/1/5/472).

You can download a test of this feature from here:
http://sources.redhat.com/bugzilla/attachment.cgi?id=3082&action=view

Thank you,

 Documentation/kprobes.txt |   38 +++++-
 include/linux/kprobes.h   |   51 +++++++-
 kernel/kprobes.c          |  281 ++++++++++++++++++++++++++++++++--------------
 3 files changed, 279 insertions(+), 91 deletions(-)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com





