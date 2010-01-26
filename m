Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528Ab0AZPVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0AZPVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467Ab0AZPVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:21:31 -0500
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:46225 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754036Ab0AZPVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:21:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vgmeC85EYuE+40+nPF1Dho1dLQvaPwrZBpDHII3eZ/WZ8N70axDwT5WEclpuURPQKZZ2/I+TgqIzxMNQeD4sZUcHxBiZFhA9MzM2aBt6TZPeyUWsgPtD6gyckuHSgLK1AjBe9jNl70vbMx/mkfiF6XE9uhpVViN6x7lCxER/+6c=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: xCSRrfcVM1kzKmzBVLBnvotQD0C.LRQL4qCEtoF4.VszjBW3jtO1QZGV7_Z1U4cNPx.y0mqwK.OKf9ZqPfVhf2UydvpBOdKb4JZqAhRVYGpdaHyxqTWnMWduiC2Zml3Yk7Qs.kbDTSdDIKFDusb2fblVxPWVpmOp2m8vy20DyCX69hxUtazqF0pTjAwPPnvfegnWUMeT50y5n.fR6hgNVi.ruobEMFT5wUibRjb2.oHTWeoWSB.PizV8eGk_G.RMFFC4w.nH6WNzGaC_ab1qmaCwA2kI3OUjIAR7
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Tue, 26 Jan 2010 07:21:28 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <201001260535.21689.david-b@pacbell.net> <20100126141443.GE10690@nokia.com>
In-Reply-To: <20100126141443.GE10690@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201001260721.29275.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Felipe Balbi wrote:
> >
> >Thing is, supplying current is a bit more involved.  If the
> >board can't supply 300 mA, the USB configuration selection
> >mechanism has to know that, so it never selects peripheral
> >configurations which require that much current.
> 
> but that's done already by the usb core, no ? It rules out configuration 
> based on the hub->power_budget (can't remember if the field is that 
> exact name).

Yes, it handles that ... but where does the power budget
come from?  That's what I meant by "more involved".

As in, the host/supplying side of the power equation can't
be event driven like the peripheral/consuming side can.

And that's another reason I think it's best to fully solve
the common (peripheral, recharge-that-batter) case first.

- Dave
