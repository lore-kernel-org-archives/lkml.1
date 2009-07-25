Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbZGYUEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbZGYUEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZGYUEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:04:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55272 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbZGYUEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:04:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Date: Sat, 25 Jul 2009 22:04:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>, linux-kernel@vger.kernel.org,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com> <20090725174311.GB14062@dtor-d630.eng.vmware.com>
In-Reply-To: <20090725174311.GB14062@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252204.44875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Dmitry Torokhov wrote:
> Hi Arnaud,
> 
> On Sat, Jul 25, 2009 at 09:04:51AM -0400, Arnaud Faucher wrote:
> > Gets rid of the following warning:
> > Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
> > 
> 
> Have you tested it with Suspend to disk? You are [potentially] breaking
> it since the new suspend and resume methods are not used by it, it calls
> freeze() and thaw() instead.
> 
> Rafael,
> 
> I wonder if PM core should automatically use suspend()/resume() in place of
> freeze()/thaw() when the latter pair is missing.

Well, in fact it often is not necessary to do .thaw() at all, because the
state of the device doesn't change in .freeze().  Also, PCI drivers should
not need .thaw(), unless they manipulate the standard PM registers of the
device themselves.

That said, if .suspend() is defined, then most probably .freeze() is necessary
as well.  Also, if .resume() is defined, .restore() is most probably necessary
and it should be safe to use .suspend() as .freeze() and .resume() as
.restore().

OTOH, it's really easy to point .restore() to the same routine as .resume()
etc., so I'm not sure.

Best,
Rafael
