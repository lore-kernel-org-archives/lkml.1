Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbXGZJP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbXGZJP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759186AbXGZJPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:15:51 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:36748 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbXGZJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:15:50 -0400
Message-ID: <46A865CC.6030702@gmail.com>
Date: Thu, 26 Jul 2007 11:13:48 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Masoud Sharbiani <masouds@google.com>, Andi Kleen <ak@suse.de>,
       Kirill Korotaev <dev@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
References: <20070718154759.GA26425@google.com>	<46A76210.5020903@openvz.org>	<200707251657.44217.ak@suse.de>	<20070725140455.cbbc0dde.akpm@linux-foundation.org>	<4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com> <20070725162528.7d485ff8.akpm@linux-foundation.org>
In-Reply-To: <20070725162528.7d485ff8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2007 01:25 AM, Andrew Morton wrote:

> On Wed, 25 Jul 2007 14:07:56 -0700
> "Masoud Sharbiani" <masouds@google.com> wrote:

>> This is rate limited; Do you need me to rewrite it with it being
>> disabled by default?
> 
> Yes please.
> 
> Look: if there's a way in which an unprivileged user can trigger a printk
> we fix it, end of story. I don't know why this even slightly controversial.

rene@7ixe4:/tmp$ su -c "dmesg -c >/dev/null"
rene@7ixe4:/tmp$ cdparanoia -B

[ ... ]

rene@7ixe4:/tmp$ dmesg | wc -l
158
rene@7ixe4:/tmp$ dmesg | tail -20
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
    program cdparanoia not setting count and/or reply_len properly
printk: 252 messages suppressed.
sg_write: data in/out 16464/16464 bytes for SCSI command 0xbe--guessing data in;
    program cdparanoia not setting count and/or reply_len properly
printk: 245 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
    program cdparanoia not setting count and/or reply_len properly
printk: 243 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
    program cdparanoia not setting count and/or reply_len properly
printk: 242 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
    program cdparanoia not setting count and/or reply_len properly
printk: 255 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
    program cdparanoia not setting count and/or reply_len properly
printk: 242 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
    program cdparanoia not setting count and/or reply_len properly

cdparanoia does require access to the /dev/sg? that corresponds to /dev/cdrom 
but at least udev (here) makes that node be a (root,cdrom) b-rw-rw--- device 
(and requiring root privileges to rip CDs would certainly not be nice).

Rene.
