Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbZDNSXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbZDNSXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZDNSXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:23:39 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:14761 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZDNSXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:23:38 -0400
Date: Tue, 14 Apr 2009 13:23:37 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML-SCSI <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mike.miller@hp.com
Subject: Re: READ CAPACITY (16) failing
Message-ID: <20090414182337.GA5999@beardog.cca.cpqcorp.net>
References: <20090408194357.GA15043@beardog.cca.cpqcorp.net> <20090408195447.GP20983@parisc-linux.org> <20090410193134.GA2615@beardog.cca.cpqcorp.net> <1239402518.3393.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239402518.3393.9.camel@mulgrave>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 03:28:38PM -0700, James Bottomley wrote:
> > 
> > Why would I never the see the command in the driver?
> 
> Because your devices are reporting compliance to a standard before RC16
> was implemented (we have a check in sd_try_rc16_first() to see if you
> comply to higher than SBC-2).  Then, after you've failed this, if you
> don't return the conventional 0xffffffff to RC10, we never retry with
> RC16.

Thanks, James, that looks like the culprit. The LUN actually reports that it
is a SCSI_SPC_3 device but the controller reports SCSI_UNKNOWN. I'll work
with the firmware guys to fix that.
Oddly enough, others here don't report seeing the same RC16 failure. Gets
better and better.

Thanks,
mikem
