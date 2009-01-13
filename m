Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZAMWhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZAMWhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZAMWgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:36:52 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39359 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbZAMWgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:36:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EGmo8sQfDJj85AcP+dfcY01R8LHqLjzGzALX+e2HHCQeuEx5hxJD2/aOqHxpcdJHXB
         f8F05RoFfLiz2pYLTIdN2uvAWFu3D7/aD6pU7PDornCE1S/07CIi5z/ynuCasaoQkczf
         edzlfKNAR3Cvt8q6YrXc0Zhf1h9EX2U3tQynY=
Message-ID: <c4e36d110901131436y79beaf40h2da44e5925d574b5@mail.gmail.com>
Date: Tue, 13 Jan 2009 23:36:49 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
In-Reply-To: <200901121819.01042.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <200901121340.21009.rjw@sisk.pl>
	 <c4e36d110901120450q10278979j5cf726a5175cc3f1@mail.gmail.com>
	 <200901121819.01042.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday 12 January 2009, Zdenek Kabelac wrote:

> Sure, good idea.  I've been running with this reverted recently.
>
>> PS: I'll do the above 'echo' trace later (being busy right now).
>
> That shouldn't be necessary if you can suspend-resume with
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
> modules unloaded.
>
> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
> and see if suspend-resume works in this configuration.
>

Hi

So I've check some   find /sys/device | grep usb | grep power/wakeup
and there was no difference.
I've updated to latest git to be in sync
(e0b325d310a6b11f1538413fd557d2eb98f2fae5)
I'm still keeping reverted commit: 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.

And I've figured out - the only  'modprobe -r ehci_hcd' is enough to
keep my suspend/resume sequence working. (Though I would have say,
that now it takes fairly noticable time to get keyboard and synaptics
usable - but it might be connected with my move to evdev and hal... :)
)

So I'm adding cc: to David - maybe he has some suspected patches for
ehci_hcd ? (as doing a bisect in such a broken merge window is going
to give me probably a lot of unsable kernels nowdays....)

Zdenek
