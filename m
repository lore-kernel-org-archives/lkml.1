Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbXK0QX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbXK0QX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbXK0QXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:23:52 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50163 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755516AbXK0QXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:23:51 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: leak in do_ubd_request
Message-Id: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Nov 2007 17:23:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When writing big files on 2.6.24-rc3-mm1, there can be substiantial
number of leaked requests (CONFIG_DEBUG_SLAB_LEAK enabled):

# cat /proc/slab_allocators |grep do_ubd_request
size-128: 25687 do_ubd_request+0xe0/0x19d

There seems to be no corruption though.  Looking at the code, I can't
see how the requests could leak...

Miklos
