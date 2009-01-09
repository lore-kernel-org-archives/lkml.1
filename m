Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbZAIVgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbZAIVgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbZAIVfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:35:17 -0500
Received: from ns.suse.de ([195.135.220.2]:56426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976AbZAIVfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:35:15 -0500
Date: Fri, 9 Jan 2009 13:34:03 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: post 2.6.28 regression: device_initialize() now sleeps, and
	may fail without recovery strategy
Message-ID: <20090109213403.GA26754@suse.de>
References: <496798FE.8030900@s5r6.in-berlin.de> <20090109205633.GB19904@suse.de> <4967BE13.6070003@s5r6.in-berlin.de> <4967BF99.7010507@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967BF99.7010507@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 10:20:25PM +0100, Stefan Richter wrote:
> Stefan Richter wrote:
> > Greg KH wrote:
> >> I originally looked at changing this to be at device_add time, but I
> >> think there are some code paths that do device_initialize and then do
> >> some operations on the device before calling device_add.
> > 
> > get_device() and put_device() seem to be about the only things that are
> > interesting before device_add().
> > 
> > Don't know if a final put_device() in this situation
> 
> ...would require dev->p to be present.

But that can be easily handled...

give me a short while to test...

thanks,

greg k-h
