Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZAAQED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZAAQED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 11:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbZAAQDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 11:03:51 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:4586 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbZAAQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 11:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=tlYUvbJGOINPe6zNTpRgVfpgSOyK0hqrKNJTI5g3+RHLZcVUstBmpS/0pfvp3cqRfo
         4z3I1zpEXfNbOTgOBTVrMS0b+LzYLNvwQS+681oOQQHjxtR6o3avZa7JCTMilBDkwOMa
         kWCg8fJY9jMJzOyM0b9bxGV/6m9lNvDNRU4uk=
Date: Fri, 2 Jan 2009 00:03:43 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't be
	unplugged safely
Message-ID: <20090101160343.GA4278@thyme.bj.intel.com>
Mail-Followup-To: gregkh@suse.de, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

By default CONFIG_USB_SUSPEND is not enabled and today I got bite by
this when I got a new WDC My Book hard drive. I have no way to unplug
it safely, according to it's manual, with a kernel that doesn't have
CONFIG_USB_SUSPEND=y.

On it's manual read "you should unplug and remove the device only when
the light is off." On Linux unmounting it won't turn it's light off
and I can feel it's motor is still running.  The only way to unplug it
properly on a Linux system, as to my knowledge, is to echo `suspend'
to `/sys/bus/usb/devices/$DEV/power/level'. And one has to have
CONFIG_USB_SUSPEND=y to do this.

On Windows and Mac OS, `safely remove this device' function effectly
turns it into `suspend' mode, and it's light off.

I'm new in this field and I understood people's concern on enabling
autosuspend.  As to my understanding, `enabling suspend' and `enabling
autosuspend' should be controlled by two different knobs.  I did a
quick search in LKML and haven't found specific oppose to enable USB
suspend by default, and Debian has started shipping a kernel with
it turned on since 2.6.26.

Perhaps we should consider turning it on by default?  Thanks!

-- 
Li, Yan
