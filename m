Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbXFZXer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbXFZXer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbXFZXeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:34:36 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:59994 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbXFZXef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:34:35 -0400
Date: Tue, 26 Jun 2007 17:33:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
In-reply-to: <fa.RLNIoDXtVxFnlYMPJh2Q2+yDDOk@ifi.uio.no>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <4681A248.6070109@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.KzVWiacZsGdGiMxLldFOOPOdIEw@ifi.uio.no>
 <fa.TdDfr0FpGG8OjqtqWj6RNRusuU0@ifi.uio.no>
 <fa.qT2j8q7/hQ2xVpeJCg7VGv+FvpI@ifi.uio.no>
 <fa.RLNIoDXtVxFnlYMPJh2Q2+yDDOk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Tue, 2007-06-26 at 19:06 +0200, Rodolfo Giometti wrote:
>> On Tue, Jun 26, 2007 at 11:57:07AM +0100, David Woodhouse wrote:
>>> Your syscalls blindly dereference userspace pointers instead of using
>>> copy_{to,from} user.
>> I use access_ok() to test userspace addresses. It should be ok,
>> shouldn't it?
> 
> No; it's racy. You must use copy_from_user() and copy_to_user().

Not only is it racy, but it doesn't even do all of the checks that 
copy_to/from_user does. access_ok only validates that the region given 
is potentially valid, not that it actually is. Using access_ok only 
allows you to use __copy_to/from_user instead, which skips the same 
checks that access_ok does - not worth it unless you do repeated copies 
to/from the same region of memory.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

