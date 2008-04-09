Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbYDIUb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbYDIUb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYDIUbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:31:20 -0400
Received: from blaine.gmane.org ([80.91.229.8]:56014 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbYDIUbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:31:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,631,1199692800"; 
   d="scan'208";a="314240431"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Date: Wed, 9 Apr 2008 11:09:24 -0700
User-Agent: KMail/1.9.9
Cc: Inaky Perez-Gonzalez 
	<public-inaky-VuQAYsv1563Yd54FQh9/CA@hugh.gmane.org>,
       Stephen Hemminger 
	<public-stephen.hemminger-ZtmgI6mnKB3QT0dZR+AlfA@hugh.gmane.org>,
       public-wimax-BPSAo7wm5JOHVYUYWc+uSQ@hugh.gmane.org,
       public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-netdev-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
References: <200804011107.38563.inaky@linux.intel.com> <200804081359.03611.inaky@linux.intel.com> <871w5fpnhs.fsf@basil.nowhere.org>
In-Reply-To: <871w5fpnhs.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804091109.25265.inaky@linux.intel.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-TMDA-Confirmed: Wed, 09 Apr 2008 22:31:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tuesday 08 April 2008, Andi Kleen wrote:

> > version: I anticipate the wimax API exported to user space is
> > going to undergo a lot of changes while we all agree on what
> > is the best interface. Because things might break, I want to
> > make sure user space stuff can detect that and fail cleanly. 
> > Hence the versioning. 
> 
> It's still a bad way to do that (I agree with Stephen on that).
> Was also always a mess on wireless.
> 
> If you don't want expandable TLAs another better alternative to 
> versions is ext2 style compatible/incompatible feature bitmaps.

Ain't that another way of saying versions? Sorry guys, but I am 
having a hard time understanding how the alternatives are better.

Expandable TLAs are fine, until we need to change the meaning of
an existing field/value. Then there is no way to change it without 
breaking existing code other than create a new message. And then 
we have a mess like wireless again. 

With simple versioning, we just bump up the major number and break.
In user space, the libwimax shim library would take care of  hiding
this for the user if so is needed.

-- 
Inaky



