Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXHTIAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXHTIAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXHTIAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:00:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:60769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXHTIAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:00:07 -0400
Date: Mon, 20 Aug 2007 09:59:49 +0200
From: Markus Dahms <mad@automagically.de>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: possible endless loop in PROM initialization
Message-ID: <20070820075949.GA5927@vimes.madsworld.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Provags-ID: V01U2FsdGVkX18M1ryUfS+ILkvGGkJ44bGtFgcVSRXNRUikC/v
 hAY0v6BVCc1gOPwIiaVUKQm3+OUJ3yI3UVR5yXjfN1dJItmKsW
 Wi2/olDCc/RO6h6sxEQaw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

while trying to define a non-unique devalias at the Sun PROM prompt
(the SPARCclassic X has wrong aliases for scsi, disk1, etc. in the
PROM, at least mine) I fell over a bug resulting in an endless loop
while booting the kernel.

The problem is the getting the properties list of the /aliases node.
As the next element in this list is identified by name and the
function which retrieves this property always returns the first
occurrence this goes forever....

I could track down the issue to the function __prom_nextprop() in
arch/sparc/prom/tree.c, but I am now looking for the definition of
prom_nodeops->no_nextprop() without success.

My naive solution would be to return not the first but the last
occurrence of a property.

Greetings,

	Markus

