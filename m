Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZKQQ3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZKQQ3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZKQQ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:29:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47361
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbZKQQ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:29:14 -0500
Date: Tue, 17 Nov 2009 08:29:28 -0800 (PST)
Message-Id: <20091117.082928.10537098.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: hpa@zytor.com, mingo@elte.hu, travis@sgi.com, tglx@linutronix.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com, rdreier@cisco.com,
       rdunlap@xenotime.net, tj@kernel.org, andi@firstfloor.org,
       gregkh@suse.de, yhlu.kernel@gmail.com, rientjes@google.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au,
       seto.hidetoshi@jp.fujitsu.com, steiner@sgi.com, fweisbec@gmail.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration
 bootup messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091117155946.GA5476@lenovo>
References: <20091116215052.GK5653@lenovo>
	<20091116.190922.182816918.davem@davemloft.net>
	<20091117155946.GA5476@lenovo>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Tue, 17 Nov 2009 18:59:46 +0300

> Perhaps for other archs like SPARC64, where as you said no need to
> remember boot cpu id at all, we should define some __weak per-kernel
> global helper which would return 0 and every arch would implement
> own helper boot_cpu_id().

On many of my machines none of my cpus are numbered "0", so that
wouldn't be a legitimate implementation on sparc64.

I see no reason for a platform the be required to remember the boot
cpu ID, there is nothing special about that processor generically.

And if we do need it generically, it's available there as
hard_smp_processor_id() when start_kernel() is called.  So init/main.c
could remember that value in an __initdata annotated static variable.

But just using a boolean for this "did I print the bogomips message
already?" thing seems more than sufficient.
