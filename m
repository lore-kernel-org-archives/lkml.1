Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZI2Ju5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZI2Ju5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZI2Ju4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:50:56 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47738 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZI2Ju4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:50:56 -0400
Date: Tue, 29 Sep 2009 10:51:33 +0100
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tracing: Fix infinite loop in ftrace_update_pid_func()
Message-ID: <20090929095133.GB6934@console-pimps.org>
References: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 04:43:01PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matthew.fleming@imgtec.com>
> 
> When CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST is enabled
> __ftrace_trace_function contains the current trace function, not
> ftrace_trace_function. In ftrace_update_pid_func() we currently
> incorrectly assign the value of ftrace_trace_function to
> __ftrace_trace_funcion before returning.
> 
> Without this patch it is possible to execute an infinite loop whereby
> ftrace_test_stop_func() calls __ftrace_trace_function, which was
> assigned ftrace_test_stop_func() in ftrace_update_pid_func().
> 

Oops..

I just realised I've used the phrase "infinite loop" when what I meant
to say was "infinite recursion". Sorry, brain fart.
