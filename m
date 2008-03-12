Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYCLNiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYCLNiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYCLNhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:37:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:39916 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYCLNhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=wfF7+WR8GUdVfZFQuQ6vZHJ5XFwH+CFUv5qbmbgeiMoXjdEvJx4xY+QG0SXref3yAtHjFvHRIzn348k2WCX/cKOLaT1mmBfX+isKgGZBFUwP/lZg0eZmoipQRlZu6eYHW24tbEGaoYU70IQprrhctbfgWzK5OPZvZP80xr+HOPk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/4] ide-tape: remove pipeline-specific code from idetape_add_chrdev_write_request
Date: Wed, 12 Mar 2008 14:51:32 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <200803110025.19650.bzolnier@gmail.com> <20080312054156.GC4266@gollum.tnic>
In-Reply-To: <20080312054156.GC4266@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803121451.33058.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Borislav Petkov wrote:
> On Tue, Mar 11, 2008 at 12:25:19AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 09 March 2008, Borislav Petkov wrote:
> > > Refrain from adding more write requests to the pipeline and queue them
> > > directly on the device's request queue instead. Prior to that flush all
> > > penging stages in the pipeline through idetape_wait_for_pipeline().
> > 
> > I would prefer to keep the original code for now
> > (it has some subtle differences).
> 
> Well, if you mean by this the while-loop below, the original code offloads
> the pipeline gradually, stage-wise, until allocation succeeds, in contrast to
> idetape_wait_for_pipeline() which iterates over all pending stages and flushes
> them all in one go.
> 
> At a certain in point in time, however, the driver might land at the unlikely
> state of still having some stages left in the pipeline while queueing all
> incoming requests on the rq queue. Therefore, i'd prefer to make sure the

This is what could happen with the unmodified driver code also.

[ thus given that pipeline code goes away completely soon there is no point
  in changing the original behavior (unless of course it is buggy and I just
  fail to see it) ]

> pipeline is empty before queueing. What is more, it is flushed only once, if
> ever, so idetape_wait_for_pipeline() simply returns in subsequent calls and no
> considerable performance penalties are imposed here.
