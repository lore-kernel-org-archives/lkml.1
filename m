Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZKQWMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZKQWMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZKQWMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:12:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbZKQWMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:12:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Null suspend/resume functions
Date: Tue, 17 Nov 2009 23:14:04 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       alsa-devel@alsa-project.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com> <aec7e5c30911170446n71031671i48aca11f5276405d@mail.gmail.com> <20091117125901.GF823@rakim.wolfsonmicro.main>
In-Reply-To: <20091117125901.GF823@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172314.04396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Mark Brown wrote:
> On Tue, Nov 17, 2009 at 09:46:35PM +0900, Magnus Damm wrote:
> 
> > On SuperH we have Runtime PM enabled on a few platforms together with
> > a few updated drivers. The latest driver to become more power aware is
> > this FSI driver.
> 
> I understand exactly what the runtime PM stuff and the driver are doing
> here, the issue is the mandatory suspend and resume functions.
> 
> > At this point the SuperH specific platform bus code requires the
> > callbacks ->runtime_suspend() and ->runtime_resume() to be present. It
> > may be a good idea to allow them to be NULL in the future or maybe
> > having some shared functions, but before starting to break out stuff
> > I'd like to see how other Runtime PM implementations deal with this.
> > So unless people object I prefer to keep it as-is for now.
> 
> What is the reason for requiring that the driver provide stub functions?
> For me the issue is that if it's mandatory for the driver to provide the
> functions then having stub functions in there makes the driver look like
> it is abusing the API by not implementing mandatory functionality.

In fact, it's not mandatory for bus types, not for drivers.  IMO bus types
really have to know how to suspend a device and how to resume it,
otherwise the core framework won't be useful anyway.  What the bus type does
about drivers not implementing ->runtime_suspend() or ->runtime_resume(), it's
up to the bus type.  That's even documented IIRC.

Thanks,
Rafael
