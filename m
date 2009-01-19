Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZASU57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZASU57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZASU5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:57:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38649 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbZASU5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=w/AjxBIR+JS3k9kJ9h1pRt/MhW/Z0xNOxItp9EtLNXskoeJ7iNBm0aW1orQX25PFHK
         EzIjDdGc4HJK8eND7IBf2+el0lmI8vRwt2Z/+AWCOUSP6NqlF+/OYrHHFkb2tEWyyqX9
         julZkRaPMmrXJ/3T3SflHJRTBoWgusQ1A/TCE=
Date: Tue, 20 Jan 2009 00:03:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: staging driver (epl)
Message-ID: <20090119210315.GA3805@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, can I ssh to your box to do

	git rm -rf drivers/staging/epl
	sed -i -e '/epl/d' drivers/staging/Kconfig
	sed -i -e '/CONFIG_EPL/d' drivers/staging/Makefile
	git commit -a -m 'staging: remove epl driver'

?

This driver doesn't meet even _the_ basic requirements.

It's _full_ of hungarian notation (iRet).

It's full of typedefs.

It's full of HAL (tEplApiInstance etc).

Filenames (!) are in CamelCase.

It creates sockets from kernel for something.

It tries to interact with devfs.

It may come as surprise but you also committed real Win32 code:

	drivers/staging/epl/EplTimeruWin32.c
	drivers/staging/epl/ShbIpc-Win32.c

Amazing, isn't it?

Do you accept _any_ code? Exactly zero entry barrier?
