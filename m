Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbXIPRxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbXIPRxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXIPRx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:53:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:22090 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbXIPRx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WP8S5Zem85yqCASWNRIBO35xUPBOz43VjHczeFKRhLN2FpEM9gjG8mjJZySyXdTPXpKbaOtPiVVweYg0LiapW9+796Yg6xMKNKwhENDAQplpiC+7LWPv6Rfft1jeNtK2AhIOpeEQXYbe1CL7qZZVGhGgySY/3ktHXe/RQjtVv5I=
Message-ID: <86802c440709161053x7f549e84u815c6494d921d393@mail.gmail.com>
Date: Sun, 16 Sep 2007 10:53:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Howard Chu" <hyc@symas.com>, "Andi Kleen" <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: MTRR initialization
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46ED54EF.3040209@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46EAB7DA.10507@symas.com>
	 <86802c440709141012w1e85e4caue0d2c7f849dba1cb@mail.gmail.com>
	 <46ED54EF.3040209@symas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/07, Howard Chu <hyc@symas.com> wrote:
> Yinghai Lu wrote:
> > On 9/14/07, Howard Chu <hyc@symas.com> wrote:
> >> Hi, was wondering if anyone else has been tripped up by this... I've got 4GB of
> >> RAM in my Asus A8V Deluxe and memory hole mapping enabled in the BIOS. By
> >> default, my system boots up with these MTRR settings:
> >>
> >> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> >> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> >> reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> >> reg03: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1

if rev F before cpu aka Rev E is installed, and 8G RAM installed, it will be
> >> reg00: base=0x00000000 (   0MB), size=8192MB: write-back, count=1
> >> reg01: base=0x100000000 (8192MB), size=1024MB: write-back, count=1
> >> reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> >> reg03: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1
and you will have problem...

So good way is get the ram top, and hole size...and reset the whole
set ot var mtrr.

you could refer the code in LinuxBIOS about setting that...
http://www.openbios.org/viewvc/trunk/LinuxBIOSv2/src/cpu/x86/mtrr/mtrr.c?revision=2616&view=markup
esp the part about CONFIG_VAR_MTRR_HOLE...

but Andi and Eric said resetting mtrr is not good... when someone from
intel try to trim the MTRR for intel CPU.

YH
