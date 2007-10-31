Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbXJaKPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbXJaKPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbXJaKPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:15:36 -0400
Received: from sacred.ru ([62.205.161.221]:59659 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919AbXJaKPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:15:35 -0400
Message-ID: <47285FEE.9030001@openvz.org>
Date: Wed, 31 Oct 2007 13:58:54 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] A config option to compile out some namespaces code (v3)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 31 Oct 2007 12:56:38 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There were some questions like "do I need this on my cellphone"
in reply to different namespaces patches. Indeed, the namespaces
are not useful for most of the embedded systems, but the code
creating and releasing them weights a lot.

So I propose to add a config option which will help embedded
people to reduce the vmlinux size. This option simply compiles
out the namespaces cloning and releasing code *only*, but keeps
all the other logic untouched (e.g. the notion of init_ns).

When someone tries to clone some namespace with their support
turned off, he will receive an EINVAL error.

This patchset can save more than 2KB from the vmlinux when
turning the config option "NAMESPACES" to "n".

I do not introduce the NAMESPACES_EXPERIMENTAL config option, that
switches all the namespaces we consider experimental, but each 
namespace has its own config that can be mrked with "depends on
EXPERIMENTAL" on demand.

This is mainly done because some people consider pid namespaces broken
ant will probably want to make them depend on BROKEN. In this case
we'll have to introduce the NAMESPACES_BROKEN option which is not that
good.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
