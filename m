Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZAWKrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZAWKrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZAWKrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:47:09 -0500
Received: from ns.firmix.at ([62.141.48.66]:3552 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbZAWKrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:47:08 -0500
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
From: Bernd Petrovitsch <bernd@firmix.at>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, oleg@redhat.com, linux-api@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20090123061557.GM15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net>
	 <20090122065104.2787df2d.akpm@linux-foundation.org>
	 <20090122221500.4c62aa54@tpl>
	 <20090122213105.74142908.akpm@linux-foundation.org>
	 <1232689549.5202.385.camel@calx>
	 <20090123061557.GM15750@one.firstfloor.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 23 Jan 2009 11:45:30 +0100
Message-Id: <1232707530.7914.23.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.087 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.087 required=5
X-Spam-Score: -1.087 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 07:15 +0100, Andi Kleen wrote: 
> > I have to agree with Christoph. The priority here is breaking down the
> > BKL and document all the things being protected by it and we've got a
> > reasonably obvious patch in that direction. Meanwhile, there's not
> > currently a pressing demand to make fasync in particular scale that I'm
> > aware of.
> 
> The classic case is a high throughput network server that uses async
> sockets. It has to call F_SETFL on each new socket it opens.

Am I the only one missing an (additional) socket()-like sys-call with an
additional "flags" argument (somewhat similar to open())?
O_NONBLOCK is another flag that may be set quite often/regularly (at
least in my small world).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


