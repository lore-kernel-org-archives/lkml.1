Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZLBNba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZLBNba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZLBNb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:31:29 -0500
Received: from verein.lst.de ([213.95.11.210]:36281 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbZLBNb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:31:28 -0500
Date: Wed, 2 Dec 2009 14:30:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Thomas Renninger <trenn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical temperature
Message-ID: <20091202133032.GA9265@lst.de>
References: <20091125102857.GA28310@lst.de> <20091126022311.GB22613@khazad-dum.debian.net> <20091126095202.GA15932@lst.de> <200912021256.21683.trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912021256.21683.trenn@suse.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 12:56:20PM +0100, Thomas Renninger wrote:
> The critical temperature for the shutdown should still be logged in:
> /var/log/messages
> Can you grab that one out, please.

brick:/home/hch# grep "Critical temperature reached" /var/log/kern.log.1 
Nov 23 17:58:27 brick kernel: [  976.674070] Critical temperature reached (100 C), shutting down.
Nov 23 18:05:59 brick kernel: [  411.639261] Critical temperature reached (102 C), shutting down.
Nov 23 22:20:43 brick kernel: [15159.677691] Critical temperature reached (102 C), shutting down.
Nov 25 11:06:33 brick kernel: [10947.132102] Critical temperature reached (103 C), shutting down.
Nov 25 11:53:50 brick kernel: [ 2795.261765] Critical temperature reached (102 C), shutting down.
Nov 25 11:53:55 brick kernel: [ 2800.128671] Critical temperature reached (100 C), shutting down.
Nov 26 11:30:24 brick kernel: [  395.692667] Critical temperature reached (100 C), shutting down.
Nov 27 13:36:18 brick kernel: [  390.408366] Critical temperature reached (100 C), shutting down.

> 
> But from what we know, this sounds like a real overheating and not a
> wrongly read value,

It sounds like that to me, but something in .32-rc causes it to not
throttle early enough.  .31 goes very close to the max all the time, but
something thottles it to not actually go over it.

> Can we be sure it's because of the fans?

No idea, really.  The fan rarely every starts when using .31, but comes
in a lot using .32-rc

> 2.6.31 works?

Yes, perfectly.  Have been running it for a couple of days now again
after I had all these reproducible .32-rc shutdowns when testiong it.

> Also the latest stable one?

Haven't tried that yet, will do if it helps you.

> Then this one might be unrelated (11.2, 2.6.31.X based, Acer Aspire 5315):
> [Bug 557850] System Fan is being stopped on boot, CPU goes overheated and shut down instantly
> https://bugzilla.novell.com/show_bug.cgi?id=557850

Well, I do hear the fan on .32-rc (not on .31 usually).

