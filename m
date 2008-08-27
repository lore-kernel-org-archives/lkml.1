Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYH0Izd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYH0Izd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYH0IzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:55:24 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37529 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbYH0IzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:55:23 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Date: Wed, 27 Aug 2008 10:56:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
References: <20080827000501.GA29570@kroah.com>
In-Reply-To: <20080827000501.GA29570@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271056.37159.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 27 August 2008 02:05:01 schrieb Greg KH:
 
> I've now added this to my tree, and any review comments are greatly
> welcome.

Unfortunately the issues are not trivial.

1. USBTMC_SIZE_IOBUFFER
use 2048. 4096 means a multipage allocation

2. usbtmc_open race with disconnect
already mailed about

3. read/write and, if you convert to unlocked_ioctl, need protection
against reentry

4. read, write & ioctl need protection against using a rebound interface
you add a mutex, that you need for (3) anyway to the descriptor and protected
by this mutex you set the interface and device pointers to null in disconnect
and check them in the affected methods

5.get_capabilities
kmalloced buffer is never freed

6. disconnect fails to remove sysfs attributes

7. probe will report success even if usb_register_dev fails

	Regards
		Oliver
