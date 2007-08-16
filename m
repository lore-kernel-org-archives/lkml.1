Return-Path: <linux-kernel-owner+w=401wt.eu-S1764224AbXHPS46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764224AbXHPS46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 14:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933013AbXHPS4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 14:56:33 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:14748 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741AbXHPS4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 14:56:32 -0400
X-IronPort-AV: i="4.19,272,1183348800"; 
   d="scan'208"; a="48519466:sNHT27132896"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Gerd Hoffmann" <kraxel@redhat.com>
Subject: Re: Early printk behaviour
Date: Thu, 16 Aug 2007 14:56:30 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <46C4009F.9090206@redhat.com>
In-Reply-To: <46C4009F.9090206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708161456.30348.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 16 Aug 2007 18:56:30.0791 (UTC) FILETIME=[28563570:01C7E037]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16 Aug 2007 03:45, Gerd Hoffmann pondered:
> Robin Getz wrote:
> > I was putting together an early printk implementation for the Blackfin, and 
> > was wondering what the expected behaviour was in this situation.
> > 
> > When I set up my bootargs earlyprintk=serial,ttyBF0,57600 and have no console 
> > defined (no graphical console, no serial console).
> > 
> > based on the patch:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69331af79cf29e26d1231152a172a1a10c2df511
> > 
> > which no longer calls disable_early_printk, the earlyprintk console never gets 
> > turned off (because nothing else ever calls register_console). I get 
> > everything out the early console, until the init section is released (where 
> > the console structure is sitting), and it starts printing out garbage.
> > 
> > Is this expected behaviour?
> 
> Hmm, sort of, although I didn't think about the case of no real console
> replacing the early console.  The intention of the patch is to have a
> smooth handover from the boot console to the real console.  And, yes, if
> no real console is ever registered the boot console keeps running ...
> 
> So you can either let it running and *not* mark it __init, so it can
> keep on going without breaking.  Or you can explicitly unregister your
> boot console at some point, maybe using a late_initcall.

Thanks.

Doing things with late_initcall seems to work - is there any problem calling
unregister_console on an already unregistered console? I looked in the code,
and didn't see any nastyness.

-Robin
