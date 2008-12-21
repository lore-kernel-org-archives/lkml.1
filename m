Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYLURaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYLURaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 12:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbYLURa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 12:30:28 -0500
Received: from twin.jikos.cz ([213.151.79.26]:47322 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYLURa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 12:30:27 -0500
Date: Sun, 21 Dec 2008 18:30:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Parag Warudkar <parag.lkml@gmail.com>
cc: Anssi Hannula <anssi.hannula@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
In-Reply-To: <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>  <20081220221253.e09b1b1f.akpm@linux-foundation.org>  <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>  <494E20F7.7050106@gmail.com>
 <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008, Parag Warudkar wrote:

> > This sounds to me like 'usbmouse' gets used instead of 'usbhid' on
> > 2.6.28-rc9. Many users have reported only vertical movement with
> > 'usbmouse'. Better check the kernel configuration, if you had usbmouse
> > disabled in 2.6.27, then disable it with 2.6.28-rc9 as well.
> Sure enough - rmmod usbhid; modprobe usbmouse reproduces the exact same 
> problem on a working kernel.
> But the thing is I use the same base configuration across all kernels
> I build (sans of course the newly added config options) - so something
> changed somewhere and now usbmouse gets used instead of usbhid.

Could you please

- make sure whether usbhid is used on 2.6.27 to drive the mouse and 
  usbmouse on 2.6.28-rc with the exact same mouse? (either check 
  /sys/bus/usb/devices or even lsusb shouldn't ideally show usbmouse 
  loaded at all)
- if so, make sure that you really need to build usbmouse (please read the 
  help text in Kconfig for explanation)

> What's the deal with usbmouse though - is it supposed to be working or 
> is it considered lost cause in favor of usbhid? May be if people don't 
> need to use it and it is not actively looked into, we can disable/remove 
> it?

Really, please read the help text.

Maybe we should make it dependent on EMBEDDED.

Thanks,

-- 
Jiri Kosina
SUSE Labs

