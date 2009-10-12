Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZJLSeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZJLSeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbZJLSeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:34:01 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:58994 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbZJLSeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QDhzJ9wDKeEPnn/7TJV7MMjMeWBJt2U1ZEB2pGtWzoAyU12ymWPEFD7yrfHrT6gMq6
         FwmYMmHvuXDfOzEycz84ga+kq2siFqw7BhvFhRBVfV0xM3D6jHFSpEA5l+diTAs5eqpX
         IwZJm83v1NYfqU80oAIeil9nUmImqJSoCWLBU=
Date: Mon, 12 Oct 2009 11:33:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
	anymore
Message-ID: <20091012183313.GC8345@core.coreip.homeip.net>
References: <4AD120F2.3020606@tremplin-utc.net> <20091011030029.GA6526@suse.de> <200910112135.29384.dmitry.torokhov@gmail.com> <4AD31709.4000103@tremplin-utc.net> <20091012154846.GB7996@core.coreip.homeip.net> <20091012173551.GC10557@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012173551.GC10557@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:35:51AM -0700, Greg KH wrote:
> On Mon, Oct 12, 2009 at 08:48:46AM -0700, Dmitry Torokhov wrote:
> > > So at least, unbind should fail as well as bind.
> > >
> > 
> > That would be Greg's domain s it is driver core decision whether to
> > allow unbinding platform devices registered with
> > platform_driver_probe().
> 
> No, I do not see why that should not be allowed.
> 

Because once you did unbind the device you are stuck (unless the driver
is compiled as a module, but then you could just unload the module
instead of unbinding). Disallowing unbind would allow discarding not
only __devinit but __devexit sections when driver is built in which
would make ebedded people happy[^Hier].

-- 
Dmitry
