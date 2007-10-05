Return-Path: <linux-kernel-owner+w=401wt.eu-S1763670AbXJEVDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763670AbXJEVDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbXJEVDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:03:12 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:34635 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761873AbXJEVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:03:11 -0400
Date: Fri, 5 Oct 2007 14:03:10 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
cc: Linux DVB <linux-dvb@linuxtv.org>
Subject: Reloading DVB drivers broken since 2.6.22, worked in 2.6.21
Message-ID: <Pine.LNX.4.58.0710050723460.2078@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After a dvb card driver is unloaded and then loaded again, it is no longer
possible to access the dvr device.

Example:
cat /dev/dvb/adapter0/dvr0
  kill with ^C
rmmod cx88-dvb
modprobre cx88-dvb
cat /dev/dvb/adapter0/dvr0
cat: /dev/dvb/adapter0/dvr0: No such device

On kernel 2.6.21, this worked fine.  In order to get dvb working again,
it's necessary to unload and reload the dvb-core modules.

I strongly suspect commit 57861b432bda77f8bfafda2fb6f5a922d5f3aef1
is somehow related to this problem.
