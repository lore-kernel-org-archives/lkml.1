Return-Path: <linux-kernel-owner+w=401wt.eu-S967470AbXEHAKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967470AbXEHAKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967464AbXEHAKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:10:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967463AbXEHAKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:10:40 -0400
Message-ID: <463FBF69.3040203@redhat.com>
Date: Mon, 07 May 2007 20:08:09 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 3/6] firewire: char device interface
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <20070502193026.GC1248@infradead.org>
In-Reply-To: <20070502193026.GC1248@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, May 02, 2007 at 02:17:26PM +0200, Stefan Richter wrote:
>> +#include <asm/ioctl.h>
>> +#include <asm/types.h>
> 
> Always use the <linux/ versions.

Fixed.

>> +struct fw_cdev_get_info {
>> +	/* The version field is just a running serial number.  We
>> +	 * never break backwards compatibility.  Userspace passes in
>> +	 * the version it expects and the kernel passes back the
>> +	 * highest version it can provide.  Even if the structs in
>> +	 * this interface are extended in a later version, the kernel
>> +	 * will not copy back more data than what was present in the
>> +	 * interface version userspace expects. */
>> +	__u32 version;
> 
> Please don't even try to build interfaces this complicated.  If your
> current interface needs changes at some point just introduce new ioctls.

Sure, I don't expect a lot of changes anyway, and the few features I know that 
will show up down the road are strictly additions anyway.  I think it makes 
sense to keep the version number there, though, as a way to advertise which 
ioctls are present.

Kristian


