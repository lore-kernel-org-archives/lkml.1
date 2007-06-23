Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbXFWBbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbXFWBbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 21:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXFWBbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 21:31:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58979 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbXFWBbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 21:31:37 -0400
X-Sasl-enc: vqsnP2sDt6uSrUwqUiUCGBkyeqFQ9YvPZoTNjSa5gJrH 1182562315
Date: Fri, 22 Jun 2007 22:31:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Carlo Wood <carlo@alinoe.com>, Arjan van de Ven <arjan@infradead.org>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Message-ID: <20070623013132.GA1702@khazad-dum.debian.net>
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <1182397012.2863.0.camel@laptopd505.fenrus.org> <20070622162142.GA603@alinoe.com> <20070622211746.GB21769@khazad-dum.debian.net> <20070622212758.GA6970@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622212758.GA6970@alinoe.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlo!

On Fri, 22 Jun 2007, Carlo Wood wrote:

> On Fri, Jun 22, 2007 at 06:17:46PM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 22 Jun 2007, Carlo Wood wrote:
> > > So far I found out that it's RAID only.
> > 
> > If you change the IO schedulers, does it help?
> 
> How do I do that?

for i in /sys/block/sd*/queue/scheduler ; do echo -n "scheduler for $i was:" ; cat $i ; echo anticipatory > $i ; done

Should show you the scheduler for all libata/scsi discs, and switch to
anticipatory.  It probably works for hd* as well, but I don't have any
around to test.

I had ridiculous md raid performance (on resync) using cfq at least once.
Unfortunately I never bothered trying to track it down, and I didn't check
the throughput after the resync was done either. Also, I don't recall the
kernel version, but it was either 2.6.18 or 2.6.20.

Since it is a very simple test...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
