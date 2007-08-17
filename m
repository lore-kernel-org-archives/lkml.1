Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbXHQHzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbXHQHzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbXHQHzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:55:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48215 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbXHQHzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=V2X9oo0T8J/AnvXhOi4OnVhVuWN3S4QW0bEjqLeZyLY84lv22nNG+fgh6RSNpIyuuFcC3g7N7yOh9oi7HNoHZzkNt9O55vd7icbX8RhPza2wgZFwsuDmygpN1/5jxARFQ3Il/lJNDSToQsS6KAatBh78MijeF1ySGpXWpLBDR/E=
Message-ID: <3ae72650708170055p51846c6dp8d8e5b22138f627a@mail.gmail.com>
Date: Fri, 17 Aug 2007 09:55:22 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Need help with modules loading
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46C50902.4000502@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C50902.4000502@lwfinger.net>
X-Google-Sender-Auth: 3c11c75e0963e1aa
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> A new driver for the Broadcom BCM43xx devices has been written that uses mac80211, rather than
> softmac. The newest versions of the Broadcom firmware does not support all the BCM devices.
> Accordingly, a separate driver is being prepared that will use an older version of the firmware and
> support these legacy devices. Unfortunately, there is not a clean separation based on PCI id's;
> however, the revision level of the 802.11 wireless core can be used to determine which driver should
> be used. The scheme works on most systems, but not mine and I need some help to discover why.

> The 'MODALIAS=ssb:v4243id0812rev0A' line is correct for my device. In fact issuing a modprobe
> "ssb:v4243id0812rev0A" command results in the loading of the module. For some reason, this does not
> happen automatically.
>
> Initially, I suspected that my version of udev (103-13) was too old; however, upgrading to version
> 114 did not help. My module-init-tools are V 3.2.2 and my distro is the x86_64 version of openSUSE 10.2.

openSUSE 10.2 used a whitelist of buses which trigger module loading.
It's in the udev sysconfig. rules and /sbin/hwup.

The easiest is probably to add a rule for that bus:
  ACTION=="add", SUBSYSTEM=="ssb", ENV{MODALIAS}=="?*",
RUN+="/sbin/modprobe $env{MODALIAS}"

openSUSE 10.3 will call modprobe directly, the whitelist and the whole
hwup logic is removed in the meantime.

Kay
