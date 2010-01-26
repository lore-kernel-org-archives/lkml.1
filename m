Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405Ab0AZMSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0AZMSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0AZMSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:18:46 -0500
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:21581 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751425Ab0AZMSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:18:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=P0St5TjwWn438RRVFyn4YeMjzi7h7YNmCg0kDRm11DtNjHpY7F2xu4FQ7xj/9pMXNvST90dYTp2TVvkwklMJptI36se9KZBg3FIoOy5Czii/4mJQdeI3z0bA/0ouI597fnE2mxCvTLCk2LJx37flet/i6KwoW/P6Nw9p5GWfyo0=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: oe5uyDcVM1m4ovsFc7uNt__N_gzFHkA9Hgmdrgg4ss0jhRRy34IaPObTXMTvfsf3gyCx7doyMDrbd1cXDZcAAC0.yOs1wrM11oxbDZQSwPq_k2cvKFz3br..wME7rNTVQAh3uIylRh_a0mB0uBG4whm13UqzXKATLwW3WWnKNezdhj6rN3bzpZdR0Sl9ECBEChBcPr0jUOsC6.gcpnhxguhxPlLvth_DPJWLqbvvq2hugTyXZtqMFJLGM9HhFCIP
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [RFC/PATCH 0/4] twl4030 threaded_irq support
Date: Tue, 26 Jan 2010 04:18:42 -0800
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       "Koskinen Aaro \(Nokia-D/Helsinki\)" <aaro.koskinen@nokia.com>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>
References: <20091212183410.GF3092@sirena.org.uk> <201001252306.55625.david-b@pacbell.net> <20100126110247.GB13062@nokia.com>
In-Reply-To: <20100126110247.GB13062@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001260418.43107.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Felipe Balbi wrote:
> >But nothing in drivers/mfd ... the entry to the whole stack?
> >...
> 
> correct, that's still missing. I tried to play with it for a while, but 
> had to give up due to other musb tasks. So if someone wants to step up 
> and code that part, I'd be glad

I'm quite sure I sent a patch doing that ... sometime early last
summer, when the threaded IRQ stuff was being thrashed out!  (To
show what it'd look like, and see what problems remained.)  That
interface hasn't changed much since then, except for addition of
a stuff like ONESHOT support, set_irq_nested_thread(), and the
bus_lock stuff.  It's surely in LKML archives.  :)

My point here was more like:  these patches shouldn't merge without
that top-level change.  Just switch the whole current structure
(one thread, nesting) over to the now-standard interfaces at the
same time, not incrementally.  Later, the bus_lock stuff can switch
over too (for cleaner mask/unmask).

That's clearly material for 2.6.34 though ...

- Dave

