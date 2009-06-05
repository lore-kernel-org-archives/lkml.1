Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZFETyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZFETyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZFETyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:54:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54384 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZFETyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:54:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V2
Date: Fri, 5 Jun 2009 21:54:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, khilman@deeprootsystems.com,
       gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
References: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se> <200906031101.56577.rjw@sisk.pl> <aec7e5c30906042007t26915c05rd8ef375b8d4a353c@mail.gmail.com>
In-Reply-To: <aec7e5c30906042007t26915c05rd8ef375b8d4a353c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906052154.16563.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, Magnus Damm wrote:
> On Wed, Jun 3, 2009 at 6:01 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > On Tuesday 02 June 2009, Magnus Damm wrote:
> >> If you guys dislike adding arch specific data to struct platform
> >> device then for SuperH we can just (mis)use the arch specific data in
> >> struct device instead. I'm afraid that solution wastes memory since
> >> the data will only be used for platform devices anyway. So I prefer
> >> adding arch specific data to struct platform_device instead of struct
> >> device if possible.
> >
> > BTW, what is the difference really?  You can always put
> > dev.platform_data = NULL for devices that don't have any platform data,
> > can't you?
> 
> So the convention is that dev.platform_data points to driver-specific
> data. It may or may not be required by the driver. The format of this
> data is driver specific and should be the same across architectures.
> 
> What I'm trying to add with struct pdev_archdata is a place for
> architecture specific data. This data is needed by architecture
> specific code (for example runtime PM), and since it's architecture
> specific it should _never_ be touched by device driver code. Exactly
> like struct dev_archdata but for platform devices.
> 
> Like I said, we _could_ use struct device for this purpose, but it
> sounds like suboptimal software design to me. Using struct device
> means that we put data where it doesn't belong. I'd like to add
> _platform_ _device_ _specific_ data, not data that should be present
> in all struct devices in the system but only used in some cases.

OK, that explains the idea.  Perhaps it's woth putting into the changelog?

Best,
Rafael
