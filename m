Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZDYRbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZDYRbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 13:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZDYRbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 13:31:06 -0400
Received: from kroah.org ([198.145.64.141]:56677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbZDYRbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 13:31:05 -0400
Date: Sat, 25 Apr 2009 10:26:54 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 5/5] tracing/events: make modules have their own
	file_operations structure
Message-ID: <20090425172654.GC12135@kroah.com>
References: <20090425042030.431477667@goodmis.org> <20090425042633.428284874@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425042633.428284874@goodmis.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 12:20:35AM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> For proper module reference counting, the file_operations that modules use
> must have the "owner" field set to the module. Unfortunately, the trace events
> use share file_operations. The same file_operations are used by all both
> kernel core and all modules.
> 
> This patch makes the modules allocate their own file_operations and
> copies the functions from the core kernel. This allows those file
> operations to be owned by the module.
> 
> Care is taken to free this code on module unload.
> 
> Thanks to Greg KH for reminding me that file_operations must be owned
> by the module to have reference counting take place.
> 
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks good, feel free to add an:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to it.

thanks,

greg k-h
