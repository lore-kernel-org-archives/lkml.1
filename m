Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0CCRRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:17:17 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:37312 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754083Ab0CCRRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:17:15 -0500
Date: Wed, 3 Mar 2010 20:17:13 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/11] ahci: Add support for non-PCI devices
Message-ID: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 08:40:30AM -0500, Jeff Garzik wrote:
[...]
> Well, the general idea is to have a kernel module libahci.ko, upon
> which ahci.ko, mv-ahci.ko, acard-ahci.ko and platform-ahci.ko
> depends.

Yep, that's exactly the purpose of my patches.

> That would imply a bunch of exports, when the library code
> is moved from ahci.c to libahci.c, because libahci should be a
> separate kernel module.

Yep. Though, I don't bother with exporting symbols that neither
ahci (PCI driver) nor platform driver need. Later we might export
some more for mv/acard-ahci...

> I'm not overly picky about file naming.  However, in existing
> installations, people, scripts, knowledgebase articles and
> configuration files expect "ahci" to be the driver for PCI AHCI
> devices.  We don't want to break that if we can avoid it.  Simply
> using a different name avoids any breakage related to name changes.

OK. So in these series:

- I kept PCI driver in ahci.c (built as ahci.ko);
- Moved generic code into libahci.{c,h} (built as libahci.ko)

Also in these series:

- Rebased on top of linux-next (the patches also apply onto the
  current Linus' git tree, fwiw).
- Dropped sparse fixes patch, as the issue appears to be already
  fixed in linux-next.
- Addressed Sergei's comments on ahci_platform driver.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
