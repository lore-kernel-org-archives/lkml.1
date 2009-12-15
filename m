Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbZLOOBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbZLOOBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbZLOOBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:01:45 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56587 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247AbZLOOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=thKPXbzoIdpHKT8VG/IJ5ME20kJNkQrSJfaMvD/xOi6esmRIo3p57FeHuRz6mD8PpA
         ELqikdZUsgdEZQWSGxPzFN+XsFnXJzZOaR2o3e4qmsKkck9GZxo7NqqkFqjTLmNr8PYH
         KVa0/fgfPxulKpqGO7n5lDbx37iNqUKYv1DMg=
Date: Tue, 15 Dec 2009 15:01:37 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Josua Dietze <digidietze@draisberghof.de>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091215150137.46bd9817@strolchi.home.s3e.de>
In-Reply-To: <4B278191.1010009@draisberghof.de>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
	<4B278191.1010009@draisberghof.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.1; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 Dec 2009 13:31:13 +0100
Josua Dietze <digidietze@draisberghof.de> wrote:

> Stefan Seyfried schrieb:
> 
> > The USB ID claimed by zd1211rw for the fake storage device is
> > also in use by other, non-zd1211rw devices (Sphairon Homelink
> > 1202). Move the eject of these devices to where it belongs and
> > where all the needed infrastructure already exists: usb-storage.
> 
> We can do the eject (as other mode switches) in userspace. Previous 
> discussions pointed into that direction.

Well, the zd1211rw already did that, I wanted to fix that up and was
told to do it in usb-storage instead (which, looking at the diffstat,
seems like a good idea).

> And there is always the question of being able to access the "fake 
> CD-ROM" without hacking the kernel.

I was thinking that I would be able to achieve that by echoing an
appropriate quirk into /sys/module/usb-storage/parameters/quirks,
however, I could not get it to *not* eject the device.
But given that there is already an "option_zero_cd" parameter in
usb-storage, it should be easy to massage this into a general "do not
eject virtual installer media" flag so that people are still able to
get the windows driver files off their devices should they need to do
so.

> I'd like to see these devices removed from unusual_devs.h.

I'd like them to work with one driver, not two (one in kernel and one
in userspace).

That's a fundamental difference in opinions, and I fear I'm not the one
who is going to decice how this will be handled ;)

Have fun,

	Stefan
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
