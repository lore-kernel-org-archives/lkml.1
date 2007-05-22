Return-Path: <linux-kernel-owner+w=401wt.eu-S1765467AbXEVQ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765467AbXEVQ5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbXEVQ5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:57:45 -0400
Received: from outbound-mail-61.bluehost.com ([69.89.21.21]:45556 "HELO
	outbound-mail-61.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757039AbXEVQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:57:45 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Tue, 22 May 2007 09:57:40 -0700
User-Agent: KMail/1.9.6
Cc: Philipp Klaus Krause <pkk@spth.de>, linux-kernel@vger.kernel.org
References: <200705171423.46748.jesse.barnes@intel.com> <1179792587.32247.769.camel@localhost.localdomain> <46531A55.9090403@spth.de>
In-Reply-To: <46531A55.9090403@spth.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705220957.40218.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2007, Philipp Klaus Krause wrote:
> Benjamin Herrenschmidt schrieb:
> >> In collaboration with the FB guys, we've been working on enhancing
> >> the
> >> kernel's graphics subsystem in an attempt to bring some sanity to the
> >> Linux graphics world and avoid the situation we have now where
> >> several
> >> kernel and userspace drivers compete for control of graphics devices.
>
> What's the difference between this and Jon Smirls' proposals from early
> 2005?

There are lots of differences.  From memory, Jon tried to enhance the FB 
layer to do modesetting with an eye toward multiseat support.  Modes were 
set by echoing values into sysfs, and iirc it didn't tie into the DRM 
layer at all or use proper memory management.

These patches use ioctls on the DRM device for modesetting (at least for 
now), and provide userspace with maximum flexibility.  Framebuffer objects 
are allocated using the new DRM memory manager, and any FB devices created 
are slaves of the DRM layer, avoiding some of the fighting over 
suspend/resume and graphics programming.

Many of the aims are the same though, Jon was trying to address many of the 
problems outlined in my initial mail too, we just have different opinions 
about how exactly those problems should be solved. :)

Jesse
