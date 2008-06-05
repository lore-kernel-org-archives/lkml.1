Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYFEJwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYFEJwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYFEJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:52:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYFEJwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:52:32 -0400
To: linux-kernel@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 00/18] firmware: moving drivers to request_firmware()
Message-Id: <20080605.foo@pmac.infradead.org>
Date: Thu, 05 Jun 2008 09:52:31 +0000
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ignoring the set of 'make fw->data const' patches which have mostly
been already posted and are fairly trivial, this is the current content
of the firmware tree at git.infradead.org/users/dwmw2/firmware-2.6.git

It starts by giving a way to build arbitrary firmware blobs into the
kernel while letting request_firmware() find them there, and then sets
about converting drivers to use request_firmware() instead of static
data blobs, now that we can do that without forcing the users to
actually  satisfy the firmware requests from userspace.

Rather than including binary blobs in the git tree, we carry them as
.ihex files -- which as an added bonus can have comments and licensing
information appended after the EOF record.

For the USB drivers which actually _want_ Intel HEX files in their
original form as individual records, we have a binary representation
of such and a tool to convert the original .HEX files into .fw files
in that form. And associated helpers in the kernel for validating and
using them. 

We also add a 'make firmware_install' target, which is intended to
install the firmware blobs into /lib/firmware/ where the userspace
loader to find them.

More patches to convert drivers to request_firmware() would be
appreciated, if there are any people out there looking for something
productive, but simple, to undertake...

-- 
dwmw2
