Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZBPQRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZBPQRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZBPQRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:17:45 -0500
Received: from hermes.cicese.mx ([158.97.1.34]:60002 "EHLO hermes.cicese.mx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZBPQRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:17:45 -0500
From: Serguei Miridonov <mirsev@cicese.mx>
To: Tejun Heo <tj@kernel.org>
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
Date: Mon, 16 Feb 2009 08:17:16 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27.12-170.2.5.fc10.i686; KDE/4.2.0; i686; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
References: <200902141206.06419.mirsev@cicese.mx> <4998593D.2050300@gmail.com> <4998CB34.6090300@kernel.org>
In-Reply-To: <4998CB34.6090300@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902160817.16614.mirsev@cicese.mx>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (hermes.cicese.mx [158.97.1.34]); Mon, 16 Feb 2009 08:17:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sunday 15 February 2009, Tejun Heo wrote:
> Please try shorter (or different) cable. 

I will, in a few days, may be.

> >> I agree with you completely. Nevertheless, something like 10
> >> errors per 2GB transfer can not be the reason to give up. Vista,
> >> at least, recovers and continues the data transfer. Linux simply
> >> can not return the interface or connected device into operating
> >> mode. Do you think it is normal?
>
> Well, there isn't much point in keeping retrying if the same
> command fails consecutively. 

I'm not talking about the _same_ transfer command. I mean intermittent 
errors, average 10 parity errors per 2GB file. Let me repeat myself 
from another post:

... my very strong opinion based just on general physics is that 
error rate on SATA can be (and will be) much higher than that one on 
PATA. PATA operates at lower frequencies and cables are much shorter. 
eSATA cables are longer and work at up to 3Gb/s. Moreover, consider 
all these consumer-grade connectors, cables, etc. So, CRC errors could 
be quite common and software needs to handle them properly to keep 
transfers fast and maintain the communication with a device.

And, remember USB bulk transfer? Who is taking care on CRC check and 
retries there?

> The problem was the broken speed down
> logic, so all the retries failed and FS eventually received IO
> failure.  Should have been fixed with recent changes.

Slow down may help to reduce amount of errors but it may happen that 
they can not be avoided completely.

> In the log, ata2.00 went down after a timeout.  The reset per-se
> isn't the problem and is the RTTD after a timeout as the controller
> and device states are unknown.  The situations like yours in the
> log often happens because an ATAPI device shuts down completely
> after certain transmission problems.  When this happens, there's
> nothing much the driver can do and soft reboot wouldn't recover the
> device either.

So, this is the kernel job to keep things working, not break them :-)

> But seeing you're on dv5, I think you might be experiencing
> something else.  Please take a look at the following bz.
>
>   http://bugzilla.kernel.org/show_bug.cgi?id=12276

Yes, I tried to suspend to RAM and when the laptop waked up it failed 
to communicate with the hard drive. So, I use hibernate instead.

> ... I'm trying to
> contact HP about this but hasn't gotten anywhere yet.

Please, let us know if they reply. 

Thank you.



