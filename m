Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYK1N7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYK1N7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYK1N65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:58:57 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:56676 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYK1N64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:58:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i1TLXeRSDHBazQ1XDlmMzfgtYVbEpLujEX4S+7sDGt3iB9ldLQhrdb3t2C7U3nA662
         QvJzu8elyLIOta9MQq+/kK2OhtLqA8smIa8e3X3eXVUKRouMt+FLuRVj93hPambxE6kW
         x1Nhxg+WgNqeL7RO1EJ8w/zxEVynYpoB0l9PI=
Message-ID: <c62985530811280558q562ec3afj8486fe494482b4e1@mail.gmail.com>
Date: Fri, 28 Nov 2008 14:58:55 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the trace informations
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081128092553.GA7040@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu>
	 <20081128092553.GA7040@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/28 Ingo Molnar <mingo@elte.hu>:
>
> another thing which i'm sure you are aware of:
>
> # tracer: function_graph
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>  ------------------------------------------
>  | 1)  S99local--1  =>  ssh-1724
>  ------------------------------------------
>
>  1)      0.867 us |        }
>  1)               |        mark_page_accessed() {
>  1)      0.293 us |          constant_test_bit();
>  1)      0.294 us |          constant_test_bit();
> [...]
>
> the header description is now out of of sync :-)
>
> Also, we should probably not start the trace with a PID-switch event.
> the last_pid[] markers are probably out of sync when we start printing
> the trace.
>
> So the output should probably be something like:
>
> # tracer: function_graph
> #
> # CPU      COST     FUNCTION-GRAPH
> # |          |       |
>
>  1)      0.867 us |        }
>  1)               |        mark_page_accessed() {
>  1)      0.293 us |          constant_test_bit();
>  1)      0.294 us |          constant_test_bit();
> [...]


Ok I will just have to update something in the open callback....
