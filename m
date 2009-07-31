Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbZGaUEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbZGaUEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 16:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZGaUEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 16:04:21 -0400
Received: from smtp.witbe.net ([81.88.96.48]:48685 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZGaUEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 16:04:21 -0400
Date: Fri, 31 Jul 2009 22:03:56 +0200
From: Paul Rolland <rol@as2917.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc4 - slab entry tak_delay_info leaking ???
Message-ID: <20090731220356.4e5c8d0b@tux.DEF.witbe.net>
In-Reply-To: <tnxeiry88w2.fsf@pc1117.cambridge.arm.com>
References: <20090729082047.048ee1a8@tux.DEF.witbe.net>
	<20090730120715.65bf01ff@tux.DEF.witbe.net>
	<20090730122605.465d4f8b@tux.DEF.witbe.net>
	<tnxeiry88w2.fsf@pc1117.cambridge.arm.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.2; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Thu, 30 Jul 2009 16:53:33 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> Paul Rolland <rol@as2917.net> wrote:
> >> On Wed, 29 Jul 2009 08:20:47 +0200
> >> Paul Rolland <rol@as2917.net> wrote:
> >> > Since I'm running 2.6.31-rc? (3 or 4 I think), I often find my
> >> > machine with my X session killed in the morning, and the kdm login
> >> > screen displayed.
> [...]
> > Well, I've killed my X session, and it stopped the "leak"... but
> > didn't recover the "lost" task_delay_info...
> 
> You could try to enable CONFIG_KMEMLEAK and see if you get any leaks
> reported for the "lost" task_delay_info (see Documentation/kmemleak.txt).

I'm now running a kmemleak-eanbled version of the kernel, and waiting for
the same problem to happen again.

In the meantime, my machine is kmemleak-complaining a lot :
Jul 31 20:57:35 tux kernel: kmemleak: 52 new suspected memory leaks
(see /sys/kernel/debug/kmemleak) 
Jul 31 21:07:41 tux kernel: kmemleak: 34 new suspected memory leaks
(see /sys/kernel/debug/kmemleak) 
Jul 31 21:17:47 tux kernel: kmemleak: 23 new suspected memory leaks
(see /sys/kernel/debug/kmemleak) 
Jul 31 21:27:54 tux kernel: kmemleak: 33 new suspected memory leaks
(see /sys/kernel/debug/kmemleak) 
Jul 31 21:38:01 tux kernel: kmemleak: 20 new suspected memory leaks
(see /sys/kernel/debug/kmemleak) 
Jul 31 21:48:07 tux kernel: kmemleak: 21 new suspected memory leaks
(see /sys/kernel/debug/kmemleak) 
Jul 31 21:58:15 tux kernel: kmemleak: 32 new suspected memory leaks 
(see /sys/kernel/debug/kmemleak)
 
What should I do with these reports ? Is there an easy way to check if they
are normal (false-positive) ?

Regards,
Paul

-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un
navigateur "Some people dream of success... while others wake up and work
hard at it" 

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
