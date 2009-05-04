Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbZEDRyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbZEDRyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbZEDRye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:54:34 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36396 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564AbZEDRyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=s38zx/GXae1eNSXK7HjluyTQHem+ahBfEUdvL1aPgbs4p7GPq+5s0XZSp08UckLRWc
         /bB9h6LKVN42Q37GRplv4GjOH6J0ts9NaSxQiRMJYQ+bXaA+xU1lCGk1SpaabqEr1qHw
         HgsnWSE45eukk3q5VcSLFvjnz8CKF22ibuV90=
Message-ID: <49FF2BD4.3070409@googlemail.com>
Date: Mon, 04 May 2009 19:54:28 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Lars Marowsky-Bree <lmb@suse.de>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
References: <20090501061701.GB19234@kroah.com> <20090501065527.GA19773@kroah.com> 	<20090501120359.05bacb48@lxorguk.ukuu.org.uk> <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 	<20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> 	<49FC8EE4.6040408@googlemail.com> <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com> 	<ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com> 	<20090504162011.GO17956@suse.de> <ac3eb2510905040953t29e104eel1f820516195c623a@mail.gmail.com>
In-Reply-To: <ac3eb2510905040953t29e104eel1f820516195c623a@mail.gmail.com>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Kay Sievers wrote:

> The problem is not the missing events, they could be pretty easily
> recovered from sysfs with just another special hack to run at bootup -
> it's the time it takes to bring up the engine to bootstrap /dev, to
> allow us to start any other process which looks for devices. Today,
> udev mounts /dev as a tmpfs, and at that point it is obviously empty,
> and needs to be filled, and nothing else can reliably run at that
> time.

And what about mounting /dev from an already populated image? Or, even
faster, using the /dev directory of the root fs? That way, the device
nodes would be present as soon as / is mounted, without any additional
overhead, except the very first time the system boots (in case you
choose not to populate /dev with a default set of device nodes in advance).

I know, not using tmpfs is a security risk and whatever. But does that
really matter in an embedded system where you have no user accounts?

[...]
>   The plan is to start udevd, but run the coldplug in the background
> and start other stuff in parallel, because you can be sure that all
> currently known devices are already there, and the missing meaningful
> symlinks created by udev will show up soon, along with a new event to
> hook into. There will be no hard checkpoint anymore to wait for the
> basic environment..

You can do that with a persistent /dev as well. It will even keep the
symlinks udev created before the system rebooted. The only drawback is
that you have to wait for device nodes that belong to new devices which
were connected to the system while it was down. But that rarely happens,
and will eventually be fixed by udev.

> The other important reason besides that it saves us from coming up
> with just another custom hack to fill the initial /dev, is that it is
> damn simple and very reliable.

Pardon me, but I have to ask this: Isn't your patch a custom hack, too?

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
