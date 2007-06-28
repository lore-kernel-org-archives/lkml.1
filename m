Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbXF1Vxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbXF1Vxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761868AbXF1Vx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:53:26 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:42611 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760948AbXF1Vx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:53:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cWudFtX6VmX4VNFrvu3Md/13o+lzYRexQL5fx6Iuycio+2GzTten+IdIYQZGQAmEwbNlg4m1UtMh5HME3b9Y2TI7tuGF9Bg4MPKe2B+LeulqZPxOEFwJFoCCxacYmCojLD2yVfht9ZNVgLwrF1WrRaNGT3SFlH8YUXY7ob5noyE=  ;
X-YMail-OSG: BvqrP20VM1muGkoPeRdqMg3p3nnN_h729bTN4UAfOCMWi0zjsGQjhHJbqQiOJQSao.ynbfaosT55Igw3k4_VUs4m1RuCJ1zkDnVRepvIL_waImG9yLg-
From: David Brownell <david-b@pacbell.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCH] PXA27x UDC driver.
Date: Thu, 28 Jun 2007 14:53:22 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>
References: <20070628103619.GW13886@enneenne.com> <989B956029373F45A0B8AF0297081890D834FA@zch01exm26.fsl.freescale.net> <20070628141205.GA13886@enneenne.com>
In-Reply-To: <20070628141205.GA13886@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281453.23414.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007, Rodolfo Giometti wrote:

> As suggest by Leo let me propose to you my new patch for PXA27x UDC
> support.
> 
> Please, let me know what I have to do for kernel inclusion. :)

Let's start with *JUST* a driver, not trying to update everything
else in the USB Gadget stack so that it looks like it's designed
specifically to handle all of Intel's design botches related to
endpoint config ... and work worse for essentially everything else.

(Unlike pretty much every other vendor, Intel wanted hardware config
management.  It was unusably buggy in pxa21x/25x/26x, and not much
better in pxa27x.)


So in technical terms, and to repeat what I've said before:  just
configure it to act more like a PXA 25x chip (no altsettings) and
get it so it passes all the tests [1], modulo errata which have no
workarounds ... then submit that.  No epautoconfig updates, no
patches to every gadget driver to cope with updated autoconfig.

Once there's a basic working no-frills version merged, then we can
talk about whether things in the rest of the stack should change
to accomodate the bizarre concepts of this controller.

- Dave


[1] http://www.linux-usb.org/usbtest/
