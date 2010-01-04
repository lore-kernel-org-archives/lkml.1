Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813Ab0ADSuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab0ADSuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700Ab0ADSuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:50:35 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62581 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab0ADSuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=x+C8oXsh99zezF/K4w8KGLa/Ba50B28ACXE6q8sFY6NGCwHALwTuSzVLen6R+6BNcZ
         pRuT7kxy6cZ8KmWOAZFZPmZ8CR365rNg6XKXHCtY9xenoqKFi0dvdqrZN1RaI1ixOF/k
         jncBQXkMFEJpgoPtv6erRlrvYHT+XpITmfHBI=
Date: Mon, 4 Jan 2010 10:50:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Need to take dev->sem, do it directly or use wrapper?
Message-ID: <20100104185023.GA2597@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I was looking at restructuring serio a bit and rely more on the
infrastructure in the drivre core now that it is more flexible. It all
looks good except for one detail - serio provides "reconnect" method
which allows user to reinitialize a port whithout tearing down its
children input devices. To properly serialize with probe(), remove() and
other bus operations I'd need to take dev->sem semaphore. I(s bus code
allowed to do this? Can I do it directly or we need to add a wrapper
(like device_serialize_access(dev, bool))?

Thanks.

-- 
Dmitry
