Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbYCEXyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbYCEXyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbYCEXyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:54:43 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55336 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbYCEXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:54:42 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CF3290.10404@s5r6.in-berlin.de>
Date: Thu, 06 Mar 2008 00:53:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: [PATCH update] firewire: reread config ROM when device reset
 the bus
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>  <tkrat.da30e6f15a74e036@s5r6.in-berlin.de> <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com> <tkrat.5eee3ebd5076fd4a@s5r6.in-berlin.de> <tkrat.55f8e340ac08be4c@s5r6.in-berlin.de>
In-Reply-To: <tkrat.55f8e340ac08be4c@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> I wrote:
>>   - moved from dev->dem to idr_rwsem
>>   - extended note about semaphore protection of .config_rom and
>>     .config_rom_length
>>   - secure a few more places which access the config_rom...
>>     should have covered all of them now
> 
> Hmm.  When I power the PC down there are lots of messages scrolling by
> which look somewhat like lockdep spew.  I can't reproduce this merely by
> module unloading though.  So don't put this patch into production yet.

/...a few hundreds reboots later.../

No, it is not this patch.  It is something else.  And whatever it is, it 
is already present in 2.6.25-rc3.

To reproduce it, I need to plug an SBP-2 device in and out, then shut 
the machine down (e.g. shutdown -h now, whereas shutdown -r now does not 
seem to trigger the bug).

Since it happens after all filesystems were unmounted or r/o-mounted, I 
can't capture the log output easily (perhaps with a netconsole or so) 
but it also can't do any damage at that point anymore.

It does not happen with ohci1394 + sbp2, so it is obviously located in 
the firewire stack.

I am now gradually removing debug options from the kernel to see which 
debug facility is making the fuzz...
-- 
Stefan Richter
-=====-==--- --== --=-=
http://arcgraph.de/sr/
