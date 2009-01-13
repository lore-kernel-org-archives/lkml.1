Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbZAMXSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbZAMXSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbZAMXRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:17:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53061 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884AbZAMXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:17:42 -0500
Date: Tue, 13 Jan 2009 18:16:17 -0500
From: Jason Baron <jbaron@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] ftrace: show ftrace_bprintk()'s formats
Message-ID: <20090113231617.GD3210@redhat.com>
References: <495ADF57.8030008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495ADF57.8030008@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 10:56:23AM +0800, Lai Jiangshan wrote:
> 
> Impact: let user knows the format
> 
> Create a file on <debugfs-dir>/tracing/ to show ftrace_bprintk()'s formats.
> 
> This formats will help for these condition:
> 1) User get binary data from core file.(formats are backup before coredump)
> 2) User splice ring_buffer to a file.
> User can use formats for parsing the binary data in userspace.
> 

When I 'cat' trace_bprintk_formats on my system the file is empty. This
seems to be b/c 'ftrace_bprintk' is not being used in this patchset. It
can't be used in patch #5 during marker register b/c the format wouldn't
be known at runtime. Thus, as it currently stands this patch, patch 4/5,
isn't adding much?

A thought on how this might be resolved would be to have the core marker
code pass us its address so this could be recorded in the trace buffer.
Then, also add some debug file that displays the markers and maps marker
addresses with format strings.

thanks,

-Jason


