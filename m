Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZEZPeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZEZPeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZEZPeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:34:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41315 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbZEZPeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:34:23 -0400
Subject: Re: Bug in SCSI async probing
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905261040230.5554-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0905261040230.5554-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 10:34:23 -0500
Message-Id: <1243352063.2815.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 11:22 -0400, Alan Stern wrote:
> James & Arjan:
> 
> Am I missing something here?  It looks like
> 
> 	fastboot: make scsi probes asynchronous
> 
> has introduced a bug in the sd probing code.  AFAICT, there is now
> nothing to prevent do_scan_async() from returning before
> sd_probe_async() has run.

True, but this isn't really a problem.

> Doesn't this mean that there's nothing to prevent sd_remove() from 
> being called and trying to unregister the disk _before_ 
> sd_probe_async() has managed to register it?

Yes, we've been discussing this ... most of the removal functions now
need async_synchronize calls to mitigate this type of race.

James


