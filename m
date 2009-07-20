Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZGTPEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZGTPEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZGTPEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:04:50 -0400
Received: from main.gmane.org ([80.91.229.2]:33501 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZGTPEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:04:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Disk access just before shutdown power off.
Date: Mon, 20 Jul 2009 09:06:36 -0600
Message-ID: <4A6487FC.8050300@gmail.com>
References: <4A647277.4000009@superbug.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
In-Reply-To: <4A647277.4000009@superbug.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2009 07:34 AM, James Courtier-Dutton wrote:
> Hi,
>
> When I shutdown my Linux laptop, it does an orderly shutdown with quite
> a lot of HD activity during shutdown which eventually stops when the
> screen goes blank. Then there is some delay (5-10 seconds) and then a
> quick flurry of HD access just before it powers itself off.
> Why is this last bit of HD access needed?
> Surely, if the system is shut down enough to not use the screen any
> more, why does it need the HD?
> I am asking, because it would be nice to disable this need of the HD
> just before it powers itself off. This would allow me to lift up the
> laptop just a bit earlier and place it in my backpack when the screen
> blanks without having to worry about HD failure due to shock.
> I think it would be nicer if the HD would shut itself down just before
> the screen goes blank.

It's not clear exactly what point in the shutdown process the screen 
going blank corresponds to. Do you have the kernel output going to the 
console during the shutdown process? If not, enabling that might be 
useful to tell what's going on.

The last thing the kernel does with the disk before power-off is flush 
the cache and tell it to go into standby mode. It seems like some disks 
are dumb enough to spin up as a result even if there's nothing to flush 
and it was already spun down. Also, in some cases the BIOS decides to 
issue its own such commands after the OS tells it to power down, which 
can have similar results. I believe there's a blacklist of system models 
that are set to skip the kernel standby issuing to avoid the double 
spin-down.

