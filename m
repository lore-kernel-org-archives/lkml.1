Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYCLOSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYCLOSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYCLOSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:18:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:19613 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbYCLOSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-disposition:message-id:cc:content-type:content-transfer-encoding;
        b=Bnu22UfEemL58LZ2JyE1GJs3oqDiLy5bQ4U5Yk+GwkaiY66qE+K8VFomWfZt5vLXoqmRI5ct1yknDu/WqFh6Z1JWq6QOWv1vldlhyByLZvccXywSUyIYlhJo5DksZ1x+O3HbDAbrC8hWgfb+NijudjdH1tPMejEIVlWnhpS40EA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/4] ide-tape: remove pipeline-specific code from idetape_add_chrdev_write_request
Date: Wed, 12 Mar 2008 15:31:58 +0100
User-Agent: KMail/1.9.9
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <200803110025.19650.bzolnier@gmail.com> <20080312054156.GC4266@gollum.tnic>
In-Reply-To: <20080312054156.GC4266@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803121531.58649.bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Borislav Petkov wrote:

> > > The remaining pipeline stage allocation code is used for the next current
> > > pipeline stage (tape->merge_stage) and data buffer for an upcoming
> > > request. The so allocated pipeline stage is rewired into the tape struct
> > > thru idetape_switch_buffers() and used during the next request for
> > > copying user data into it (see e.g. idetape_chrdev_write()). In case the
> > > allocation fails, the current request is still attempted prior to failing.
> > 
> > Is this really needed now that we've removed pipeline operation for write
> > requests?
> 
> I did this simply to keep behavior changes at minimum - after removing the
> pipeline code completely this'll be simplified too.

BTW I see now how poorly I explained things the last time. :(

[ Sorry for that! ]

Our goal is not "pure" minimal behavior changes but minimal "behavior + code"
changes - IOW we are searching for the best balance for keeping both the old
behavior and code changes (and thus patch _complexity_) at the minimal level.

