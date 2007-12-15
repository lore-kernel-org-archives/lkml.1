Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbXLONoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbXLONoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 08:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXLONoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 08:44:07 -0500
Received: from main.gmane.org ([80.91.229.2]:59236 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXLONoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 08:44:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: Reproducible data corruption with sendfile+vsftp - splice regression?
Date: Sat, 15 Dec 2007 14:43:18 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2007.12.15.13.43.18.232625@wizards.de>
References: <pan.2007.11.29.23.42.52.661624@wizards.de> <474FC4D9.3020506@cosmosbay.com> <pan.2007.11.30.09.20.24.737500@wizards.de> <475055EE.9060105@hp.com> <pan.2007.12.02.16.00.03.568000@wizards.de> <pan.2007.12.02.20.49.42.675000@wizards.de> <20071205225429.GA10186@electric-eye.fr.zoreil.com> <pan.2007.12.06.09.28.08.913625@wizards.de> <20071206184426.GA32599@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-174.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2007 19:44:26 +0100, Francois Romieu wrote:

> Holger Hoffstaette <holger@wizards.de> : [...]
>> Maybe turning off sendfile or NAPI just lead to random success - so far
>> it really looks like tso on the r8169 is the common cause.
> 
> TSO on the r8169 is the magic switch but the regression makes imvho more
> sense from a VM pov:
> 
> - the corrupted file has the same size as the expected file
> - the corrupted file exhibits holes which come as a multiple of 4096 bytes
>   (8*4k, 2 places, there may be more)
> - the r8169 driver does not know what a page is
> - the 8169 hardware has a small 8192 bytes Tx buffer
> 
> It would be nice if someone could do a sendfile + vsftp test with TSO on a
> different hardware. While I could not reproduce the corruption when simply
> downloading a file that I had copied on the server with scp, it triggered
> almost immediately after I copied it locally and tried to download the
> copy.

I tested 2.6.24-rc5 on my T60 (Intel e1000 built with NAPI) and installed
vsftp/apache with sendfile and enabled all offload options incl. TSO.
Repeated downloads of >500 MB with ftp or wget over the NIC onto ram- or
physical disk gives no corruption whatsoever. Speed of download to ramdisk
is a nice continuous 125 MB/sec.
Looks like the r8169 or the driver after all..

thanks
Holger


