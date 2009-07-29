Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbZG2VEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbZG2VEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZG2VEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:04:07 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:44437 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZG2VEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=qCwqPzAi/NOnWHbLW8udXbQFhYmfllGvwtuA7CRy9rrckhuafjfO/hZUGU4D+8HEnL
         skEPxbOLiH5i87QH+nX3VClBgcz10It6NuTvkmenQKvzk3cDdKdP8xooBsQ4Eo6cfG+N
         1L0STkAlbZuFQkSaXEcoZnclXZYhDAay10oPM=
Date: Wed, 29 Jul 2009 14:03:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Manuel Lauss <manuel.lauss@gmail.com>,
       Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com> <1248648663.3718.7.camel@green> <1248824367.4112.31.camel@green> <200907292249.47761.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907292249.47761.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090729213756.D23EF526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 10:49:46PM +0200, Rafael J. Wysocki wrote:
> On Wednesday 29 July 2009, Arnaud Faucher wrote:
> 
> > As per the pm.h documentation .thaw is called after RAM image has been
> > created, in order to restore hardware state in case RAM image failed and
> > the system cannot power off.
> 
> That's not correct (please see above).  .thaw() is called after creating the
> image in case .freeze() has changed the state of the device.  This often is not
> necessary, though, so .thaw() may be skipped in many cases.  Of course, you
> should know exactly what you're doing.
> 

Umm, but thaw() _is_ called in case of hibernate failure:

        case PM_EVENT_THAW:
        case PM_EVENT_RECOVER:
                if (ops->thaw) {
                        error = ops->thaw(dev);
                        suspend_report_result(ops->thaw, error);
                }
                break;

so I don't believe you can easily skip thaw() if you have freeze() that
stops/resets device.

-- 
Dmitry
