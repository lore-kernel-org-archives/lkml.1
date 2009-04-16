Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZDPUOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZDPUOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZDPUNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:13:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZDPUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:13:51 -0400
Subject: Re: [PATCH 1/2 v2] tracing/events: provide string with undefined
 size support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
References: <1239912047-6282-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 22:13:32 +0200
Message-Id: <1239912812.23397.3432.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 22:00 +0200, Frederic Weisbecker wrote:
> Impact: less memory usage for tracing
> 
> This patch provides the support for dynamic size strings on
> event tracing.
> 
> The key concept is to use a structure with an ending char array field of
> undefined size and use such ability to allocate the minimal size on the ring
> buffer to make the entry fit inside as opposite to a fixed length strings with
> upper bound.
> 
> This patch provides one new macro:
> 
> -__ending_string(name, src)
> 
> This one declares the string to the structure inside TP_STRUCT__entry.
> You need to provide the name of the string field and the source that will be
> copied inside.
> Two constraints: only one __ending_string() per TRACE_EVENT can be added and
> it must be the last field to be declared. Hence the __ending prefix.
> 
> This macro will declare the necessary field and will also add the dynamic
> size of the string needed for the ring buffer entry allocation.
> 
> It also support filtering because these strings behave essentially
> like usual fixed length string.

can't we simply do __string(name, src) and output something like:

 struct {
   u16 size;
   char str[0];
 } name;

That would get rid of this __ending_ wart.

