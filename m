Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbXEIWQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbXEIWQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759727AbXEIWQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:16:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759592AbXEIWQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:16:22 -0400
Message-ID: <4642477A.3000801@redhat.com>
Date: Wed, 09 May 2007 18:13:14 -0400
From: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] firewire: SBP-2 highlevel driver
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <20070502194408.GD1248@infradead.org> <464237A9.6060301@redhat.com> <464243C8.8090503@s5r6.in-berlin.de>
In-Reply-To: <464243C8.8090503@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Kristian Høgsberg wrote:
>> I was trying to be clever and only allocate the host once the device had
>> been discovered and initialized.  I have now changed the code to just
>> allocate the host up front and use the hostdata mechanism for the
>> sbp2_device struct, which also addresses the host life cycle comments
>> below.
> 
> I have doubts.  IMO the previous code is 100% correct as long as 1 SBP-2
> target LU maps to 1 Scsi_Host.
> 
> The lifetime of the Scsi_Host would only be longer than that of the LU
> if all LUs (or all LUs at the same initiator port) would be added beneath
> the same instance of Scsi_Host.  Then the lifetime of the Scsi_Host would
> be that of the fw-sbp2 driver, or that of fw-sbp2's representation of a
> FireWire bus.

In the patch, the sbp2_device is now allocated with the scsi_host and is the 
hostdata part of the host struct.  This mean we have to add all the LUs from 
the unit directory corresponding to the sbp2_device struct to that host.  Is 
that a problem?  I think we had this discussion before, but I still don't 
understand why this approach isn't feasible.

Kristian


