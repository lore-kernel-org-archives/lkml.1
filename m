Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZJFNvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZJFNvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbZJFNvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:51:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:38581 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbZJFNvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:51:38 -0400
Subject: Re: [PATCH] scsi_lib.c: sleeping function called from invalid
 context
From: James Bottomley <James.Bottomley@suse.de>
To: iceberg <strakh@ispras.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, eric@andante.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
In-Reply-To: <200910061230.03488.strakh@ispras.ru>
References: <200909231758.47612.strakh@ispras.ru>
	 <200910051835.51891.strakh@ispras.ru>
	 <1254755602.3838.5.camel@mulgrave.site>
	 <200910061230.03488.strakh@ispras.ru>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 13:50:49 +0000
Message-Id: <1254837049.4383.17.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 12:30 +0000, iceberg wrote:
> James, what about code where spin_unlock is called before scsi_device_put, 
> especially for avoiding atomic context?
> In code like 
> 	spin_unlock
> 	scsi_device_put
> 	spin_lock
> Is spin_unlock/spin_lock redundant?

Depends on context ... most of them are actually swapping locks or
providing pre-emption points ... it could be redundant, but doesn't have
to be.

> Why do we need scsi_device_get/scsi_device_put pair in scsi_lib.c at all? If 
> we are sure that scsi_device_put is always not last, for what purpose do we 
> call it together with scsi_device_get in the loop?

We're not sure (and never can be in a hotplug world) that any put isn't
the last one.

James


