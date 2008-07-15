Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYGOKzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYGOKzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 06:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbYGOKzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 06:55:10 -0400
Received: from mail.macqel.be ([194.78.208.39]:16845 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbYGOKzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:55:09 -0400
Date: Tue, 15 Jul 2008 12:55:04 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: core_uses_pid==0 still produces core.PID
Message-ID: <20080715105504.GA31097@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody

I have a process that produces core files of the form "core.PID".

I read in the docs the core file name can be controlled by
/proc/sys/kernel/core_pattern and /proc/sys/kernel/core_uses_pid.

On my machine, they have the value "core" and 0, so I would expect the
core files named "core", not "core.PID".

If I start "sleep 100" and kill it with CTRL-C, I indeed get a file
named "core", but with my interesting process the files are always named
"core.PID".

Looking at the fs/exec.c sources, I see that core_uses_pid is superseded
by
	atomic_read(&current->mm->mm_users) != 1

Why is that needed there ? When my process crashes or is killed, I always
get only one core file, not many core files, although my process is
multi-threaded.

Is that a rest of a previous thread implementation that could now be removed ?

Best regards

Philippe
