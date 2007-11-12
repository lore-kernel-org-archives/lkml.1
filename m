Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbXKLAAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbXKLAAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 19:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbXKLAAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 19:00:09 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:37481 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbXKLAAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 19:00:08 -0500
Subject: Re: [PATCH] Fix problem with size of allocation in libsas
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200711120024.54773.jesper.juhl@gmail.com>
References: <200711120024.54773.jesper.juhl@gmail.com>
Content-Type: text/plain
Date: Sun, 11 Nov 2007 18:00:03 -0600
Message-Id: <1194825603.3445.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-12 at 00:24 +0100, Jesper Juhl wrote:
> From: Jesper Juhl <jesper.juhl@gmail.com>
> 
> in sas_get_phy_change_count(), the line
> 	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
> will allocate 56 bytes due to this define:
> 	#define DISCOVER_RESP_SIZE 56
> But, the struct is actually 60 bytes in size.
> 
> So change the define to be 
> 	#define DISCOVER_RESP_SIZE sizeof(struct smp_resp)
> so we always get the correct size even when people 
> fiddle with the structure.
> 
> This change also fixes the same problem in 
> sas_get_phy_attached_sas_addr()
> 
> (Found by the Coverity checker. Compile tested only)

Well, your fix is definitely wrong.

Could you explain the problem a little more?  The discover response SMP
frame is 56 bytes as mandated by the standard.  I don't see anywhere in
the code where we're actually using a value beyond the 56th byte ...
where is the problem use?

James


