Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbZFZIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbZFZIxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZFZIxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:53:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:52097 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbZFZIxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:53:21 -0400
Date: Fri, 26 Jun 2009 10:53:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: hid tree build failure
In-Reply-To: <20090626153100.de647d08.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.0906261052350.18021@wotan.suse.de>
References: <20090626153100.de647d08.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Stephen Rothwell wrote:

> Today's linux-next build (sparc32 defconfig) failed like this:
> 
> drivers/hid/hid-core.c:862:34: error: macro "hid_dump_input" passed 3 arguments, but takes just 2
> drivers/hid/hid-core.c: In function 'hid_process_event':
> drivers/hid/hid-core.c:862: error: 'hid_dump_input' undeclared (first use in this function)
> drivers/hid/hid-core.c:862: error: (Each undeclared identifier is reported only once
> drivers/hid/hid-core.c:862: error: for each function it appears in.)
> drivers/hid/hid-core.c:984:68: error: macro "hid_dump_input" passed 3 arguments, but takes just 2
> drivers/hid/hid-core.c: In function 'hid_set_field':
> drivers/hid/hid-core.c:984: error: 'hid_dump_input' undeclared (first use in this function)
> drivers/hid/hid-core.c: In function 'hid_input_report':
> drivers/hid/hid-core.c:1090: error: 'HID_DEBUG_BUFSIZE' undeclared (first use in this function)
> 
> Caused by commit cd667ce24796700e1a0e6e7528efc61c96ff832e ("HID: use
> debugfs for events/reports dumping") which modified the prototype for
> hid_dump_input, but not the !CONFIG_DEBUG_FS version.  It also added
> HID_DEBUG_BUFSIZE when CONFIG_DEBUG_FS, but used it otherwise.
> 
> I have reverted that commit for today (along with commit
> a635f9dd83f3382577f4544a96df12356e951a40 ("HID: use debugfs for report
> dumping descriptor") which doesn't build without the other one).

Hi Stephen,

should be now fixed in the branch you pull into -next.

Thanks,

-- 
Jiri Kosina
SUSE Labs
