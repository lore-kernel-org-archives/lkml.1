Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZINMUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZINMUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZINMUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:20:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbZINMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:20:30 -0400
Subject: Re: [RFC PATCH 0/2] tracing - signal tracer, support multiple pids
 in set_pid_ftrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1252923251-6735-1-git-send-email-jolsa@redhat.com>
References: <1252923251-6735-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 14 Sep 2009 08:20:33 -0400
Message-Id: <1252930833.20020.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 12:14 +0200, jolsa@redhat.com wrote:
> I was debugging some ptrace applications and got to the idea of 
> tracing signals - signal tracer. There's probably possibility to 
> trace more info than just signal delivery info (like ignored 
> signals deliveries, queue status...).
> 
> While doing this I realized it might be worth to have ability to trace 
> more independent processes via set_pid_ftrace file.
> 
> Althought I'm sending this as RFC, attached patches work for me. 
> I'm open to any suggestions/comments/ideas.
> 
> 1/2 - signal trace

Don't make it a plugin. Just put the trace points into the signal
handler, and then you enable them via the event tracer.

> 2/2 - multiple pids support for set_pid_ftrace file

I took a quick look at this patch and I so far like it. But this will
not help you with events, but filtering will. That is:

 # echo "common_pid == 1234" > /debug/tracing/events/signals/signal/format

You can do multiple pids with "common_pid == 1234 || common_pid == 1235"

-- Steve


