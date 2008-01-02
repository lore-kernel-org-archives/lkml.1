Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbYABM1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbYABM1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYABM1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:27:42 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29659 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751996AbYABM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:27:41 -0500
Message-ID: <477B8113.6080602@panasas.com>
Date: Wed, 02 Jan 2008 14:18:27 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: do not add new typedefs - is that for real?
References: <477A6732.4010609@panasas.com> <20080102100852.GA19859@infradead.org>
In-Reply-To: <20080102100852.GA19859@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2008 12:18:32.0954 (UTC) FILETIME=[9774ADA0:01C84D39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02 2008 at 12:08 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 01, 2008 at 06:15:46PM +0200, Boaz Harrosh wrote:
>> I have this code:
>>
>> <c_code>
>> /* 
>>  * osd-r10 4.12.5 Data-In and Data-Out buffer offsets
>>  * byte offset = mantissa * (2^(exponent+8))
>>  */
>> typedef __be32 osd_cdb_offset;
> 
> Given that you can't do normal arithmetic on this type it should't
> really be a __be32 but it's own __bitwise type with proper accessors.
There are all the proper accessors, and arithmetic is certainly not possible.

> 
> But yes, this is one of the rare cases where a typedef makes sense,
> but �'d call it osd_off_t or something like that.
> 

You mean osd_cdb_offset_t. I thought of dropping that _t, I hate it,
just a personal preference.

Point taken about the typedef + __bitwise. Because with __bitwise we
tell the compiler that the new type is assembly equivalent to some type
but otherwise un-mixable and unique type. Checkpatch actually allows
it. Code fixed! Thanks Christoph.

Boaz

