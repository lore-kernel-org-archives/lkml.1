Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYENOBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYENOBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYENOBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:01:36 -0400
Received: from vena.lwn.net ([206.168.112.25]:55549 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbYENOBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:01:35 -0400
To: =?UTF-8?B?SGlua28gS2/EjWV2YXI=?= <hinko.kocevar@cetrtapot.si>
Cc: linux-kernel@vger.kernel.org
Subject: Re: register_chrdev vs. cdev_add 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 14 May 2008 14:31:49 +0200."
             <482ADBB5.8050608@cetrtapot.si> 
Date: Wed, 14 May 2008 08:01:35 -0600
Message-ID: <16204.1210773695@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dev = MKDEV(htrc110_major, htrc110_minor);
> ret = register_chrdev_region(dev, 1, mod_name);
> ret = register_chrdev(dev, mod_name, &htrc110_fops);

If you want to use register_chrdev(), do not make a separate call to
register_chrdev_region().  Those two are not meant to work together.
register_chrdev() implicitly allocates a region of 256 minors for you.

jon
