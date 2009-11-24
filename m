Return-Path: <linux-kernel-owner+w=401wt.eu-S934442AbZKXXcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442AbZKXXcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934355AbZKXXcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:32:52 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62396 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934319AbZKXXcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Cd5Vz7EQr/SSYzT6rkb84BuB8pqMLM2l7bmLP8IXO9peKQC0LcCmujuru6xFre2waS
         /+oQZbb/+fpwpQc2t9G5C6LdVoqbgGjymMAk30uDoYzC28EUt5vuqu23N98/vbR5FQbz
         dd1DrHWVhu2s37kpQusU1uT2pvCIy43KG6wLc=
Subject: IR raw input is not sutable for input system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
       Mario Limonciello <superm1@ubuntu.com>, linux-input@vger.kernel.org,
       linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <4B0B6321.3050001@wilsonet.com>
References: <200910200956.33391.jarod@redhat.com>
	 <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	 <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	 <20091123173726.GE17813@core.coreip.homeip.net>
	 <4B0B6321.3050001@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 01:32:51 +0200
Message-ID: <1259105571.28219.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks, I really want to tell everyone that doing all the mapping from
raw codes to keypresses in kernel is wrong.

This idea keeps showing up, because many users think that remotes send
some universal codes that you can just 'parse' and feed back to input
system.

Its not the case.
There are many protocols, I know that by experimenting with my universal
remote. There are many receivers, and all have different accuracy.
Most remotes aren't designed to be used with PC, thus user has to invent
mapping between buttons and actions.
Its is not possible to identify remotes accurately, many remotes send
just a 8 bit integer that specifies the 'model' thus many remotes can
share it.
Some don't send anything.

There are some weird remotes that send whole packet of data will all
kind of states.

Think about it, video capture device is also an input device, a scanner
is an input device too, sound card can work as input device too.
But we aren't doing any parsing, even we don't support deflating of many
proprietary and standard video/image encoding formats.
We let userspace do it.

Kernel job is to take the information from device and present it to
userspace using uniform format, that is kernel does 1:1 translating, but
doesn't parse the data.
Uniform format doesn't mean kernel always converts to one format, its
not like sound card always recording in 32 bit 96000 Khz format, even if
underlying device doesn't support that.


So, device that decode IR code are presented to userspace as pure input
devices. I agree that creating fake raw codes from that is bad.

But devices that send raw data pass it to lirc.
lirc is well capable to decode it, and its not hard to add
auto-detection based on existing configuration drivers, so IR devices
will work with absolutely no configuration.
All you will have to do is ensure that lirc is installed.
Then udev can even start it automatically.
Then as soon as you press a key, lirc can scan its config database, and
find a config file to use. combine that with a GUI for unknown remotes
and you get an awesome usability.

Also don't forget that there are pure userspace drivers. They won't have
access to in-kernel decoder so they will still have to parse protocols,
so will have code duplication, and will still need lirc thus.


So why to burden the kernel with protocols, etc..


Best regards,
Maxim Levitsky



