Return-Path: <linux-kernel-owner+w=401wt.eu-S1032044AbXEHVl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032044AbXEHVl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031994AbXEHVlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:41:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58694
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031927AbXEHVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:41:54 -0400
Date: Tue, 08 May 2007 14:41:54 -0700 (PDT)
Message-Id: <20070508.144154.31643026.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: cornelia.huck@de.ibm.com, bunk@stusta.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
References: <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 May 2007 13:01:21 -0700 (PDT)

> In fact, there is nothing wrong with having *both* a synchronous part, and 
> an async part:
> 
> 	.probe = mydriver_setup,
> 	.probe_async = mydriver_spin_up_and_probe_devices,
 ...
> Hmm? Would something like this work? I dunno, but it seems a hell of a lot 
> safer and more capable than the aborted PCI multithreaded probing that was 
> an "all or nothing" approach.

I definitely agree that we need a transitonary approach to this.

Although I kind of preferred the idea you mentioned where the
device could launch the asynchronous probe and just return from
the normal ->probe() immediately.

This might get tricky if the callers do some kind of reference
counting or other resource management based upon the ->probe()
return value since it wouldn't know what happened to the
launched asynchronous probe when it returns from ->probe().
