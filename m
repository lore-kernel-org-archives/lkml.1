Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbYDZSyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbYDZSyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYDZSyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:54:08 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:33862 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbYDZSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:54:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoFAOwWE0hMROPA/2dsb2JhbACBU6hj
Date: Sat, 26 Apr 2008 14:54:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: ftrace and debugfs weird interaction
Message-ID: <20080426185403.GA22522@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:48:12 up 57 days, 14:59,  5 users,  load average: 0.21, 0.44,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When trying to figure out what was going on with the sched tracer
"tracing_enabled" file (sched-devel.git tree), I fell on this strange
behavior :

echo 1>tracing_enabled seems _not_ to send 1 to the tracing_ctrl_write
callback. However, sending garbage, e.g. echo s> tracing_enabled,
correctly sends the 's' character down the chain. echo 0>tracing_enabled
sometimes results in the callback not even being called.

The debugfs file has been created with

        entry = debugfs_create_file("tracing_enabled", 0644, d_tracer,
                                    &global_trace, &tracing_ctrl_fops);
        if (!entry)
                pr_warning("Could not create debugfs 'tracing_enabled' entry\n");

I wonder what kind of weird debugfs interaction we might have here ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
