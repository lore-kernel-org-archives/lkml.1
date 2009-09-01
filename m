Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbZIAD2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbZIAD2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 23:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZIAD2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 23:28:33 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:58356 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZIAD2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 23:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r9BSyfNGuDte3zlDUjDxNG7gbS2pFHyJHJsQVvvUiPhgLPYMGfmJalwyICXPFd7Iiy
         PFdpsqo8TqD9Z9jampkinU3WMIi3xt1ox4WGm84PiIyc2E4d0ED9IJqAowH5zrvdl6t9
         vmxubcCtTwlCxu2YxUXMydA1vazUHWEcvhv64=
Subject: Re: [PATCH] tracing/filters: Defer pred allocation
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A9B8EA5.6020700@cn.fujitsu.com>
References: <4A9B8EA5.6020700@cn.fujitsu.com>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 22:28:32 -0500
Message-Id: <1251775712.6800.2.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-31 at 16:49 +0800, Li Zefan wrote:
> init_preds() allocates about 5392 bytes of memory (on x86_32) for
> a TRACE_EVENT. With my config, at system boot total memory occupied
> is:
> 
> 	5392 * (642 + 15) == 3459KB
> 
> 642 == cat available_events | wc -l
> 15 == number of dirs in events/ftrace
> 
> That's quite a lot, so we'd better defer memory allocation util
> it's needed, that's when filter is used.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Other than the leak mentioned by Frederic, it looks good to me.

Acked-by: Tom Zanussi <tzanussi@gmail.com>


