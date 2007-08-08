Return-Path: <linux-kernel-owner+w=401wt.eu-S936159AbXHHPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936159AbXHHPfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932553AbXHHPfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:35:36 -0400
Received: from rtr.ca ([64.26.128.89]:1378 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934768AbXHHPfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:35:34 -0400
Message-ID: <46B9E2C4.7070307@rtr.ca>
Date: Wed, 08 Aug 2007 11:35:32 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
Cc: Tejun Heo <htejun@gmail.com>, Michael Sedkowski <sedmich@gmail.com>,
       trenn@suse.de, Robert Hancock <hancockr@shaw.ca>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>	 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>	 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>	 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>	 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>	 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>	 <46B8140E.3000509@gmail.com>  <1186497925.8780.78.camel@queen.suse.de> <1186514618.5622.9.camel@nx6310> <46B9307D.3000105@gmail.com> <46B9CE79.5030307@rtr.ca> <46B9CFB3.6020402@gmail.com> <46B9D219.6030509@rtr.ca> <46B9DF91.7050709@rtr.ca>
In-Reply-To: <46B9DF91.7050709@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>
> My suspend script now has this little chunk of code at the point
> where it actually does the suspend-to-RAM:
> 
>    sync; sync
>    hdparm -F /dev/sda   ## flush drive write cache
>    sleep 1              ## allow time for the flush to complete
>    echo mem > /sys/power/state  ## suspend-to-RAM
> 
> Without the "sleep 1", it doesn't always eliminate the extra Retract,
> so I hypothesize that the FLUSH_CACHE_EXT command is implemented in
> an asynchronous fashion by the drive:  it returns immediately before
> it has actually completed writing cached data to disk.  The "sleep 1"
> seems to give it enough time to finish up, at least for me.

Further to this, if I have an active-writer running at the time of suspend,
then even my scripted "sleep 1" is not good enough, as additional writes
are still happening before/after the flush.

Now I'll reboot and try it with the "sleep 1" hardcoded inside sd_suspend().

Cheers
