Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115Ab0AZHni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0AZHni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936Ab0AZHnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:43:37 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:47346 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752606Ab0AZHng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:43:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wV474FYBuxX9ktndYB2wP5hd+loQJVDsw5YpP9hML6uWgiXY8JRuofWpcYLU40KAcIUuQw1yINcWDAQOlhE37KobLkm2dyUMvn8pqFe4WVI59nCkQT5F27bR8Z6kLF9uzUQ+noJw9Py6vTWp+36XBvLaN2hdAp3YIW7muy1hLtg=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: _P9Qm1UVM1kkyxF_sl8b1c1Fi8zCh87P9n5RIX6ZLshb.bCoeLNsKat41nVTLY5groR.3ZNEUc9epbpO.Sh2Rjb8Xc0cwMH7FXaJ8hgMdHvBT.LNDoXKewv7NHWZCY4aVIBINRR_pgMLl1EcA2IoRde8CRmxVFjOq4rAIB4ehZracyKUc6HXe31BYcmK3uJoX8ObOFRFK8xMf5QP_F8aRVN0GZm1yl_IIu_ttSbMMJC2e0nI9fMk19hi99XWRNGC
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [RFC/PATCH 0/4] twl4030 threaded_irq support
Date: Mon, 25 Jan 2010 23:36:55 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>
References: <20091212183410.GF3092@sirena.org.uk> <1260786654-13294-1-git-send-email-felipe.balbi@nokia.com> <201001252306.55625.david-b@pacbell.net>
In-Reply-To: <201001252306.55625.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201001252336.55577.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, David Brownell wrote:
> Did the threaded IRQ stuff ever get set up so that the top
> level IRQ thread didn't have to hand off to another thread
> each time?  (That's how the current stuff works.  One thread
> calling out to each handler.)

Yes:  set_irq_nested_thread().  Looks like the toplevel IRQ
demux (in drivers/mfd/twl*irq*c) should use that, along with
the ONESHOT flag and (eventually) bus_lock stuff.

All the key parts that were missing a few years ago now seem
to be present.  But, not yet in use here.  :)

- Dave

