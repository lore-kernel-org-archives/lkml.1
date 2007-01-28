Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbXA1TrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbXA1TrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXA1TrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:47:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786AbXA1TrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:47:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Xavier Maillard <zedek@gnu.org>
Subject: Re: [Q] Prefered suspend to ram or disk method ?
Date: Sun, 28 Jan 2007 20:47:39 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <23972.1169975356@localhost>
In-Reply-To: <23972.1169975356@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701282047.39997.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 28 January 2007 10:09, Xavier Maillard wrote:
> Hi there,
> 
> Just a quick and easy question for you.
> 
> I am aware of three ways to make my laptop suspend/hibernate:
> 
> 1. suspend
> 2. ususpend
> 3. suspend2
> 
> The first two are directly part of the official linux
> distribution and the third one is easy to install into it.
> 
> Here is my question: what is the recommended method ?

Well, that depends on who you ask. ;-)

> How does suspend compare to ususpend/suspend2 ?

swsusp and ususpend use the same low-level kernel code, so if one of them
works for you, the other should as well.  The difference is mainly that with
swsusp the kernel saves the image into a swap, while with usupend the image
is saved (and loaded on resume) by a userland process.  Additionally, ususpend
can compress and/or encrypt the image, supports suspend-to-disk-and-RAM,
splash-based progress meters and some such.  Gerenally, it adds the features
that, in the opinion of its authors, are better implemented in the userland.
Plus IMHO ususpend's resume is a bit more convenient for calling from within
initrd images.

suspend2 uses some different low-level code, but as far as the stopping of
tasks and handling devices are concerned, it should be equivalent to swsusp
and ususpend.  It generally allows you to create bigger suspend images (the
images created by swsusp and ususpend are at most as large as 50% of RAM),
but it makes some strong assumptions regarding memory management which are
not proven to be always satisfied, although there's no evidence showing
otherwise.  It also implements approximately the same set of additional
features as ususpend, but in the kernel.

> Is there any chance to see suspend2 be part of the official linux
> distribution in a near future or not ?

That's a delicate matter ...

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
