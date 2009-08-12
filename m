Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbZHLOdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbZHLOdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbZHLOdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:33:06 -0400
Received: from mail-yw0-f191.google.com ([209.85.211.191]:34485 "EHLO
	mail-yw0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZHLOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <40c00347a27f37e06686be80de0adcf6.squirrel@intranet.cs.nmsu.edu>
References: <40c00347a27f37e06686be80de0adcf6.squirrel@intranet.cs.nmsu.edu>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 12 Aug 2009 16:32:48 +0200
Message-ID: <ac3eb2510908120732x790868bau318caa614dd5c877@mail.gmail.com>
Subject: Re: Event notification when sysfs attribute changes
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Linux USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 16:26, Rick L. Vinyard, Jr.<rvinyard@cs.nmsu.edu> wrote:
> I'd like to allow userspace applications to track and display state
> changes (without polling) in a driver that exports attributes via sysfs.
>
> What is the best way to notify userspace applications when a sysfs
> exported attribute changes?
>
> In particular I wanted to drive the notification in the *_store() function
> of the sysfs attribute.
>
> Also, ideally, the mechanism would allow multiple userspace applications
> to hook into the notification.

There is nothing like this which works out-of-the-box. It needs kernel
support for every attribute that should be able to do that. Then
poll() can block until the kernel signifies a change, and return with
ERR, so the listener wakes up and can read the attribute again.

Kay
