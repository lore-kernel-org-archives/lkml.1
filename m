Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYCNAyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYCNAyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYCNAyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:54:03 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:36183 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751743AbYCNAyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:54:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VZxHrPg95Rh3QZyssXEGIEk7CNVYR9eF7r13t/Nd5LeSSEtvnpfbCvSXza+9pwP1IRZ1F/wrpK4itNVMfC1NShAe88fZ3rseL7P5GbPVgcCHEdzoIqCZofeHInrfwy2ng4g1B1MdwBwkAuTWZpIG8Q00s+pO7exJLrMS9sHptlo=  ;
X-YMail-OSG: AiacctEVM1m.xBP6wbnDDeYPCp3glVuXQ9.gd4bHACOIsf3UvZzBvZQDMxLKFI5yo7WkVNt7mw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.25-rc5 1/2] gpiolib:  dynamic gpio number allocation
Date: Thu, 13 Mar 2008 16:53:58 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com
References: <200803131549.54632.david-b@pacbell.net> <200803131618.58516.david-b@pacbell.net> <20080313162803.ab8bfd4c.akpm@linux-foundation.org>
In-Reply-To: <20080313162803.ab8bfd4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131753.58733.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Andrew Morton wrote:
> On Thu, 13 Mar 2008 15:18:58 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > On Thursday 13 March 2008, Andrew Morton wrote:
> > 
> > > hm.  I suppose that if someone want a huge number of GPIOs then we can
> > > convert this to a bitmap or an IDR tree easily enough.
> > 
> > Actually, I tried IDRs for a while and they broke platforms
> > which needed to initialize and use GPIOs early: before kmalloc
> > would work.  A real PITA that was -- and slow too.
> 
> If IDRs were slow, that linear search will be glacial.

The slowness of IDRs was needing to use them for the
routine lookups ... versus the current array index,
which costs a fraction of an instruction cycle and
doesn't need separate locks.

Or were you implying they should be used for something
other than mapping GPIO numbers to controllers/state?

- Dave
