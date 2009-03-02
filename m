Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbZCBRbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbZCBRbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZCBRbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:31:07 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55308 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbZCBRbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:31:05 -0500
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090302112247.76bb3662@thinkcentre.lan>
References: <20090227203425.F3B51176@kernel>
	 <20090227203435.98735E54@kernel> <20090302133754.GA8033@us.ibm.com>
	 <20090302095917.6cfeda55@thinkcentre.lan>
	 <1236011251.26788.450.camel@nimitz>
	 <20090302112247.76bb3662@thinkcentre.lan>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 09:30:52 -0800
Message-Id: <1236015052.26788.471.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 11:22 -0600, Nathan Lynch wrote:
> No.. I mean what if a process 1234 does
> 
> f = fopen("/proc/1234/stat", "r");
> 
> and is then checkpointed.  Can that path be resolved during restart,
> before pid 1234 is alive?

Heh, that's a good one.

It does mean that we can't do restore like this:

	for_each_cr_task()
		restore_task_struct()
		restore_files()
		...

We have to do:

	for_each_cr_task()
		restore_task_struct()
	for_each_cr_task()
		restore_files()


-- Dave

