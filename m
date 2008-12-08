Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYLHK0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYLHK0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 05:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYLHK0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 05:26:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:15342 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYLHK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 05:26:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KS15/qhEZqMZf8L8AMpRGnyj0EbQw/mIpMjnmqRN1xndsZWvf70R4HgfE7/+8XraLR
         Me/WNt5yRGdv0uabG29Bp4Zd5jJhPbAOSQ2bCqVQURi6LUpG2/TN8ZvxdW2hObsYHzI2
         jnjYoIyYutRT26MaclB64QqU/I0tGXFrICKKM=
Message-ID: <12bfabe40812080226h13b8d52bia39cc20b404ba910@mail.gmail.com>
Date: Mon, 8 Dec 2008 11:26:19 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@linux.intel.com>
In-Reply-To: <493CEAA0.50201@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493AF2EA.4030601@shaw.ca>
	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>
	 <493B4242.1040202@shaw.ca>
	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	 <493CEAA0.50201@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/08, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
>
> IIRC, this error is not what happen on the time [301.7320xx] during
> boot, but happen before the boot.  Since the record says "Processor
> context corrupt," MCE handler should call panic(or do something stop
> the system) if the context actually corrupted during the boot.
>
> In other words, it seems that 1) the error was recorded at last time
> when your machine crashed unexpectedly(by cosmic-ray etc.) and not cleared
> yet, or 2) your machine is doing something wrong in every reset/poweroff.
>
> Could you try "mce=nobootlog" boot option?
>
> Thanks,
> H.Seto
>
>
I tried "mce=nobootlog" and the mce log seems to have disappeared :

[  183.276037] kjournald starting.  Commit interval 5 seconds
[  183.276462] EXT3 FS on sdb7, internal journal
[  183.276470] EXT3-fs: mounted filesystem with ordered data mode.
[  183.298408] kjournald starting.  Commit interval 5 seconds
[  183.299343] EXT3 FS on sdb8, internal journal
[  183.299351] EXT3-fs: mounted filesystem with ordered data mode.
[  374.273215] kobject: '11:0:0:0' (ffff8801279c4448): kobject_uevent_env
[  374.273231] kobject: '11:0:0:0' (ffff8801279c4448): fill_kobj_path:
path = '/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host11/target11:0:0/11:0:0:0'
[  374.274167] kobject: 'sr0' (ffff880127127608): kobject_uevent_env
[  374.274194] kobject: 'sr0' (ffff880127127608): fill_kobj_path: path
= '/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host11/target11:0:0/11:0:0:0/block/sr0'
[  376.119589] kobject: '65534' (ffff88011c4c8060):
kobject_add_internal: parent: 'uids', set: 'uids'
[  376.119618] kobject: '65534' (ffff88011c4c8060): kobject_uevent_env
[  376.119640] kobject: '65534' (ffff88011c4c8060): fill_kobj_path:
path = '/kernel/uids/65534'

Now that you mention it, I always shut down the system from Linux,
because reboot doesn't work(from windows vista 32bit it works). If I
reboot the system from Linux it goes down, but then it enters a cycle
of automatic power down power up(with a beep) and it never stops until
I switch off the power supply.
