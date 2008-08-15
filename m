Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYHOCZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYHOCZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYHOCY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:24:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:16511 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYHOCY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fboQHs+6H+eO3oVP0NpGoA49jarthI/DyKmZT1inrzqgVGIvW/FlVtFep76W9yDete
         09gaw993aLCAkCMNT1Ez7XsOSOrA3RwrV/1wwhJ8obK4HKXlTBrWDjzYqDfqfiVeIRl/
         kZzLiaCOwoiu2EgebhCORFeoxHtgf2s9dj/sw=
Date: Thu, 14 Aug 2008 22:24:53 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC]  Resolve 2 year old issue with different demands
	on EVIOCGRAB
Message-ID: <20080815022453.GA9438@anvil.corenet.prv>
References: <18596.58273.713075.332009@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18596.58273.713075.332009@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Fri, Aug 15, 2008 at 12:02:09PM +1000, Neil Brown wrote:
> 
> I'll let the comments in the patch below to most of the talking.
> This came up because I wanted to use EVIOCGRAB in some code on an
> Openmoko Freerunner, and found that EVIOCGRAG does different things on
> that kernel to elsewhere.  I looked into why, and found that there was
> a good reason but that the issues hadn't been completely resolved.  I
> hope to help resolve the issues so that EVIOCGRAB can behave the same
> everywhere, and still meet everybody's needs.
> 
> I would have Cc:ed to Magnus Vigerlof who wrote the original patch on
> which this is based, but his Email address doesn't appear in lkml.org.
> 

I don't think this is a viable solution - there are other "good"
handlers beisdes evdev, such as rfkill-input, which will still get
disabled by the "lightweight" grabs.

Overall I think it is application's responsibility to not use
multiplexing devices if they use evdev, bit I can consider adding a new
interface (maybe another ioctl) that would disable event delivery though
certain interfaces for a device.

-- 
Dmitry
