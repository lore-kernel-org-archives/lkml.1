Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816Ab0AZVvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0AZVvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679Ab0AZVvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:51:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60011 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab0AZVvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:51:48 -0500
Message-ID: <4B5F6299.6090903@zytor.com>
Date: Tue, 26 Jan 2010 13:46:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
References: <201001240055.59479.rjw@sisk.pl> <201001252254.37635.rjw@sisk.pl> <20100126141726.GA1437@ucw.cz> <201001261947.46015.rjw@sisk.pl> <20100126145842.GA11295@ucw.cz>
In-Reply-To: <20100126145842.GA11295@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 06:58 AM, Pavel Machek wrote:
>>
>> That would have to be done using suspend notifiers and should depend on what
>> driver actually controls the screen at the moment.  And I guess the only case
>> in which we actually _need_ to do the kernel VT switch is when the hardware
>> is controlled by X and without KMS.
> 
> We need vt switch when display is controlled by userland app directly
> accessing hw. It may or may not be X (svgalib anyone?,
> gtk-on-framebuffer? qtopia?).
> 
> Ideally, userspace should explicitely tell us. KD_KERNEL_GRAPHICS
> console mode?
> 

It seems that the kernel would already know if it's in control of the
mode switch, no?  If userspace ever takes control and it doesn't already
notify the kernel that it is taking over, we would seem to have a much
bigger problem...

> Plus the switch is needed for any graphics app using fbcon -- I do not
> think we actually save the framebuffer over suspend. (This one should
> probably be fixed).

Quite.

	-hpa

