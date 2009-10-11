Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbZJKUYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbZJKUYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 16:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZJKUYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 16:24:34 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:39591 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbZJKUYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 16:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w+SA6Y6736Gdkpbq0/V8JlP+7s+SvcoHODeh0s4RTvRv9ciqHvJfSBRSggN9JABwtB
         xt6Iam0Ipo57V84Zz5dNRs8BVzGpghCMcKVgI/8DtRNeIEy8oTSUWkkEbirkNxw3eWAB
         lD3cliVM7QGdkeKVFX3TWszvFNFiwMPg0f1cE=
Date: Sun, 11 Oct 2009 22:23:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: perf trace errors
Message-ID: <20091011202353.GA5486@nowhere>
References: <20091011025441.GA18152@lst.de> <20091011121926.GD4901@nowhere> <20091011124030.GA3859@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011124030.GA3859@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 02:40:30PM +0200, Christoph Hellwig wrote:
> On Sun, Oct 11, 2009 at 02:19:28PM +0200, Frederic Weisbecker wrote:
> > Yeah, there are still some trace events that are not well supported
> > in perf trace, for now... I'll fix that by the time.
> 
> Any idea what is the missing part?  I tried to understand the code but
> I haven't even managed to grasp the data structures yet.
> 
> The weird thing is that these message seem to come from parsing of
> the filters, and a simple trace the whole system trace shouldn't
> really have to set any filters anyway, nor should the filters depdend
> on what trace point you use.
> 
> Note that the in addition to all the block trace points also all my
> new xfs tracepoints also give errors from perf trace.  Things tend
> to work quite nicely with the ASCII output from the kernel.
> 


It's about the trace event format file parsing, especially the format
line:

print fmt: "%d,%d %s %llu + %u [%s]", ((unsigned int) ((REC->dev) >> 20)), ((unsigned int) ((REC->dev) & ((1U << 20) 
- 1))), REC->rwbs, (unsigned long long)REC->sector, REC->nr_sector, REC->comm

This is done from tools/perf/util/trace-event-parse.c

It is supposed to handle such cases already, not sure exactly where is
the problem currently, that needs some investigation.

