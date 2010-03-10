Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab0CJLB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:01:57 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:57796 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755698Ab0CJLB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:01:56 -0500
X-IronPort-AV: E=Sophos;i="4.49,613,1262559600"; 
   d="scan'208";a="54342932"
Date: Wed, 10 Mar 2010 12:01:53 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, lenz@cs.wisc.edu,
       rpurdie@openedhand.com
Subject: Re: private field in led_classdev?
Message-ID: <20100310110153.GA6838@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	lenz@cs.wisc.edu, rpurdie@openedhand.com
References: <20100307143112.GC5203@const.famille.thibault.fr> <20100310025411.GD26642@kroah.com> <20100310094452.GA5702@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100310094452.GA5702@const.bordeaux.inria.fr>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Wed 10 Mar 2010 10:44:52 +0100, a écrit :
> Greg KH, le Tue 09 Mar 2010 18:54:11 -0800, a écrit :
> > On Sun, Mar 07, 2010 at 03:31:12PM +0100, Samuel Thibault wrote:
> > > Would there be an objection to adding a void *private field to the
> > > led_classdev struct?  It would be a lot less burden for the input
> > > key board leds support for finding out the keyboard device from the
> > > brightness_set callback, as each device may have a long series of leds,
> > > not just a fixed number of them.
> > 
> > What's wrong with using the private pointer in the struct device
> > instead?
> 
> Ah, right. In my case there is a struct device corresponding to the
> actual input device. I hadn't realized that since registering a led
> creates a new device, I have another private pointer which I can use.

One issue, however, is that led_classdev_register() calls
led_trigger_set_default(), which eventually calls the brightness_set
hook, but the private field (platform_data) still hasn't been
initialized, so the brightness_set hook has to abort setting the initial
state. In my case, after led_classdev_register and setting
platform_data, I can call the low level function by hand, it's just not
very pretty...

Samuel
