Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXETLBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXETLBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759137AbXETLBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:01:41 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:50560 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358AbXETLBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:01:40 -0400
Message-ID: <46502A8B.70803@drzeus.cx>
Date: Sun, 20 May 2007 13:01:31 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Race free attributes in sysfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I'm reworking the sysfs stuff in the MMC layer to be a bit more flexible, but
there is one thing that has me baffled; how do you add attributes to an object
in a race free manner when you have a dynamic set of attributes.

I've looked at other parts of the kernel and they all use:

1. Add object.
2. Add attributes.

To me, it seems like there's a window between 1 and 2 where the object is in
/sys but doesn't have the proper attributes. Life for user space gets very
annoying if it has to add artificial delays to avoid this window.

So how do I do this properly? Something like this would, from my point of view,
be the sane method:

1. Add hidden object.
2. Add attributes.
3. Show object.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
