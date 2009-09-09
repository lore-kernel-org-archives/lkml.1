Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZIIDb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZIIDb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZIIDb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:31:58 -0400
Received: from mail.perches.com ([173.55.12.10]:1057 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZIIDb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:31:58 -0400
Subject: Re: [PATCH v2 2/5] Use new __init_task_data macro in arch
 init_task.c files.
From: Joe Perches <joe@perches.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1252466482.14793.60.camel@desktop>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com>
	 <1252464546-26394-3-git-send-email-tabbott@ksplice.com>
	 <1252465099.14793.49.camel@desktop>
	 <1252465417.28130.3.camel@Joe-Laptop.home>
	 <1252465625.14793.52.camel@desktop>
	 <1252465802.28130.9.camel@Joe-Laptop.home>
	 <1252466482.14793.60.camel@desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Sep 2009 20:31:59 -0700
Message-Id: <1252467119.28130.21.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 20:21 -0700, Daniel Walker wrote:
> On Tue, 2009-09-08 at 20:10 -0700, Joe Perches wrote:
> > Shrug.  So submit a patch...
> I would if this was code in the kernel already, but it's not. LKML
> submission is the process people use to find these types of issues.
> Issues that should be fixed prior to inclusion, and may have been
> overlooked..

I think you should look at the patch again, and
perhaps not react what appears perhaps mindlessly.

Here's an example:

-union thread_union init_thread_union
-       __attribute__((__section__(".data.init_task"))) =
-               { INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+       { INIT_THREAD_INFO(init_task) };

cheers, Joe


