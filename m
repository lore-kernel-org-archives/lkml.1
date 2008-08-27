Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYH0HYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYH0HYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYH0HYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:24:09 -0400
Received: from web33204.mail.mud.yahoo.com ([209.191.69.152]:44516 "HELO
	web33204.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751476AbYH0HYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:24:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=Jqf5t77XaYLugr61mWYfFpYw1AqXVtetrHHLL0tvSH1HUCP8DN/cabhHi7iA2igQvn9wlpIqJtca6ibBws5E7cEXHAnVA8GtpCst7qlBI34zhx/tVzOVwTdOc3CBogvz8bUi/05UM0/TewDoshBPgChIJSrdn2D/4c42NklbqLY=;
X-YMail-OSG: ZylV4pcVM1nQ3.idFEWnqCv6JEQ4Q059IBrehwcGp_9sysYN5t_TivaLilDCi6ndOBo0sqyEMYnyN3tN4Dsw7PW6vEWcn9rWd4ZlBISERHtuAXtFoKDU2BQJe0GuBnYlrq4-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Wed, 27 Aug 2008 00:24:07 -0700 (PDT)
From: jassi brar <jassi_singh_brar@yahoo.com>
Reply-To: jassi_singh_brar@yahoo.com
Subject: Re: An idea .... with code
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <87tzd89oap.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <348573.4171.qm@web33204.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Before starting i would like to point out the 'philosophy' behind the idea.

Exceptions(special cases) make for entropy and hence complexity. Generalization keeps uniformity and hences Order and Ease.
We can't escape 'entropy' when emulating something that it is actually not, nevertheless we can minimize it by introducing as least and as localized changes as possible.
My idea congregates only determining changes at the lowest level(driver), unlike the respectable LOOP driver which hardcodes limits and adds to the entropy(new ioctls, special utilities etc). I am sure you, being a vetran, understand the point well.

I am not for discarding features from the system, but for implementing them in a way that is lesser intrusive.

> Can you please expand a bit why you think losetup is that complicated
> and what the problem is with it?
Sir, i don't object to losetup as such. It is a utility made(specifically?) for LOOP devices: which implements unnecessary gears and switches to operate.
I object only to what could be done without using ioctls and not to features that losetup provides for devices other than Loop(are there any?)

> AFAIK you're essentially just moving a minimal version of losetup
> (with missing features like no offsets etc.) into the kernel
Its simpler than that :)
All i do is implement non-ioctl method to load/unload a file as a (emulated)block device. And alloc/free resources for them on need basis rather than limiting them at driver-module load-time.

Further about some features of LOOP drivers like encryption: i think they are better done at filesystem level.
I believe any operation that could be done on a real block device shud be possible on an emulated one. And exactly that.
If there is any need to do some stuff(offsets, encryption etc) then that cud be done on a real block and we would surely already have utilities for doing that on real devices(and hences on a transparent emulated device).
I am unable to think of something practical that can _only_ be done using the 'offset feature' of losetup on /dev/loop AND which can not be accomplished for (emulated or not)block devices.
The point is to only make least intrusive and most generic code, for making easy the inheritance of standard system-wide features, utilities and usages.

LOOP driver was a brilliant idea for the early days of Linux. The days when one could relatively easily define new syscalls/ioctls.

> Or rather if you start with losetup, why stop at mount, modprobe, ifconfig, mkfs, fsck, ls[1], ...?
I am not starting with any application.
I start with removing redundancy in a driver(LOOP), if by doing that i make obsolete an application... am for it.

>[1] I'm sure someone could come up with some scheme to do ls using sysfs
> and you could find someone on this list who said "cool" :)
It would indeed be cool if the one doesn't make use of 'cat' 'grep' et al and the method is more efficient.
Otherwise it would just be four motobikes tugging a car :)

Regards,
Jassi


      
