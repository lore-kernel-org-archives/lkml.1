Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXAZVHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXAZVHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXAZVHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:07:31 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23638 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbXAZVHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:07:31 -0500
Message-ID: <45BA6D8E.1040705@tls.msk.ru>
Date: Sat, 27 Jan 2007 00:07:26 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.8 (X11/20061128)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Can a kobject have both bus- and class-specific uevent handlers?
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at drivers/base/core.c:dev_uevent() I wonder whenever
a device can have both bus-specific uevent function AND
class-specific one.  If yes, the code in that routine is umm..
wrong.  Because in this case, bus-specific attributes will
be owerwritten by class-specific ones.

I mean this code (debugging omitted for simplicity):

    if (dev->bus && dev->bus->uevent) {
            /* have the bus specific function add its stuff */
            retval = dev->bus->uevent(dev, envp, num_envp, buffer, buffer_size);
    }

    if (dev->class && dev->class->dev_uevent) {
            /* have the class specific function add its stuff */
            retval = dev->class->dev_uevent(dev, envp, num_envp, buffer, buffer_size);
    }

    return retval;

Thanks.

/mjt
