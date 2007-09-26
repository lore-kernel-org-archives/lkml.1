Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbXIZSls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbXIZSls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXIZSlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:41:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16522 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbXIZSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:41:39 -0400
Date: Wed, 26 Sep 2007 11:37:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [patch 1/3]  Trace code and documentation
Message-Id: <20070926113724.e9cd035b.randy.dunlap@oracle.com>
In-Reply-To: <1190830956.1232.12.camel@lc4eb748232119.ibm.com>
References: <1190830956.1232.12.camel@lc4eb748232119.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 11:22:35 -0700 David J. Wilder wrote:

> diff --git a/Documentation/trace.txt b/Documentation/trace.txt
> new file mode 100644
> index 0000000..0e42fb8
> --- /dev/null
> +++ b/Documentation/trace.txt
> @@ -0,0 +1,160 @@
> +Trace User Interface
> +===================
> +When a trace channel is created and started, the following
> +directories and files are created in the root of the mounted debugfs.
> +
> +/debug (root of the debugfs)
> +	/<trace-root-dir>
> +		/<trace-name>
> +			trace0...traceN-1  Per-CPU trace data, one
> +					   file per CPU.
> +
> +			state		   Start or stop tracing by
> +					   by writing the strings
> +					   "start" or "stop" to this
> +					   file. Read the file to get the
> +					   current state.
> +
> +			dropped		   The number of records dropped
> +					   due to a full-buffer condition,
> +					   for non-TRACE_FLIGHT_CHANNELs
> +					   only.
> +
> +			rewind		   Trigger a rewind by writing
> +					   to this file.  i.e. start
> +					   next read at the beginning
> +					   again. Only available for
> +					   TRACE_FLIGHT_CHANNELS.
> +
> +
> +			nr_sub		   Number of sub-buffers
> +					   in the channel.
> +
> +			sub_size	   Size of sub-buffers in
> +					   the channnel.
> +
> +Trace data is gathered from the trace[0...N] files using one of the
> +available interfaces provided by relay.

For your next patchset (whenever that is), above should be
                                   trace[0...N-1] files

> +When using the read(2) interface, as data is read it is marked as
> +consumed by the relay subsystem.  Therefore, subsequent reads will
> +only return unconsumed data.


---
~Randy
Phaedrus says that Quality is about caring.
