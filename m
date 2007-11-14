Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbXKNL1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbXKNL1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbXKNL1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:27:07 -0500
Received: from sacred.ru ([62.205.161.221]:55206 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbXKNL1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:27:06 -0500
Message-ID: <473ADB5B.50902@openvz.org>
Date: Wed, 14 Nov 2007 14:26:19 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] A config option to compile out some namespaces code (v4)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 14 Nov 2007 14:26:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change against v3: rebased on 2.6.24-rc2-mm1

There were some questions like "do I need this on my cellphone"
in reply to different namespaces patches. Indeed, the namespaces
are not useful for most of the embedded systems, but the code
creating and releasing them weights a lot.

So I propose to add a config option which will help embedded
people to reduce the vmlinux size. This option simply compiles
out the namespaces cloning and releasing code *only*, but keeps
all the other logic untouched (e.g. the notion of init_ns).

Moreover, some of the namespaces might be not 100% ready by
the time of Linux-2.6.xxx release (like user namespaces or pid 
namespaces are now). Since each namespace has its own option, 
which depends on the NAMESPACES, it can be mrked with "depends
on EXPERIMENTAL/BROKEN/ANYTHING_ELSE" not to release the
functionality that is not 100% ready yet.

When someone tries to clone some namespace with their support
turned off, he will receive an EINVAL error.

This patchset can save more than 2KB from the vmlinux when
turning the config option "NAMESPACES" to "n".

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
