Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZDNQzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZDNQzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbZDNQzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:55:07 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:33495 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709AbZDNQzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:55:05 -0400
Message-ID: <49E4BFD0.2020302@csr.com>
Date: Tue, 14 Apr 2009 17:54:40 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: Greg KH <greg@kroah.com>
Subject: device_for_each_child() before device_add() doesn't work
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Apr 2009 16:54:40.0092 (UTC) FILETIME=[B39051C0:01C9BD21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling device_for_each_child() on a device that has yet to be added
(with device_add()) used to work.  UWB subsystem currently tries to do this.

Since "driver core: move klist_children into private structure"[1] this
no longer works (an oops occurs in device_for_each_chid()).  Is it
something that ought to work? Or should the UWB subsystem be changed to
not do this?

David

[1] f791b8c836307b58cbf62133a6a772ed1a92fb33
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
