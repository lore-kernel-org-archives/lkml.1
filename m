Return-Path: <linux-kernel-owner+w=401wt.eu-S934145AbYCDXCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbYCDXCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933031AbYCDXCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:02:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:45137 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765930AbYCDXCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:02:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Ac1PJ+A6T98+M5+BgSdoocopOZ+w1+0FfjwYDkeXmtmWsVIQ/O8w9bf/pvBS6wAYnxfu9eLjsyhP5jzfqQAwX9A3KueV8z+NyrQTjKlaR604RjI1cRp7nPlBkg/o5rAZfLfRzeApRF5qB029bwVVpNfZXyEnSmKRleSgWcb0bXI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: -rc3 regression (was Re: 2.6.25-rc2 + smartd = hang )
Date: Wed, 5 Mar 2008 00:13:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <20080304095701.DDF762DC027@tippex.mynet.homeunix.org> <200803042346.21403.bzolnier@gmail.com>
In-Reply-To: <200803042346.21403.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803050013.39247.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Bartlomiej Zolnierkiewicz wrote:

> I must admit that after auditing the patch & code for n-th time I still fail
> to see the source of the problem (especialy now that the theory about exposing
> races in the tuning code has also failed) as the _only_ changes introduced by
> the guilty commit are that we are using different rq->cmd_type and testing for
> rq->special instead of rq->buffer but both should be NULL. [ as it can be seen
> be looking at ide_cmd_ioctl(), execute_drive_cmd() and ide_end_drive_cmd() ]
> 
> If anybody has some ideas on what could be wrong please help, in the meantime
> I'm going to take a look at smartd code...

This is getting more interesting as smartd doesn't seem to be using "empty"
HDIO_DRIVE_CMD requests at all!

[ IOW the guilty commit should have zero influence on smartd. ]

Anders, could you send me ide-taskfile.s (make drivers/ide/ide-taskfile.s)
from before and after the commit?  Maybe it is simply a compiler bug...

Thanks.
Bart
