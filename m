Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbZHLJkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbZHLJkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932351AbZHLJkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:40:03 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:59741 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbZHLJkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:40:01 -0400
Date: Wed, 12 Aug 2009 11:39:49 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090812093949.GB2604@braap.org>
References: <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com> <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org> <4A8133ED.6070304@gefanuc.com> <20090811094025.GC3251@braap.org> <4A81683D.2030408@gefanuc.com> <20090811210146.GB9910@braap.org> <4A827A84.3060906@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A827A84.3060906@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> So it's foolish to have a generic USB layer, or a generic PCI layer or  
> generic "name you bus here" layer?
[ snip ]
> Or it could be layered on top, utilising the the resource management
> that I have proposed and the two can sit together happily
> side-by-side.
> If you are right and that method of access works best, then drivers
> will
> use that rather than requesting resources. If not then the two can
> continue to sit side-by-side. Why make the bridge drivers more complex
> than they need to be?

aagh, please stop this nonsense.

http://lwn.net/Articles/336262/
"Here we see the first reason to dislike midlayers - they encourage
special cases. When writing a midlayer it is impossible to foresee every
possible need that a bottom level driver might have, so it is impossible
to allow for them all in the midlayer. The midlayer could conceivably be
redesigned every time a new requirement came along, but that is unlikely
to be an effective use of time. Instead, special cases tend to grow."

I won't discuss this anymore.

> Unless you provide a consistent API, such as one supporting the features  
> documented in the VME specifications, how are you planning to write  
> drivers that could potentially work on more than one specific bridge?
[ snip ]
> Also, it seems that your API doesn't currently support Location
> Monitors. These are specified in the VME spec, I'd be interested in
> how
> you plan to support this feature in a consistent manner with your
> current API

What I intend to provide is a sane environment to work with VME
devices. The first step is to cover the needs of most use cases:

- 1 master Single Board Computer (SBC) running Linux
- All the other slots have slave devices in them. These devices
  are controlled by kernel drivers on the SBC.
- The SBC does DMA, direct I/O access (mapping) to/from the
  slaves, and handles interrupts from the devices.

Once that's settled we could discuss about further parts of the
spec. But really today getting the above right is _much_ more
important than location monitors support.

E.
