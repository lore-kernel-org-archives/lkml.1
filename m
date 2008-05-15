Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYEOTkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYEOTkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYEOTk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:40:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYEOTk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:40:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bill Nottingham <notting@redhat.com>
Subject: Re: Problems with suspend and USB storage
Date: Thu, 15 May 2008 21:40:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Pavel Machek <pavel@ucw.cz>
References: <20080515163315.GA17779@nostromo.devel.redhat.com>
In-Reply-To: <20080515163315.GA17779@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805152140.43292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 of May 2008, Bill Nottingham wrote:
> 
> I've been testing suspend/hibernate with various USB devices under
> 2.6.25.2. Test box is a Thinkpad T60 (uhci, ehci).
> The results are somewhat dismal.
> 
> Using USB as a hibernate device:
> - A directly connected USB stick works OK as a hibernate device
> - A directly connected USB hard drive works OK as a hibernate device
> - A USB stick connected via an ExpressCard reader does not - it appears
>   to just not be there when the hibernate code attemps to write
>   the data.
> 
> On resume (from either hibernate or suspend from RAM):
> - Any 'in use' USB storage, whether it be as swap (a hibernate device),
>   or a mounted filesystem, immediately generates errors on resume. It
>   appears the filesystem and/or swap tasks are woken up before the
>   actual USB device - it enumerates the disks after the errors have
>   already been thrown.
> - As a consequence, the USB devices shift their device names
> - Using USB_PERSIST has no effect on this problem
> - This appears to happen for all USB connection types (hard drive,
>   stick, via ExpressCard reader.)
> 
> Is there any way to get sane behavior out of suspend/resume with
> USB storage?

Well, the problem is that USB storage devices are disconnected during suspend
and hibernation and connected once again during resume.  Then, however, we
are not able to tell whether the device in the slot is the same that was in
there before the system was put into the sleep state.

I'm not sure if there's any workaround available in the current mainline.

Thanks,
Rafael
