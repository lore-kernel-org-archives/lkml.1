Return-Path: <linux-kernel-owner+w=401wt.eu-S1762991AbYBTRGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762991AbYBTRGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbYBTRGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:06:36 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:1429 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYBTRGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:06:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pod+UaO8ZjR7Eu79uxZ/dplzuGEeIafw7Jr4xwdbBtiQqY496qryCXuEtrr0KbwWGkxFdKiS9v0JiH08s1LDxybsQNkHYZIyky56gGESabkn8sHXNFUJZZtexVMQYPuiSlDpKaX1JhJMq99rOg4Kzmu6NUs4RcYlI30Fz+CqILU=
Message-ID: <47BC5E01.1050902@gmail.com>
Date: Wed, 20 Feb 2008 12:06:09 -0500
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly resolved
References: <Pine.LNX.4.44L0.0802201048410.4828-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201048410.4828-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I suspect that some of the existing CC:s can now be dropped, and others
might need to be added if indeed this is worth discussing on kernel
lists at all, but I don't know what the protocol on that is so I have
left all of them in for the moment.)

On 2/20/2008 10:50 AM, Alan Stern wrote:

> On Tue, 19 Feb 2008, Andrew Buehler wrote:
> 
>> With those two problems out of the way, what is left is the
>> hard-drive issue, and that is also halfway fixed by enabling ACPI.
>> Specifically, it is "fixed" in that the kernel sees the hard drive
>> and I can mount it, but it is not fixed in that the program we need
>> to use in this environment does not see the drive.
> 
> What do you mean by "does not see the drive"?

Its detect-hardware-and-report mode shows a HD size of 0 (which is what
it has showed in cases where the kernel has not detected the drive), its
detect-partitions-and-report mode shows no partitions and no devices
which can have partitions, and attempting to actually use it to pull
down a drive image (it's a disk-imaging program) causes it to hang at
the point where it would begin to write.

Hmm. One thing which just sprang to mind, in the stab-in-the-dark
category: in 2.6.24.2, launching the program on some machines gave
warnings along the lines of "this program is using a deprecated ioctl,
please convert it to SG_IO" (which I naturally cannot do since it's
closed and I don't have the source), but IIRC in the 2.5.25-rc2-based
disc with ACPI enabled no such message appears. If the reason that there
are no longer such messages is that the ioctl in question has now been
removed, that might explain why the program does not see the drive.

I have suspected that I might eventually need to port the old interface
forwards to be able to continue to use this program, but I did not
expect it to happen this soon...

>> I have a config from a boot disc running 2.6.5 (that's not a typo)
>> under which the program in question *does* see the drive, but there
>> are massive differences between that config and the one I am using
>> now, and narrowing the critical difference down is likely to be
>> somewhat difficult - particularly since some of the "differences"
>> are merely renamed config symbols (i.e. the
>> CONFIG_SCSI_SATA_*->CONFIG_SATA_* switchover), and I have limited
>> ability to tell which without intensive investigation. Are there
>> any established techniques for simplifying this kind of comparison?
> 
> The only established technique is to run various kernels intermediate
> between the one that works and the one that fails.

I'm not sure I expressed myself clearly. I do not think the problem is
with the different kernels. I think the problem is with the different
configurations. I am asking if there are any established techniques for
comparing differences between config files from widely different
kernels.

Or, if you're suggesting running various kernels with configs which are
hybrids of the config which works and the current one which does not: in
order to do that I have to be able to tell what the actual differences
are, and at minimum the renamed symbols (not all of which I expect to be
able to identify at a glance) would make that quite difficult to do, so
I remain with the same problem and the same question.

-- 
    Andrew Buehler
