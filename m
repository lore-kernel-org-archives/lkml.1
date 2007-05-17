Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXEQJNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXEQJNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEQJNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:13:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:61147 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbXEQJNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=X0W+7KmNAfXAg+h+ZCSWdP6sn1DqO/2oYlC6OEHSEmylW0g/oUvab+DdDbfkVohE4VgStL3SpqGUSzNVlor7jsqoRZktMjQodExG4pzbBs7LpZw6qaPxc8fEqUhlToxirp6+cr+CeZfoXmk/NjJIvoOF9rq78qf2OtNesf9ttcg=
Message-ID: <464C1C7E.10803@gmail.com>
Date: Thu, 17 May 2007 11:12:30 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Francesco Pretto <ceztko@gmail.com>, Dave Jones <davej@redhat.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <200705160129.16048.rob@landley.net> <e5ab0f710705160215p6b11bffeh53796b1b2223fd6d@mail.gmail.com> <200705161947.36177.rob@landley.net>
In-Reply-To: <200705161947.36177.rob@landley.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
>> Distros should update their shutdown(8) to do the followings.
>> Check whether /sys/modules/libata/parameters/spindown_compat exists. If it
>> does, write 0 to it. For each libata harddisk
>> Check whether /sys/class/scsi_disk/h:c:i:l/manage_start_stop exists. If it
>> doesn't, synchronize cache and spin the disk down as before. If it does, do
>> nothing and continue to the next disk. The file is also accessible as
>> /sys/block/sdX/device/scsi_disk:*/manage_start_stop.
> 
> You're saying all this is to work around kernels _before_ 2.6.22, and instead 
> of updating your shutdown you could just either update the kernel instead?

Yeap, I was assuming most shutdown(8)s were spinning down disks, which
apparently is wrong.  If shutdown(8) doesn't do that, you can just
upgrade the kernel and be done with it.  I'll submit update for the page
in a few hours.

>> If exists some, at this point, exotic shutdown(8) implementation that
>> is trying to issue STANDBYBOW on libata/scsi devices, it will get a
>> fat warning. The warning could also state that the only supported way
>> is to leave complete responsibility of spinning down the hard disks to
>> kernel, so eventually it could be cleaned of checks and compatibility
>> options.
> 
> I'm all for leaving this to the kernel.  I play in the embedded space a lot, 
> so the less I can get away with doing, the better. :)

Yeap, that's what's being done here.  For all SCSI disks (real SCSI,
SATA, USB, whatnot), it's now controlled by sysfs node
manage_start_stop.  Low level drivers can turn them on by default and
userland can change them by echoing to it.

-- 
tejun
