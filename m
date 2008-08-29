Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYH2N1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYH2N1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYH2N10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:27:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYH2N1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:27:25 -0400
Subject: Re: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
From: Kay Sievers <kay.sievers@vrfy.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Zeuthen <david@fubar.dk>
In-Reply-To: <48B7AD11.2070906@kernel.org>
References: <48B6D28E.10006@kernel.org> <48B6D2C6.4010703@kernel.org>
	 <20080828164924.GB17475@kroah.com> <48B6D9B7.2050406@kernel.org>
	 <3ae72650808290048v1a5d7e51pc68270b2a8d6faa@mail.gmail.com>
	 <48B7AD11.2070906@kernel.org>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 15:27:19 +0200
Message-Id: <1220016439.24737.18.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+Josy7XOw91siBJMUheGN98LpEC1eXVfe+zGE
 ck4omCJe/nnCSJaZCtKdKVaEMdSDFBZ8ZRmpaqd8oAyK9BY5SQ
 tuKFpHoZ0V4CU9KvOK5Zh431r4FbLY1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 10:02 +0200, Tejun Heo wrote:
> Kay Sievers wrote:
> > Not sure if I understand that correctly. Remember, that there is a
> > symlink "subsystem" at each device, and udev, HAL, DeviceKit reads it.
> > If the uevent environment key "SUBSYSTEM" does not match the symlink
> > target, things will break horribly. So no device can be a member of
> > class "cuse" but carry a SUBSYSTEM value of a different class.
> >
> > If that is how it works, I guess that must be solved differently, by
> > hooking into the subsystem code and create "virtual devices" at the
> > original class they fake, instead of their own "cuse" class. Possibly
> > by making cuse a "bus", and use the cuse device as a parent for the
> > "real" class device.
> 
> For OSS emulation, it didn't really matter.  For cases where it matters,
> I think easier path to take would be let the userland emulation set up a
> directory containing pseudo files and just override DEVPATH to it.
> Would that work?

No, I don't think so, it's a too bad hack. the SUBSYSTEM key, the entry
in the class/bus directory, and the target of the symlink in the device
directory _must_ match. Everything else asks for serious trouble, by the
inconsistency it creates.

Thanks,
Kay

