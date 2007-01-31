Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXAaBgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXAaBgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXAaBgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:36:06 -0500
Received: from rtr.ca ([64.26.128.89]:3399 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbXAaBgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:36:05 -0500
Message-ID: <45BFF282.4050305@rtr.ca>
Date: Tue, 30 Jan 2007 20:36:02 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca> <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> First off, please send SCSI patches to the SCSI list:
> <linux-scsi@vger.kernel.org>

Fixed already, thanks!

>> This patch fixes the behaviour to be similar to what we had originally.
>>
>> When a bad sector is encounted, SCSI will now work around it again,
>> failing *only* the bad sector itself.
> 
> Erm, but the corollary is that if we get a large read failure because of
> a bad track, you're going to try and chunk up it a sector at a time

That's better than the huge data-loss scenario that we currently
have for single-sector errors.  MUCH better.

> forcing an individual error for each sector is going to annoy some
> people ... particularly removable medium ones which return this error if
> the medium isn't present ... Are you sure this is really what we want to
> do?

No, for removed-medium everything just fails right away.
This patch is *only* for media errors, not any other failures.

Cheers
