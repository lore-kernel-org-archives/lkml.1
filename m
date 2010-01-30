Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706Ab0A3Axo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0A3Axo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 19:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953Ab0A3Axn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 19:53:43 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:37296 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752620Ab0A3Axn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 19:53:43 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 19:53:42 EST
From: Michael Poole <mdpoole@troilus.org>
To: Bastien Nocera <hadess@hadess.net>, Marcel Holtmann <marcel@holtmann.org>
Cc: Jiri Kosina <jkosina@suse.cz>, "Gunn\, Brian" <bgunn@solekai.com>,
       Ping <pinglinux@gmail.com>, linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 0/3] HID: make raw output callback more flexible
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<1264783166.29532.5302.camel@localhost.localdomain>
Date: Fri, 29 Jan 2010 19:46:39 -0500
In-Reply-To: <1264783166.29532.5302.camel@localhost.localdomain> (Bastien
	Nocera's message of "Fri, 29 Jan 2010 16:39:26 +0000")
Message-ID: <87iqakifm8.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien Nocera writes:

> On Fri, 2010-01-29 at 15:20 +0100, Jiri Kosina wrote:
>> Hi,
>> 
>> this is a followup to the thread
>> 
>> 	"Implement Bluetooth Wacom tablet's mode change in the kernel"
>> 
>> First patch alters the raw output API so that it is able to actually 
>> distinguish between feature and output reports (and modifies low-level 
>> drivers accordingly), and the two followup patches make use of this for 
>> in-kernel mode setting of Sony and Wacom bluetooth devices.
>> 
>> Marcel, could you please review the Bluetooth part?

Count this as another vote for review, please -- I have a similar
patch[1] that I would prefer to drop.

[1]- http://www.spinics.net/lists/linux-input/msg06768.html

> Patches 1 and 2 work as expected (minus the hidp parsing issue[1]).
> Couldn't test patch 3 for the Sony Sixaxis right now.
>
> Cheers
>
> [1]: Comments on the patch at
> http://thread.gmane.org/gmane.linux.bluez.kernel/4279 would be
> appreciated

This patch does not work for me.  Before, the first time after each boot
that I tried to connect to an Apple Magic Mouse, it failed with -14
(EFAULT).  With this patch, it fails with -22 (EINVAL) instead.  The
-EFAULT *was* due to hidp_parse()'s copy_from_user().  I have not looked
yet to see where the -EINVAL is coming from -- would that help?  (Both
with and without your patch, the second attempt to connect works.)

Michael Poole
