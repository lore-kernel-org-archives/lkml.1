Return-Path: <linux-kernel-owner+w=401wt.eu-S1765418AbXF2MJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765418AbXF2MJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761515AbXF2MJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:09:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23934 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761063AbXF2MJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:09:36 -0400
Subject: Re: Tasklet usage in the DRM
From: Daniel Walker <dwalker@mvista.com>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1183100942.3289.296.camel@thor.sulgenrain.local>
References: <1183100942.3289.296.camel@thor.sulgenrain.local>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 Jun 2007 08:04:30 -0400
Message-Id: <1183118671.4405.12.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 09:09 +0200, Michel Dänzer wrote:
> I just read an article on LWN's kernel page about plans to remove
> tasklets, and I thought I'd explain what the DRM is using tasklets for.
> Maybe there's other ways to satisfy the requirements equally well or
> even better.
> 
> 
> The i915 driver uses a tasklet to make sure a GL buffer swap blit or
> flip takes effect (or at least starts in the case of a blit) during the
> vertical blank period, to avoid tearing. I chose a tasklet for this
> purpose because:
> 
>       * The traditional method of the vertical blank interrupt waking up
>         the user process, which would then emit the buffer swap
>         commands, didn't even come close to avoiding tearing. So I
>         suspect a workqueue wouldn't cut it either.
>       * The processing of scheduled buffer swaps could potentially take
>         a long time, so doing it in hardirq context could cause high IRQ
>         latency.
>       * It requires holding the DRM lock, so the 'each tasklet can only
>         run once at a time' restriction is fine.
> 
> 
> I'm looking forward to any suggestions what to do with this in case
> tasklets disappear, and I'll gladly provide further clarification on the
> requirements.

If it hasn't been done someone with this hardware could test Steven's
patches to see if they do satisfy the requirements..

I think the most recent version was posted in this message,
http://lkml.org/lkml/2007/6/27/289

Subject was "[RFC PATCH 0/8] Convert all tasklets to workqueues V3" if
people are subscribed to LKML ..

(Added Steven to the CC list)

Daniel

