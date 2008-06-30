Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYF3HrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYF3HrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYF3Hqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:46:50 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:54401 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbYF3Hqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:46:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=In-Reply-To:Received:Date:Cc:To:From:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=n9gLnGAMWCboAxa4pVCTfG1la7xBB1rVgsfXlt2lvw/XAqgTHVmKJfcimfq+jf6pj
	axfVsrI/5jrx6zHv7hd6LTUVyPxATdjtt/J7Ptl5CJTq45QsFMuPv/vJHLqX/2vDeLJ
	+oEonuVcknVQtzU/4LZMAmlGHfO9fzJPsfBTxfU=
In-Reply-To: <20080630033943.332471860046@mail171-va3.bigfish.com>
Date: Mon, 30 Jun 2008 09:11:55 +0200 (CEST)
Cc: =?us-ascii?Q?John=20Williams?= <john.williams@petalogix.com>,
       grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org,
       =?us-ascii?Q?John=20Linn?= <linnj@xilinx.com>, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       =?us-ascii?Q?Michal=20Simek?= <monstr@monstr.eu>
To: microblaze-uclinux@itee.uq.edu.au
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?RE=3A=20=5BPATCH=2012=2F60=5D=20microblaze=5Fv4=3A=20Generic=20dts=20file=20for=20platforms?=
Mime-Version: 1.0
Message-Id: <4121.6641-32593-1821693405-1214809915@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm3<133774415>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve, John a others,

>In my opionion, we should only include dts files for reference designs, and it
>must be documented how to get the design that the dts corresponds to.
>MD5 hashing might be one way to prevent people from getting the dts file wrong,
>however without some way of checking it automatically, I don't think
>anyone will have the patience to checksum the design they have (even worse, with
>whitespace changes, the md5 sum will change, so this is pretty fragile.

What is reference design? Is reference design design from BSB or from Xilinx page?
I don't want to add dts files to kernel which has relation with reference design. I added platform folder
with generic one for preparing for others distribution which can add their supported board. I don't want 
to added useless files to kernel. For non FPGA board make sense to me, they can't change everything.

I see the way that I can add ref design to my pages with correspond DTS file with some MD5 sums 
but I haven't seen to add for every reference board dts file. This is not way. I see that people will write to us
that they use board ml401 and they set ml401 in menuconfig but the kernel doesn't work. IMHO, if no board specific options
are not there, people will be looking for what is the next step. And If they want to use platform option which is there, they can add their own platform to his kernel. 

>Having a device tree in the kernel for documentation *shouldn't* be necessary,
>since noone should ever write their dts by hand. (right?)
>Hence, I'd prefer to not put the dts file in the kernel at all, and but to
>automatically generate the dts and store it in the blockram of the design.
>This inextricably associates the dts with the design.

This should be one choice to add DTB to bram with design but this could be only one choice
not in general. I can't imagine for example board where is reset logic on own IP which has specific 
reason. Developers will be overwrite their DTS a lot. 
I think this is the right time to stop discussion in this thread and annoying others with FPGA specific discuss. We can continue in specific thread.

>As for the copyright, I haven't been able to find much information on whether or
>not generated files are even copyrightable.  One might argue that they
>don't have sufficient 'creative value' to be copyrightable.  Or arguably, they
>are as copyrightable by the generator author as by the author or the .mhs file.
>I admit in this case, I've followed the safe route by claiming a copyright,
>which at least at Xilinx has significant precedent.

This part can be discuss only on microblaze mailing list and has no relation with first pull to mainline kernel.
As I wrote in previous email copyright on generic DTS will not be there.

Michal

>Steve

-----Original Message-----
From: John Williams [mailto:john.williams@petalogix.com]
Sent: Sun 6/29/2008 5:02 PM
To: grant.likely@secretlab.ca
Cc: monstr@seznam.cz; linux-kernel@vger.kernel.org; arnd@arndb.de;
linux-arch@vger.kernel.org; Stephen Neuendorffer; John Linn; matthew@wil.cx;
will.newton@gmail.com; drepper@redhat.com; microblaze-uclinux@itee.uq.edu.au;
linuxppc-dev@ozlabs.org; vapier.adi@gmail.com; alan@lxorguk.ukuu.org.uk;
hpa@zytor.com; Michal Simek
Subject: Re: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
 
On Sat, Jun 28, 2008 at 3:49 PM, Grant Likely <grant.likely@secretlab.ca>
wrote:
> On Thu, Jun 26, 2008 at 5:29 AM,  <monstr@seznam.cz> wrote:
>> From: Michal Simek <monstr@monstr.eu>

>>  arch/microblaze/platform/generic/system.dts |  300
+++++++++++++++++++++++++++

> Since this is a generated file, and entirely bitstream specific, does
> it make sense to include it in the kernel tree?  If it does, then is
> it produced from one of the Xilinx reference designs?  Can you add
> documentation to the header that specifies exactly which design
> version this .dts is for?

I think there's value in having a generic DTS as an example or
template, even if it doesn't correspond to any specific machine.
Agreed a comment block explaining this is valuable.

I'd almost oppose any attempt to include a standard DTS for things
like ML401 boards etc - they are just misleading.  Unless we do MD5
hashes on MHS files, and use them as the filenames, any attempt to
define a standard platform will just fail and confuse people.  Better
to show them how to generate the DTS for their system.

>> +/*
>> + * (C) Copyright 2007-2008 Xilinx, Inc.
>> + * (C) Copyright 2007-2008 Michal Simek
>> + *
>> + * Michal SIMEK <monstr@monstr.eu>
>
> If this is a generated file, then is this copyright notice even appropriate?

I agree.  I think Michal is just copying Xilinx's habit of putting
copyright headers in generated files, and it's one that we should stop
now.

Regards,

John




This email and any attachments are intended for the sole use of the named
recipient(s) and contain(s) confidential information that may be proprietary,
privileged or copyrighted under applicable law. If you are not the intended
recipient, do not read, copy, or forward this email message or any attachments.
Delete this email message and any attachments immediately.



