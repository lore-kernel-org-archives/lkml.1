Return-Path: <linux-kernel-owner+w=401wt.eu-S1030506AbXECIz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbXECIz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXECIz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:55:27 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37740 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030506AbXECIz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:55:26 -0400
Message-ID: <4639A34A.5030904@s5r6.in-berlin.de>
Date: Thu, 03 May 2007 10:54:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/6] firewire: isochronous and asynchronous I/O
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <20070502192904.GB1248@infradead.org> <46392800.4090408@redhat.com>
In-Reply-To: <46392800.4090408@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> Christoph Hellwig wrote:
[...]
>>> +	retval = fw_core_add_descriptor(&model_id_descriptor);
>>> +	BUG_ON(retval < 0);
>> 
>> These kinds of bug checks look wrong.  Either the operations
>> can't fail in which case they should not return an error value
>> or you should handle them properly.
> 
> The fw_core_add_descriptor() checks that the descriptor block it's passed is 
> internally consistent and is used for blocks passed in from userspace too.  In 
> these two cases, the blocks are static const arrays in the driver and if 
> fw_core_add_descriptor returns < 0 it's a bug in the driver.

When you submitted it, I too wondered whether these BUG_ONs are correct
(they are) and whether they are worth having (not so sure).

A plus of a smaller stack is that we need less assertions to guard its
integrity. :-)
-- 
Stefan Richter
-=====-=-=== -=-= ---==
http://arcgraph.de/sr/
