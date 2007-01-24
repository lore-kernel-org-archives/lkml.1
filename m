Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbXAXVfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbXAXVfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbXAXVfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:35:38 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61126 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090AbXAXVfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:35:37 -0500
X-Greylist: delayed 840 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 16:35:36 EST
Message-ID: <45B7CD78.8010907@mit.edu>
Date: Wed, 24 Jan 2007 16:19:52 -0500
From: David Moore <dcm@MIT.EDU>
User-Agent: Thunderbird 1.5.0.8 (X11/20061107)
MIME-Version: 1.0
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>
CC: Pieter Palmers <pieterp@joow.be>, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: In-tree version of new FireWire drivers available
References: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>	<45B75FDB.1000004@joow.be> <59ad55d30701241245l7671af23w3e19a83621c6fb51@mail.gmail.com>
In-Reply-To: <59ad55d30701241245l7671af23w3e19a83621c6fb51@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:

>  - Always allocate a page for headers and a page for the payload.

This method would not really be acceptable as a replacement for 
video1394, since video buffers can often be many tens of megabytes. 
Doubling the space requirement would be a big deal and may cause the 
allocation to fail.

How about this solution:

Give userspace the option of specifying the exact size of the received 
ISO packets.  If userspace provides this, you can allocate the dual 
buffer descriptors appropriately.

If userspace does not know the exact size of the received ISO packets or 
does not specify it, then use dual buffer descriptors for only the first 
packet, and use regular buffer fill for the remaining packets.

I suggest this strategy because I can't think of an application that 
needs all the packet headers, yet doesn't know the exact size of the 
packet.  Is there such an application?

-David
