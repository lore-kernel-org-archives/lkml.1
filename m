Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbZKZHix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbZKZHix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbZKZHix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:38:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55080 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZKZHiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:38:52 -0500
Subject: Re: [PATCH 2/9] tracing: Convert some kmem events to DEFINE_EVENT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <4B0E2D3A.1030509@cs.helsinki.fi>
References: <4B0E2807.4060102@cn.fujitsu.com>
	 <4B0E286A.2000405@cn.fujitsu.com>  <4B0E2D3A.1030509@cs.helsinki.fi>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 02:38:57 -0500
Message-Id: <1259221137.21397.80.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 09:24 +0200, Pekka Enberg wrote:

> I have no idea what TRACE_EVENT_TEMPLATE is but the space savings are 
> convincing enough! I assume this is going into -tip?

TRACE_EVENT_TEMPLATE acts just like TRACE_EVENT but it does not create
the trace point. It does create general functions described by the
template. These are the functions to record data and how to print that
data, and show its format to userspace.

DEFINE_EVENT is used to hook an actual trace point up with the functions
created by the template.

There are a lot of events that are almost identical except for their
names. Using TRACE_EVENT() itself will create the functions to record
the data, print it, and show the format for each event, even though most
of these events are identical except for the name.

Christoph Hellwig was killed by this, since he had hundreds of
TRACE_EVENTS all with the same data. After converting it to the
templates, he saved a hell of a lot of space.

-- Steve


