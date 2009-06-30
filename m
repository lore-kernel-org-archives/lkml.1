Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZF3ESw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZF3ESw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 00:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZF3ESn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 00:18:43 -0400
Received: from kroah.org ([198.145.64.141]:36030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZF3ESl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 00:18:41 -0400
Date: Mon, 29 Jun 2009 21:18:33 -0700
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090630041833.GA13034@kroah.com>
References: <20090625220452.GF5540@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625220452.GF5540@const.famille.thibault.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 12:04:52AM +0200, Samuel Thibault wrote:
> Hello,
> 
> Just as a reminder, Speakup is an in-kernel screen reader that uses
> hardware speech synthesis to say what gets printed on the Linux console.
> 
> In the process of cleaning it, we are moving its configuration stuff
> into proper places.  I believe there are two things:
> 
> - per- harware speech synthesizer parameters (e.g. speed, pitch, etc.)
> - screen reading parameters (e.g. characters pronunciation, key_echo,
>   current synthesizer being used etc.)
> 
> Speech synthesizers should probably have their own device class, how
> should it be called? "synth"? "speech"?

Which do you think it should?

> Synthesizers are usually plugged on serial ports, but there is no bus
> abstraction for that, so I believe we can put them in the virtual bus.

That would be fine.

> Then there are the screen reading parameters. I'd tend to think that
> like there are /sys/{block,firmware,fs,power}, there could be a
> /sys/accessibility, or even shorter, /sys/a11y?  Speakup parameters
> could then be in /sys/a11y/speakup?

Wouldn't these be on a "per-screen" basis?  So they would live under the
screen reader device itself, not way up high in the device tree.
Actually, you are proposing them outside of the device tree, which I do
not think you want at all.

What specific files are you thinking you would need?

thanks,

greg k-h
