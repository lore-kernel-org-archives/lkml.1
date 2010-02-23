Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0BWIDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:03:13 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:33185 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0BWIDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:03:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GUi9Kthkv1vfS5bjKtB7eRvA/ohi5UZj9U3OW6du9E355d7P/VUpw/PyUELqZm7kW/
         m8p/CW15VAN09Q21i43gF3Hjd9N7Gh/0ycSVfiKgxo1cSR2MgqxCnCGVwbj137+TQMkw
         UU81fNkJbYnCKEkNSmbxofolsdDJYocZTWv6s=
Date: Tue, 23 Feb 2010 09:03:08 +0100 (CET)
From: Stefan Achatz <stefan_achatz@web.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       wylda@volny.cz, Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Adding documentation to sysfs attributes of roccat
 kone driver
Message-ID: <31758929.1286552.1266912188132.JavaMail.fmail@mwmweb006>
References: <201002200911.53900.stefan_achatz@web.de>
 <20100222062916.GA2095@core.coreip.homeip.net>
 <alpine.LNX.2.00.1002221100130.30967@pobox.suse.cz>
 <201002221942.04624.erazor_de@users.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201002221942.04624.erazor_de@users.sourceforge.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.5 (--)
X-Spam-Report: Spam Filtering performed by mx.sourceforge.net.
	See http://spamassassin.org/tag/ for more details.
	-1.5 SPF_CHECK_PASS         SPF reports sender host as permitted sender for
	sender-domain
	-0.0 SPF_PASS               SPF: sender matches SPF record
	-0.0 DKIM_VERIFIED          Domain Keys Identified Mail: signature passes
	verification
	0.0 DKIM_SIGNED            Domain Keys Identified Mail: message has a signature
	-1.0 AWL                    AWL: From: address is in the auto white-list
X-Headers-End: 1NjhQP-0004lF-Ed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: normal
Sensitivity: Normal
X-Provags-ID: V01U2FsdGVkX19wblm4zUAjD9XF9uSgRnm0l4ttmpQdhIxP4mL71U+H8dgn9rrOT1OO
 Puwa0eT+i678XZ2rnAv+HpxVY4/brrsRKpmbwwl10TJ1mYxBpn9Lzjhg2qaI3A7G
 VGQ/u9rPORZghvrCux1JnrbA7NEc6jdmxorwTkYEKQL1kbud92JErg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thank you for adding documentation for the sysfs attributes. I have one
> more request though - the documentation adds a lot of anformation about
> whta the fields mean but unfortunately it is silent on _why_ all these
> fields are needed.

> For example, why weight is interesting? Is it just shown just because we can?
> What woudl yuser do with this information? Why would I need to
> manipulate several profiles instead of letting udev configure desired
> state for me every time mouse is plugged into the box? Should not TCU
> calibration be simply performed during driver binding instead of
> on-demand from userspace? And so forth.

I would have done all with libusb in userspace if I had not some problems with it:
- devio wouldn't let me access the mouseprofiles because the manufacturer uses a way to access them check_ctrlrecip() forbids.
- removing usbhid temporarily would render the mouse not responding for the time the action takes.
- readding usbhid is quirky and one needs to replug the mouse if the software fails in some way.

I'm unsure if all this functionality is wanted inside the kernel. This device is Hardware for gamers which i find interesting to be supported by linux also.
In my attempt to raise acceptance for kernel integration i moved all unnecessary functionality like calculating real weight and dpi values into my userland tools to keep only the basic functions in the module.
This driver is available as externally compiled module for some months now, in my eyes its the most elegant (and the only workable) solution and these patches are also an attempt to find out if this project generally has a chance to be integrated in the kernel (but there is also a module for sonys ps3 controller).
There are more devices from this manufacturer which have similar functions like a keyboard with a whole bunch of macro keys where the macros are stored in the keyboard which I find useful as (amateur) programmer and admin.

The weight is really just a "because I can" value.

Switching the profiles is done via software or pressing a button on the mouse and is useful if you wan't to play games with high sensitivity and use a low sensitivity profile for detail work in a graphics application. Also different button mappings (the mouse can play macros with can contain keyboard and mouse button events) are useful for different applications. As example some applications (viewers) do pagescroling with "page up/down" some with arrow keys. You are free to change profiles in the mouse or load new profiles as you like.
You can use a script to backup profiles and load a whole set of specific profiles before starting maybe a game and restore the old profiles on exit.

TCU calibration is only needed if you switch the surface the mouse is being used on. Also you can save and restore already aquired calibration data with the settings attribute without the need of recalibration.

Maybe this answers some of the questions. I'm new to this kernel patching stuff and I might benefit from verbatim questions and statements.
Thanks
Stefan Achatz
___________________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de
