Return-Path: <linux-kernel-owner+w=401wt.eu-S1423259AbXBUWyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423259AbXBUWyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423268AbXBUWyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:54:53 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:60423 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423259AbXBUWys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:54:48 -0500
From: CIJOML <cijoml@volny.cz>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
Date: Wed, 21 Feb 2007 23:54:38 +0100
User-Agent: KMail/1.9.5
Cc: "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org
References: <200702212313.30359.cijoml@volny.cz> <1172097890.7403.52.camel@violet> <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com>
In-Reply-To: <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702212354.38618.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I need this for differing Option "XkbModel" in Xorg, so I can bind to each
device it's model and has correct xev's scancodes based on model.
So I prefer to have as Phis just only BDADDR, because for me this doesn't make 
sense to have there device to which keyboard connect. Then I should have 1 
section for each receiver, which is stupid.

Section "InputDevice"
        Identifier  "Bluetooth Keyboard"
        Driver      "kbd"
        Option  "Name"  "Bluetooth HID Boot Protocol Device"
        Option  "Phis"        "BDADDR"
        Option      "XkbRules"  "xfree86"
        Option      "XkbModel"  "dinovo"
        Option      "XkbLayout" "us"
EndSection

and so on for every other BT keyboard I own.


Michal

Dne støeda 21 únor 2007 23:48 Dmitry Torokhov napsal(a):
> On 2/21/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> > Hi Dmitry,
> >
> > > > can anybody reply to this and share his/her opinion?
> > >
> > > Input core already exports uniq to udev and also via sysfs.
> >
> > so do you think it would be better to create phys as a string of the
> > source and destination address like "<src>-<dst>" for Bluetooth. And
> > then keep the uniq empty like all USB devices without serial number do?
>
> I'd keep uniq as is and do what you proposed with phys. This way you
> can either use uniq to identify your device while moving it from one
> receiver to another (if you have several) or do exact match on phys to
> get receiver/device pair.
>
> Does this make sense?
