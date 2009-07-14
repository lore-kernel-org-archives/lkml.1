Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZGNXRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZGNXRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 19:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZGNXRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 19:17:39 -0400
Received: from smtp.it4linux.de ([212.112.238.121]:54201 "EHLO
	smtp.it4linux.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbZGNXRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 19:17:38 -0400
X-Greylist: delayed 865 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 19:17:38 EDT
Message-ID: <4A5D0D49.60402@pirsoft.de>
Date: Wed, 15 Jul 2009 00:57:13 +0200
From: Pierre Willenbrock <pierre@pirsoft.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.21) Gecko/20090517 SeaMonkey/1.1.16 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
References: <20090711191556.GA3845@localdomain.by> <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk> <20090711235530.GA3231@localdomain.by> <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk> <20090714162837.GC3145@localdomain.by>
In-Reply-To: <20090714162837.GC3145@localdomain.by>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky schrieb:
> Hello Alan,
> I'm having another problem which I guess may be caused by pty/tty changes.
> The problem is that ppp connection constantly hangups under load (downloading) 
> (it works perfectly with 30 kernel).
> 
> syslog:
> pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
> pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
> pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
> pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
> pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
> pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
> pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
> pptp[1942]: anon log[logecho:pptp_ctrl.c:677]: Echo Request received.
> pptp[1942]: anon log[ctrlp_rep:pptp_ctrl.c:251]: Sent control packet type is 6 'Echo-Reply' 
> pppd[1929]: No response to 4 echo-requests
> pppd[1929]: Serial link appears to be disconnected.
> pppd[1929]: Connect time 8.5 minutes.
> 
> In average it works ~10 minutes. 
> I did "strace -ff -F -tt -s 200 -o ... pon ..." which produced 11MiB and 46 files (it'll take some time to dig).
> Do you have any ability to test ppp under load?
> 
> 	Sergey

Hello everyone,

I can reproduce this in mere seconds, using an otherwise idle ppp link
and ping -f -s256 -l256.
Usually, the first batch of packets hangs the pty, but if the link is
not entirely idle, the ping may work for a few more seconds. In fact,
bisect points to commit d945cb9cce20ac7143c2de8d88b187f62db99bdc ("pty:
Rework the pty layer to use the normal buffering logic").

Regards,
  Pierre
