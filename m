Return-Path: <linux-kernel-owner+w=401wt.eu-S935562AbXHHT72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935562AbXHHT72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760831AbXHHT7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:59:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:63789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272AbXHHT7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:59:19 -0400
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
From: Kay Sievers <kay.sievers@vrfy.org>
To: Bill Nottingham <notting@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@insightbb.com>, Greg KH <greg@kroah.com>
In-Reply-To: <20070808193220.GB5001@nostromo.devel.redhat.com>
References: <46B8C8FA.9020100@redhat.com> <46B8D984.7040602@garzik.org>
	 <46B8E773.5020406@redhat.com>
	 <3ae72650708071523s24d80ae4v2590c50aea04c850@mail.gmail.com>
	 <20070808193220.GB5001@nostromo.devel.redhat.com>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 22:02:07 +0200
Message-Id: <1186603327.3584.12.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+spDDvxLoZOYNebW7u4b/EUN9+lghiytdkqWJ
 GgxUsyPEKZiHBABw203trEFzDaTwi6kAwlqBqCHx9UGSzaViOS
 aD+qyugKvvtRtuPbDI7xS5pPf3vVR2T
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 15:32 -0400, Bill Nottingham wrote:
> Kay Sievers (kay.sievers@vrfy.org) said: 
> > It doesn't have any aliases, so seems it was never autoloaded.
> 
> It was - prior kernels loaded it via the uevent generated from 
> /devices/platform/pcspkr. Newer kernels seem to never actually
> trigger a uevent from that (tested with a combination of
> udevmonitor and 'udevtrigger --subsystem-match=platform'.)

Ah, ok, makes sense. Yeah, that weird "platform devices loads itself by
the name" thing got disabled in the platform subsystem. It caused
modprobe loops for other devices.

The whole idea of issuing MODALIAS with plain module names instead of
aliases can't really work, but the platform maintainer didn't like to
use the usual aliases and the matches in the modules, for a reason I
didn't understand while we talked about the problem last time.

Kay

