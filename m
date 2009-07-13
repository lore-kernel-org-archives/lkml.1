Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZGMRpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZGMRpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZGMRpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:45:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:47758 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZGMRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qXf5DzwKkjel1nnWR0xfMqqqPBxFDu63SvVcOmgX1dzp9+v0ENTFcB+sL10YvwhBZM
         iTTVR2pWCRs7b6Ef5IJnjURnV1X8nU0/l9KP30UYv2/RvcaaDAjjOf5tH/ybhqPYn7Q6
         k0cIdfcpgmbORY2fwGv1GyLX7aKCL8MD4kMO0=
Message-ID: <4A5B72A1.5090605@gmail.com>
Date: Mon, 13 Jul 2009 19:45:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org,
       cpufreq@vger.kernel.org
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer dereference
References: <1247410030.1095.1.camel@localhost>	 <loom.20090712T172408-520@post.gmane.org>  <4A5A46ED.7010907@gmail.com> <1247504406.5437.3.camel@localhost>
In-Reply-To: <1247504406.5437.3.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 07:00 PM, Thomas Meyer wrote:
>> What warning tainted the kernel before this oops is still interesting...
> 
> There seems to be no OOPS before that BUG. Does a WARNING also set the G
> flag? 

No, W is set by warning. G means no proprietary modules loaded.

> Something like that:
> 
> Jul 12 16:42:34 localhost kernel: [ 6179.647004] ------------[ cut here ]------------
> Jul 12 16:42:34 localhost kernel: [ 6179.647004] WARNING: at lib/kref.c:43 kref_get+0x2f/0x4c()

It tried to get a reference of a structure which was already "freed".
Its reference count already had lowered to 0.

> Jul 12 16:42:34 localhost kernel: [ 6179.647004] Hardware name: MS-7250
> Jul 12 16:42:34 localhost kernel: [ 6179.647004] Modules linked in: rndis_wlan floppy olympic forcedeth [last unloaded: scsi_wait_scan]
> Jul 12 16:42:34 localhost kernel: [ 6179.647004] Pid: 27483, comm: pm-suspend Tainted: G        W  2.6.31-rc2 #79
> Jul 12 16:42:34 localhost kernel: [ 6179.647004] Call Trace:
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff8106c1c6>] ? warn_slowpath_common+0x84/0xb2
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff8134876b>] ? kref_get+0x2f/0x4c
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff813476b2>] ? kobject_get+0x26/0x44
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff815a344f>] ? cpufreq_cpu_get+0x74/0xca
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff815a3675>] ? cpufreq_suspend+0x5f/0x16f
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81044a4f>] ? disable_local_APIC+0x2d/0x6d
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81449b54>] ? sysdev_suspend+0xa7/0x28d
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff810a1229>] ? suspend_devices_and_enter+0x11c/0x1e6
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff810a13d8>] ? enter_state+0xe5/0x14c
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff810a0841>] ? state_store+0xc1/0xf6
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81178bb8>] ? sysfs_write_file+0xe6/0x137
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81117d03>] ? vfs_write+0xb4/0x126
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81117e5d>] ? sys_write+0x55/0x90
> Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff8102bf2b>] ? system_call_fastpath+0x16/0x1b
> Jul 12 16:42:34 localhost kernel: [ 6179.647004] ---[ end trace f7a4d612974b9b3e ]---
> 
> Btw this seems also to be new in 2.6.31-rc2:

This is unrelated I think. I met it many times.

> Jul 12 16:42:34 localhost kernel: [ 6187.256748] sd 2:0:0:0: [sdb] Starting disk
> Jul 12 16:42:34 localhost kernel: [ 6190.318012] 
> Jul 12 16:42:34 localhost kernel: [ 6190.318128] floppy driver state
> Jul 12 16:42:34 localhost kernel: [ 6190.318244] -------------------
> Jul 12 16:42:34 localhost kernel: [ 6190.320684] now=4300857616 last interrupt=4294760495 diff=6097121 last called handler=ffffffffa00263ea
> Jul 12 16:42:34 localhost kernel: [ 6190.320896] timeout_message=lock fdc
