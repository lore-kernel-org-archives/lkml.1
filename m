Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYFUSRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYFUSRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYFUSRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:17:41 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:53415 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYFUSRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=tchnnL6O8ycb/xboOLMEHy+wheOuapBdD0Ul8QPPQ0C/mFF+HJm+4mjqk3zJv4sgwx
         L46fHra1tHfk9mQm6iDIOsxDlicpoWeRrZrUTS5Gt8bfs9aGkqXZhtS1pheQb8XdQeS7
         Th2+MiQ/OM6mE//WtUepIx6UetWH5Tkhdxn3w=
Message-ID: <485D45AB.3000405@gmail.com>
Date: Sat, 21 Jun 2008 23:47:15 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] ftrace: prevent ftrace modifications while being kprobe'd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven/Ingo,

These patches address the problem of kprobe registration interfering with
dynamic ftrace. A kprobe registered on an mcount call-site can modify that
address multiple times during its duration of probing. At the same time,
ftrace may simultaneously modify these locations. This could be fatal
especially if ftrace modifies the call-site during a kprobe registration
on it (between arch_prepare_kprobe and arch_arm_kprobe in __register_kprobe
to be more precise). So as a "fix", I've disabled any updates on the mcount
call-site while it's being kprobe'd.

--
Regards,
Abhishek Sagar
