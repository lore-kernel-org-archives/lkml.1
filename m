Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbXJIAMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbXJIAMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 20:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXJIAMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 20:12:45 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:42722 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbXJIAMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 20:12:44 -0400
Date: Mon, 8 Oct 2007 17:12:40 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexis Bruemmer <alexisb@us.ibm.com>,
       James Bottomley <james.bottomley@steeleye.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
	if the adapter lacks one
Message-ID: <20071009001240.GA13922@plap3.qlogic.org>
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org> <20071008235009.GB16003@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008235009.GB16003@tree.beaverton.ibm.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 09 Oct 2007 00:11:28.0936 (UTC) FILETIME=[F0670A80:01C80A08]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2007, Darrick J. Wong wrote:

> On Mon, Oct 08, 2007 at 03:48:32PM -0700, Andrew Vasquez wrote:
> 
> > So how about factoring that out to a transport-level interface.  How
> > about something along the lines of the following patch, whereby the
> > software driver upon detecting no valid WWPN, makes an upcall to each
> > interface's 'request_wwn()'.  The data passed in from shost_gendev
> > should be enough for some helper script to cull relevent device bits
> > and perhaps offer some level of persistence...  Off base?
> 
> Hrm... jejb made a remark that it might be better to pass the
> scsi_host's device into request_firmware() as your example does, so I'll
> pitch in a patch to do likewise with libsas--the scsi_host knows the
> actual device it's coming from, and userland can sort that all out later
> anyway via DEVPATH.
> 
> I suppose one could also have multiple scsi_hosts per PCI device, which
> means that my first patch would stumble horribly in more than a few
> cases.

This is done already in the FC case -- NPIV.  Though with that
interface, the administrator is already responsible for assigning
proper WWNN/WWPN during creation.

> > Darrick, forgive the FC example, I don't do SAS...
> 
> That's ok, I don't do FC. :)  Looks mostly good to me...

--
av
