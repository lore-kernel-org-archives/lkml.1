Return-Path: <linux-kernel-owner+w=401wt.eu-S1761584AbXKNRtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761584AbXKNRtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXKNRtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:49:05 -0500
Received: from rtr.ca ([76.10.145.34]:1221 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbXKNRtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:49:04 -0500
Message-ID: <473B350F.3030003@rtr.ca>
Date: Wed, 14 Nov 2007 12:49:03 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B219E.5060508@rtr.ca> <20071114171618.GB9387@section-eight>
In-Reply-To: <20071114171618.GB9387@section-eight>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Kemper wrote:
> On Wed, Nov 14, 2007 at 11:26:06AM -0500, Mark Lord wrote:
>> Another way to the same thing is with "hdparm -E",
>> which contrary to my earlier posting actually does
>> seem to work already with libata.
> 
> Hi!
> 
> There are DVD-ROM drives that don't react to hdparm -E but do react to
> SET_STREAMING, for instance some NEC drives.
..

Mmm.. that's possible.  The NEC drive I have here works with either.

I wonder if an update to sr_select_speed() (inside the SCSI code) is needed?
It currently uses GPCMD_SET_SPEED, with no fallback to GPCMD_SET_STREAMING.

Or I suppose this is best left to userspace.
I may change hdparm to try both opcodes.
