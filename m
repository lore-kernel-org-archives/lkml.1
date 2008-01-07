Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYAGPvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYAGPvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYAGPvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:51:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:47228 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbYAGPvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:51:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=csGSTyI45J9+SOHEGxW0ZXuYOdHK62vLJplXBYb5dpjbp7/pbjn7aAgDl+gDC18zxb8TD45JSdalXE5Zr5HQ9U+Qrjuij0LbLGWfgU5iPrzP0pmjDXNz5Z9nprVl3U3vs7u2y8uTYJ1CvZ5b8Jvdi5oUgMAQ9qzqLO6krKpIDzU=
Message-ID: <d120d5000801070751u29111a75kf52d5cfcc00c94@mail.gmail.com>
Date: Mon, 7 Jan 2008 10:51:28 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: acpi/apm events as inputs: how to handle?
Cc: "Andrey Borzenkov" <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <4782497B.2050306@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <477B5FD8.5070503@msgid.tls.msk.ru>
	 <200801052105.03068.dtor@insightbb.com>
	 <47820224.2020902@msgid.tls.msk.ru>
	 <20080107130332.5973A2D6BF@smtp02.mtu.ru>
	 <d120d5000801070620i1505e697jf73fa001a9c884db@mail.gmail.com>
	 <47823C28.8010800@msgid.tls.msk.ru>
	 <4782497B.2050306@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 10:47 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> Michael Tokarev wrote:
> > Dmitry Torokhov wrote:
> > []
> >>> Well, you use event device in any case; as for finding right one - I guess
> >>> you look at device capabilities and filter what you need ...
> >>>
> >>> {pts/0}%
> >>> cat /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/capabilities/key
> >>> 100000 0 0 0
> >> Exactly. Any driver working through evdev interface should examine
> >> device's capabilities and decide whether it is interested in the
> >> device or not.
> >
> > Ok, got it.
> > But I can't open the device multiple times, can I?
> > Like, there's a daemon listening on volume up/down and other
> > multimedia keys for example, and it can't listen to the same
> > eventX as a daemon that's watching for power/sleep buttons, --
> > instead, they should be combined into the same executable.

No, you can have as many readers as you want. Each of them will get
their copy of event so they can just ignore events they are not
interested in. There was a proposal to allow setting up a filter in
kernel to supress delivery of unwanted events but it is not
implemented yet.

> > Unless there's a way to multiplex the events...
> > (Hmm, this becoming quite... ugly.  Oh well.)
>
> Are the capabilities available over ioctl?  Because if not, it
> really is a problem to find correct /sys file for a given /dev
> node.  I'd rather not scan whole /sys to find the right device... ;)

Yes, they are available through ioctl.

>
> > By the way, where are all the capabilities of input devices
> > documented?
>

include/linux/input.h

> Looked at the code, but it's a bit... difficult to follow, so
> to say.  What is in ../capabilities/keys, for example - is it
> a bitmap of all keys the given event device can produce, based
> on KEY_xxx constants from <linux/input.h> ?
>

Yes.

-- 
Dmitry
