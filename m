Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZHJQgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZHJQgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbZHJQgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:36:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59603 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbZHJQgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:36:01 -0400
Date: Mon, 10 Aug 2009 17:35:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Brian Swetland <swetland@google.com>
Cc: avorontsov@ru.mvista.com, Pavel Machek <pavel@ucw.cz>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: power_supply class/framework question
Message-ID: <20090810163542.GC24947@sirena.org.uk>
References: <a55d774e0908071919s7b365f84o3baa19c8d6fbe899@mail.gmail.com> <20090810150011.GA1471@ucw.cz> <20090810152825.GA4624@oksana.dev.rtsoft.ru> <a55d774e0908100914h6a42546fk47cdb207628ebe5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0908100914h6a42546fk47cdb207628ebe5e@mail.gmail.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 09:14:01AM -0700, Brian Swetland wrote:
> On Mon, Aug 10, 2009 at 8:28 AM, Anton
> Vorontsov<avorontsov@ru.mvista.com> wrote:

> > Or enum power_supply_type, with the following priority:
> > mains (wall), usb, battery?

> Either of those would work, though in the case of USB, as Pavel
> correctly points out, we'd need to differentiate between

I think we'll need to be able to report a list of supplies rather than
just one - for example, a lot of battery operated devices will use a
combination of USB and battery if the current draw exceeds what the USB
supply is able to deliver.

> non-enumerated and enumerated, so perhaps max available milliamps
> would be best.  Or USB could just not indicate that it's supplied
> until after enumeration is successful.

The 100mA from an unconfigured USB supply may still be a reasonable
proportion of the power that the device needs in some situations -
things like backlights and radios aren't going to be a good idea but
other things don't burn quite so much power.

USB also has some other current limit options which can be configured
(and sometimes people arrange for special hardware which provides limits
completely out of spec).
