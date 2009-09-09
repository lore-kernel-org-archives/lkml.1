Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZIIWM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZIIWM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 18:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZIIWM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 18:12:26 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:55618 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZIIWM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 18:12:26 -0400
X-Greylist: delayed 4299 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 18:12:25 EDT
Message-ID: <4AA8284A.3010908@codemonkey.ws>
Date: Wed, 09 Sep 2009 17:12:26 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: akataria@vmware.com
CC: James Bottomley <James.Bottomley@suse.de>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Brian King <brking@linux.vnet.ibm.com>,
       "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>	 <4AA8177A.2020606@codemonkey.ws> <1252533093.24633.40.camel@ank32.eng.vmware.com>
In-Reply-To: <1252533093.24633.40.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> I see your point, but the ring logic or the ABI that we use to
> communicate between the hypervisor and guest is not shared between our
> storage and network drivers. As a result, I don't see any benefit of
> separating out this ring handling mechanism, on the contrary it might
> just add some overhead of translating between various layers for our
> SCSI driver.
>   

But if you separate out the ring logic, it allows the scsi logic to be 
shared by other paravirtual device drivers.  This is significant and 
important from a Linux point of view.

There is almost nothing vmware specific about the vast majority of your 
code.  If you split out the scsi logic, then you will receive help 
debugging, adding future features, and improving performance from other 
folks interested in this.  In the long term, it will make your life 
much, much easier by making the driver relevant to a wider audience :-)

> Having said that, I will like to add that yes if in some future
> iteration of our paravirtualized drivers, if we decide to share this
> ring mechanism for our various device drivers this might be an
> interesting proposition. 
>   

I am certainly not the block subsystem maintainer, but I'd hate to see 
this merged without any attempt at making the code more reusable.  If 
adding the virtio layering is going to somehow hurt performance, break 
your ABI, or in some way limit you, then that's something to certainly 
discuss and would be valid concerns.  That said, I don't think it's a 
huge change to your current patch and I don't see any obvious problems 
it would cause.

Regards,

Anthony Liguori
