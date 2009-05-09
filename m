Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZEIUV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZEIUV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 16:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbZEIUVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 16:21:15 -0400
Received: from bu3sch.de ([62.75.166.246]:40904 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbZEIUVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 16:21:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <greg@kroah.com>
Subject: Re: DMA debug trace pointing to rtl8187
Date: Sat, 9 May 2009 22:19:39 +0200
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Eric Valette <eric.valette@free.fr>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Hin-Tak Leung <hintak.leung@gmail.com>
References: <49FDB9F8.3080400@free.fr> <4A05BD77.9020003@lwfinger.net> <20090509192959.GA1842@kroah.com>
In-Reply-To: <20090509192959.GA1842@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905092219.40216.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009 21:29:59 Greg KH wrote:
> On Sat, May 09, 2009 at 12:29:27PM -0500, Larry Finger wrote:
> > I think there is a second problem that John's fix does not treat. Although the
> > buffer is removed from the stack, there is no assurance that the buffer obtained
> > with kmalloc() is reachable by DMA. This case will be triggered if the USB
> > adapter does 32-bit DMA and the system has more than 4 GB RAM.

In practice this does not hit, because such systems' kmalloc does not return
memory above 4G (i386) _or_ the DMA mapping functions take care of bounce buffering
or I/O-remapping (should be true for all other arches).
So if the device is able to do DMA with addresses >=32bit it should be fine, provided
it correctly sets the DMA mask.

> Memory returned by kmalloc will always be able to be DMAable.  If not,
> we have lots of problems :)

True for sane devices.
False for devices like Broadcom HND-DMA, which should only be used to slap thy hw engineers.

-- 
Greetings, Michael.
