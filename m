Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbXEIV63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbXEIV63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXEIV6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:58:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53438 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbXEIV6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:58:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464243C8.8090503@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 23:57:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] firewire: SBP-2 highlevel driver
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <20070502194408.GD1248@infradead.org> <464237A9.6060301@redhat.com>
In-Reply-To: <464237A9.6060301@redhat.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> Christoph Hellwig wrote:
>>> +static int add_scsi_devices(struct fw_unit *unit)
>>> +{
>>> +    struct sbp2_device *sd = unit->device.driver_data;
>>> +    int retval, lun;
>>> +
>>> +    if (sd->scsi_host != NULL)
>>> +        return 0;
>>> +
>>> +    sd->scsi_host = scsi_host_alloc(&scsi_driver_template,
>>> +                    sizeof(unsigned long));
>>> +    if (sd->scsi_host == NULL) {
>>> +        fw_error("failed to register scsi host\n");
>>> +        return -1;
>>> +    }
>>> +
>>> +    sd->scsi_host->hostdata[0] = (unsigned long)unit;
>>
>> Please take a look ar ther other scsi drivers how this is supposed
>> to be used.
> 
> I was trying to be clever and only allocate the host once the device had
> been discovered and initialized.  I have now changed the code to just
> allocate the host up front and use the hostdata mechanism for the
> sbp2_device struct, which also addresses the host life cycle comments
> below.

I have doubts.  IMO the previous code is 100% correct as long as 1 SBP-2
target LU maps to 1 Scsi_Host.

The lifetime of the Scsi_Host would only be longer than that of the LU
if all LUs (or all LUs at the same initiator port) would be added beneath
the same instance of Scsi_Host.  Then the lifetime of the Scsi_Host would
be that of the fw-sbp2 driver, or that of fw-sbp2's representation of a
FireWire bus.

However, I'll see how it turns out in your update patch.
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
