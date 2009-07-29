Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZG2X1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZG2X1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 19:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbZG2X1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 19:27:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50037 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbZG2X1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 19:27:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Date: Thu, 30 Jul 2009 01:27:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Manuel Lauss <manuel.lauss@gmail.com>,
       Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com> <200907292249.47761.rjw@sisk.pl> <20090729213756.D23EF526EC9@mailhub.coreip.homeip.net>
In-Reply-To: <20090729213756.D23EF526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907300127.19358.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Dmitry Torokhov wrote:
> On Wed, Jul 29, 2009 at 10:49:46PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday 29 July 2009, Arnaud Faucher wrote:
> > 
> > > As per the pm.h documentation .thaw is called after RAM image has been
> > > created, in order to restore hardware state in case RAM image failed and
> > > the system cannot power off.
> > 
> > That's not correct (please see above).  .thaw() is called after creating the
> > image in case .freeze() has changed the state of the device.  This often is not
> > necessary, though, so .thaw() may be skipped in many cases.  Of course, you
> > should know exactly what you're doing.
> > 
> 
> Umm, but thaw() _is_ called in case of hibernate failure:
> 
>         case PM_EVENT_THAW:
>         case PM_EVENT_RECOVER:
>                 if (ops->thaw) {
>                         error = ops->thaw(dev);
>                         suspend_report_result(ops->thaw, error);
>                 }
>                 break;
> 
> so I don't believe you can easily skip thaw() if you have freeze() that
> stops/resets device.

_RECOVER means "image creation failed or unable to run the image kernel", so
from the devices' point of view it's the same as _THAW.

Still, if your .freeze() modifies the device's registers, then most likely
.thaw() _is_ necessary.

Best,
Rafael
