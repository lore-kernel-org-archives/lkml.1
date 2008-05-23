Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYEWTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYEWTkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbYEWTkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:40:05 -0400
Received: from main.gmane.org ([80.91.229.2]:42969 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbYEWTkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:40:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
Followup-To: gmane.linux.scsi
Date: Fri, 23 May 2008 20:34:25 +0100
Message-ID: <g176e5$6fb$1@ger.gmane.org>
References: <g0mkaf$i1r$1@ger.gmane.org> <20080518021423.3dcf0ddd.akpm@linux-foundation.org> <1211456081.3956.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Cc: linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<posted & mailed>

James Bottomley wrote:

> Actually, I think this is a very subtle bug; what I think is happening
> is that after Hannes sysfs changes, we now add scsi_bus_type to the
> target device.  However, scsi_bus_uevent() unconditionally casts from
> dev to a struct scsi_device and then looks at the type entry.  My theory
> is that in this particular config going from struct scsi_target to
> struct device and back to struct scsi_device actually tips us over into
> unmapped space for the -> type deref.
> 
> Hopefully this should fix it by checking the device type before doing
> the deref.

This fixed the problem for me (it was horribly intermittant but I've done
10+ consecutive reboots without seeing an oopos). I changed the patch to
printk everytime the condition was hit and it seems to happen twice per
PATA device - once after each scsi?: pata_via message and then again after
each scsi 0:0:0:0: Direct-Accesss ATA DISKID etc : 0 ANSI: 5 .

The thing I don't understand about your explanation is that it sounds like
the device struct is being round-tripped (but is just being cast to
different things along the way). If this is the case why would this problem
ever arise? Surely if it is really a struct scsi_device underneath there
should be no problem?

-- 
Sitsofe | http://sucs.org/~sits/

