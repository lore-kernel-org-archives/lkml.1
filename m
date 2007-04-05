Return-Path: <linux-kernel-owner+w=401wt.eu-S966074AbXDEKfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966074AbXDEKfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 06:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966077AbXDEKfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 06:35:40 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:37181 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966074AbXDEKfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 06:35:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G48h58Pcdnfx2nliDB1KuFdoLZvYvb8ldNKhWQQ1yK8KnfX08A+fxont5oCtlengtXR5XBhaCrMT0FQXftC0Xxii+GbwghabCmcWcrFjcP4xYmwk/iG7lFQbbsuVtSkXx3wJJgeH0hLx59AKUuF7u76MVjFBqUMERmnUo6mPta0=  ;
X-YMail-OSG: gjLkCbAVM1kJn_hHRlCz01.SL7mEy520TvukGPMeaAiDbPJuYE_hibERnDe0.piW4W9dpld0Cw--
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Thu, 5 Apr 2007 03:35:35 -0700
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linux ACPI list <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200704031741.42273.david-b@pacbell.net> <20070405092638.GA30208@srcf.ucam.org>
In-Reply-To: <20070405092638.GA30208@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704050335.36141.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 2:26 am, Matthew Garrett wrote:
> On Tue, Apr 03, 2007 at 05:41:42PM -0700, David Brownell wrote:
> > This updates /proc/acpi/wakeup to be more informative, primarily by showing
> > the sysfs node associated with each wakeup-enabled device.  Example:
> 
> This looks good. 

Also "good at exposing some puzzling info" ... ;)


> > 	S139	  S4	 disabled  
> 
> Any idea what this one is? There's the potential for all sorts of weird 
> platform devices to expose wakeup capabilities.

My guess is Firewire (IEEE 1394); "F193" on a different system (different
chip vendor) *is* Firewire.  This BIOS seems to have wrongly copied ACPI
tables from a similar system with a fancier southbridge from the same
chip vendor.  (ISTR the vendor's reference design used the fancier chip.)


> > Eventually this file should be removed, but until then it's almost the only
> > way we have to tell how the relevant ACPI tables are broken (and cope).  In
> > that example, two devices don't actually exist (USB3, S139), one can't issue
> > wakeup events (PCI0), and two seem harmlessly (?) confused (MDM and AUD are
> > the same PCI device, but it's the _modem_ that does wake-on-ring).  
> 
> Could the MDM entry be referring to the modem codec on the ac97 or 
> hda bus? 

That's my assumption; yes.   Another system lists "AUD0" and "MODM", but
shows neither as a wakeup device.  As I said, "confused".

- Dave
