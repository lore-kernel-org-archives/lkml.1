Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbXG0SCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbXG0SCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXG0SBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:01:52 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:42720 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbXG0SBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:01:51 -0400
Message-ID: <46AA32C5.9080705@howardsilvan.com>
Date: Fri, 27 Jul 2007 11:00:37 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <46A7FE6A.4030309@howardsilvan.com>	<20070726123420.GA14163@informatik.uni-freiburg.de>	<46A8CB96.1010501@howardsilvan.com>	<20070726174150.4ffcabd4@the-village.bc.nu>	<46A98DFE.3050304@howardsilvan.com> <20070727125655.6a71ab77@the-village.bc.nu>
In-Reply-To: <20070727125655.6a71ab77@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>As the flow control is driven by software on most 16x50 chips (there are
>a couple of exceptions) if we fail to empty the fifo fast enough then any
>flow control will be asserted too late to save the day.
>
>If you stop the application and do the following
>
>	cat /dev/ttywhatever
>	^Z
>	[stopped]
>
>(so you are asking the OS to buffer data but not ever reading it)
>
>and then fire data at it does the flow control eventually occur ?
>

Yes it does appear to.  I told the application to simply sleep(300) at 
the appropriate moment, and I watched the application and when it began 
the sleep I ran:

  cat /dev/ttyS1
  (lots of "garbage" began spewing forth)
  ^Z
  (about 2 or 3 seconds and the RTS light goes dark)

Thanks,

Lee.

