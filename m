Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZEDSzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZEDSzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZEDSzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:55:38 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:50435 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZEDSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UVVYt/mUwIEMU4Q2P0HpcYdSl1tZdLrUVWasuA+ugFneYJriExhK2TEX1Me2Qq5HaD
         3neawb02z7qMgrkvkCq70Dgzke7Y5rPogDR/HBvoGlT44P/VaS4BmADXaA5aH+KYg1Jg
         bvChJcFBJEXRHqFob4vogWxXiVxOTzJqPVg7I=
Message-ID: <49FF3A26.3030407@googlemail.com>
Date: Mon, 04 May 2009 20:55:34 +0200
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
References: <20090501061701.GB19234@kroah.com> <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 	<20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> 	<49FC8EE4.6040408@googlemail.com> <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com> 	<ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com> 	<20090504162011.GO17956@suse.de> <ac3eb2510905040953t29e104eel1f820516195c623a@mail.gmail.com> 	<49FF2BD4.3070409@googlemail.com> <ac3eb2510905041113x58bdb807od7dd4a6ce258e317@mail.gmail.com>
In-Reply-To: <ac3eb2510905041113x58bdb807od7dd4a6ce258e317@mail.gmail.com>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Kay Sievers wrote:
> On Mon, May 4, 2009 at 19:54, Michael Riepe
> <michael.riepe@googlemail.com> wrote:
> 
>>>The problem is not the missing events, they could be pretty easily
>>>recovered from sysfs with just another special hack to run at bootup -
>>>it's the time it takes to bring up the engine to bootstrap /dev, to
>>>allow us to start any other process which looks for devices. Today,
>>>udev mounts /dev as a tmpfs, and at that point it is obviously empty,
>>>and needs to be filled, and nothing else can reliably run at that
>>>time.
>>
>>And what about mounting /dev from an already populated image? Or, even
>>faster, using the /dev directory of the root fs? That way, the device
>>nodes would be present as soon as / is mounted, without any additional
>>overhead, except the very first time the system boots (in case you
>>choose not to populate /dev with a default set of device nodes in advance).
> 
> 
> Dynamic device numbers! A static /dev does not work at all for many
> subsystems, not to mention the risk you take by talking to the wrong
> device pointed to, by your incorrect static device nodes. It's not an
> option at all today, and it will get much worse in the future.

Maybe it's just me, but my devices end up being numbered the same after
every reboot. Unless I add or remove devices to/from the system, of course.

Unfortunately, that doesn't mean that it will always stay that way.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
