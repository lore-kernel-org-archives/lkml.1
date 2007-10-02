Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXJBRG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXJBRG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbXJBRGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:06:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28819 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbXJBRGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:06:48 -0400
Date: Tue, 2 Oct 2007 10:05:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org,
       systemtap@sources.redhat.com
Subject: Re: [patch 1/3]  Trace code and documentation
Message-Id: <20071002100557.a10ce7c1.randy.dunlap@oracle.com>
In-Reply-To: <1191342800.31351.9.camel@lc4eb748232119.ibm.com>
References: <1191342800.31351.9.camel@lc4eb748232119.ibm.com>
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

On Tue, 02 Oct 2007 09:33:19 -0700 David J. Wilder wrote:

> Trace - Provides tracing primitives
> 
> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: Martin Hunt <hunt@redhat.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  Documentation/trace.txt |  160 ++++++++++++++
>  include/linux/trace.h   |   99 +++++++++
>  lib/Kconfig             |    9 +
>  lib/Makefile            |    2 +
>  lib/trace.c             |  563 +++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 833 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/trace.txt b/Documentation/trace.txt
> new file mode 100644
> index 0000000..195132d
> --- /dev/null
> +++ b/Documentation/trace.txt

> +Trace User Interface
> +===================
> +When a trace channel is created and started, the following
> +directories and files are created in the root of the mounted debugfs.
> +
> +/debug (root of the debugfs)
> +	/<trace-root-dir>
> +		/<trace-name>
> +			trace[0...N-1]     Per-CPU trace data, one
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

                                   trace[0..N-1]

> +available interfaces provided by relay.
> +
> +When using the read(2) interface, as data is read it is marked as
> +consumed by the relay subsystem.  Therefore, subsequent reads will
> +only return unconsumed data.


---
~Randy
