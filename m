Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZF3INY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZF3INY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZF3INM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:13:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbZF3INL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:13:11 -0400
Message-ID: <4A49C96C.6070305@cn.fujitsu.com>
Date: Tue, 30 Jun 2009 16:14:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [QUESTION] trace_function_graph: consumed event may be invalid
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In get_return_for_leaf() {
	......
	ring_buffer_consume()
	......
	access to @curr->ent.pid
}

@curr is saved at consumed event, if this event is the last event
in the page, the ring_buffer may reuse the page. It will become invalid.

Is there any other code to ensure it valid when we `cat trace_pipe`?

Lai.


