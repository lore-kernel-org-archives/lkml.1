Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbZKWWD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbZKWWD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZKWWD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:03:58 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:47831 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbZKWWD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:03:57 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: drivers/dma/mv_xor.c: use resource_size()
Date: Mon, 23 Nov 2009 17:04:03 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5C9C@mi8nycmail19.Mi8.com>
In-Reply-To: <200911232234.41411.ioe-lkml@rameria.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/dma/mv_xor.c: use resource_size()
Thread-Index: AcpshL1+adVpMhIkQLWDcQHKsxNnBwAAfyGA
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5BF5@mi8nycmail19.Mi8.com> <200911232234.41411.ioe-lkml@rameria.de>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Ingo Oeser" <ioe-lkml@rameria.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Nov 2009 22:04:02.0548 (UTC) FILETIME=[DDC49340:01CA6C88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 23, 2009 2:35 PM, Ingo Oeser wrote:
> On Monday 23 November 2009, H Hartley Sweeten wrote:
>> Use resource_size() for devm_ioremap.
>
> This pattern foo = do_with_res(res->start, resource_size(res)) seem to happen quite often.
> What about creating inline functions like
> 
> foo = do_with_full_res(res)
> 
> ?
> 
> That would save some code and make it obviously correct.
> 

I thought about that also.  Just not sure what header(s) they would go in.

The most obvious ones I can see are:


static inline struct resource * request_mem_resource(struct resource *res, const char *name)
{
	return request_mem_region(res->start, resource_size(res), name);
}

static void release_mem_resource(struct resource *res)
{
	release_mem_region(res->start, resource_size(res));
}

static void __iomem * ioremap_resource(struct resource *res)
{
	return ioremap(res->start, resource_size(res));
}


There are probably others (devm_request_region, etc.). 

They could also be #define macros.  Not sure which is better.

Regards,
Hartley
