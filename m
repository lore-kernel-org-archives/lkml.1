Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYGVPmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYGVPmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYGVPmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:42:16 -0400
Received: from xenotime.net ([66.160.160.81]:53610 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750711AbYGVPmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:42:15 -0400
Date: Tue, 22 Jul 2008 08:42:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linuxkernelnewbies@googlegroups.com" 
	<linuxkernelnewbies@googlegroups.com>
Subject: Re: make htmldocs errors
Message-Id: <20080722084211.10d21eb5.rdunlap@xenotime.net>
In-Reply-To: <804dabb00807220407x683f0eb2we0b64821b9279e3c@mail.gmail.com>
References: <804dabb00807220407x683f0eb2we0b64821b9279e3c@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 19:07:59 +0800 Peter Teoh wrote:

> "make htmldocs" generated the following errors:
> 
> Warning(/sda4/download/linux_linus/linux-2.6//include/asm-x86/unaligned.h):
> no structured comments found

kernel-api.tmpl "includes" asm-x86/unaligned.h, but the latter contains no
kernel-doc comments.  This is due to some unaligned macro/inline function
"fixes" (movement/restructuring).  This head file used to contain kernel-doc
comments for unaligned functions, but it no longer does.
I'm not sure if any header file does now.  If one does, it needs to be used here
instead of this header file.

> Warning(/sda4/download/linux_linus/linux-2.6//kernel/rcupdate.c:81):
> No description found for parameter 'synchronize_rcu'
> Warning(/sda4/download/linux_linus/linux-2.6//kernel/rcupdate.c:81):
> No description found for parameter 'call_rcu'

Confusing syntax for a simplistic perl parser.  I'll have to take a look
at that.

> Error(/sda4/download/linux_linus/linux-2.6//drivers/pci/pci.c:1133):
> duplicate section name 'Description'
> Error(/sda4/download/linux_linus/linux-2.6//drivers/pci/pci.c:1189):
> duplicate section name 'Description'

I have already posted a patch for these.  The function short description
must be on one line.  Having it on multiple lines confused scripts/kernel-doc.

> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'id'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'attach_adapter'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'detach_adapter'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'detach_client'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'probe'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'remove'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'shutdown'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'suspend'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'resume'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'command'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'driver'
> Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
> No description found for parameter 'id_table'

These aren't a mystery at all:  include/linux/i2c.h is missing lots of
struct i2c_driver field/member descriptions.


> make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 2
> make: *** [htmldocs] Error 2
> 
> Can someone explain what is the cause of the error?   Is it because
> "make htmldocs" attempt to detect for description marked as "/* */"
> beside the field name?

No.  drivers/pci/pci.c had invalid kernel-doc comments in it (function
short description on multiple lines).


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
