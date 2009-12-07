Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbZLGBA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbZLGBA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 20:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758302AbZLGBA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 20:00:58 -0500
Received: from lo.gmane.org ([80.91.229.12]:56909 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266AbZLGBA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 20:00:57 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: [2.6.32.git] commit 1cedae7 breaks gdb
Date: Sun, 06 Dec 2009 17:03:20 -0800
Message-ID: <4B1C5458.1030707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
X-Gmane-NNTP-Posting-Host: adsl-69-234-195-198.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.3a1pre) Gecko/20091206 Thunderbird/3.1a1pre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys.  This commit:

commit 1cedae72904b85462082dbcfd5190309ba37f8bd
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Wed Dec 2 07:32:16 2009 +0100

     hw-breakpoints: Keep track of user disabled breakpoints

breaks debugging with gdb (at least gdb-7.0, anyway).

For example, if you start firefox with the -g flag, it will run
in gdb.  When running a kernel with this commit, gdb will stop
with the message: "Couldn't write debug register: No space left
on device".  When trying to quit gdb by typing 'q', the process
hangs forever.

This seems to be related to the size of the program being debugged.
Running /bin/ls with gdb, for example, works normally.  But large
programs like firefox, thunderbird, or evolution (from gnome) all
trigger the same error message.

Can anyone reproduce this?

Thanks.


