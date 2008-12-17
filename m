Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751616AbYLQT1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbYLQT1h (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYLQT1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:27:14 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:30384 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbYLQT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:27:12 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As0AAO/fSElQyKu8/2dsb2JhbAAIvmdYkSaDBg
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Greg KH <greg@kroah.com>
Subject: Re: [BUG] cdev_put() race condition
Date: Wed, 17 Dec 2008 20:27:13 +0100
User-Agent: KMail/1.9.9
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        v4l <video4linux-list@redhat.com>
References: <200812082156.26522.hverkuil@xs4all.nl> <200812171437.33695.hverkuil@xs4all.nl> <20081217181645.GA26161@kroah.com>
In-Reply-To: <20081217181645.GA26161@kroah.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812172027.13771.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday 17 December 2008, Greg KH wrote:
> On Wed, Dec 17, 2008 at 02:37:33PM +0100, Hans Verkuil wrote:
> > > Again, don't use cdev's reference counting for your own object
> > > lifecycle, it is different and will cause problems, like you have found
> > > out.
> >
> > Sigh. It has nothing to do with how v4l uses it. And to demonstrate this,
> > here is how you reproduce it with the sg module (tested it with my USB
> > harddisk).
> >
> > 1) apply this patch to char_dev.c:
>
> <snip>
>
> Ok, since I can't convince you that using a cdev for your reference
> counting is incorrect, I'll have to go change the cdev code to prevent
> you from doing this :(

Don't give up yet :-)

As v4l isn't the only kernel subsystem wrongly using cdev (Hans showed that sg 
also suffered from race conditions), people seem not to understand cdev 
properly. Maybe you should start by explaining what cdev has been designed to 
handle and how to use it in device drivers (such as sg or v4l) instead of 
telling us what not to do.

> Anyway, do you have a patch for the cdev code to propose how to fix this
> issue you are having?

Regards,

Laurent Pinchart
