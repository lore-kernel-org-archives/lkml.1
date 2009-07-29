Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZG2Wxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZG2Wxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 18:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZG2Wxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 18:53:54 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:59285 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZG2Wxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 18:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a+22HN6xeqKep8PqMI9+RsZapCrqRnP2nIV5iPyw3pNNBPVwlBRYtW7kUT/tbgvllw
         iEo3P3PlBX1fmztyOrYQrH/CvKHZUbiby4/KJvrFP/tH180GTvqP2VysO2h+7B0lZAWK
         DW07p9DyzJNSnLd3/q0gAotD5y5qGg2BBYaPM=
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Manuel Lauss <manuel.lauss@gmail.com>,
       Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090729213756.D23EF526EC9@mailhub.coreip.homeip.net>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
	 <1248648663.3718.7.camel@green> <1248824367.4112.31.camel@green>
	 <200907292249.47761.rjw@sisk.pl>
	 <20090729213756.D23EF526EC9@mailhub.coreip.homeip.net>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 18:53:45 -0400
Message-Id: <1248908025.3998.15.camel@green>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 14:03 -0700, Dmitry Torokhov wrote:
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
> 

As of today, acer_platform_freeze() does not stop/reset any device, so,
I agree with Rafael that for acer-wmi, .thaw() can be skipped. I had
also tested this configuration and it was working like the non-patched
code.

Carlos, do you think that any acer-specific hardware could be switched
off or reset inside acer_platform_freeze() ? If this was the case, we
would have to wire .thaw()...

