Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXAaKzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXAaKzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXAaKzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:55:37 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:55547 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007AbXAaKzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:55:37 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: remove_proc_entry and read_proc
Date: Wed, 31 Jan 2007 11:54:35 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311154.35929.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can read_proc still be executing when remove_proc_entry returns?

In my driver [*] I allocate some data and create a proc entry using
create_proc_entry.  My read method reads from my allocated data.  When
shutting down, I call remove_proc_entry and immediately free the data.
If some call to read_proc is still executing at this point then it will
be accessing freed memory.  Can this happen?  I've been rummaging around
in fs/proc to see what prevents it, but didn't find anything yet.

Thanks a lot,

Duncan.

[*] Actually it's the ATM layer that does all this (net/atm); my driver
uses that layer.
