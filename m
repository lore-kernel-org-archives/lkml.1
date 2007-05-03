Return-Path: <linux-kernel-owner+w=401wt.eu-S1161276AbXECVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161276AbXECVMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031350AbXECVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:12:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:51485 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031349AbXECVML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bm0VoteNxnq9xvOYA3SQnxBO/ZbhhAYV9VT5nhLdTS6iYnmlhC65OuJX0m9UM5YwhV7vOSwOnxsLhmpE+A4QKbRiTElF5CID6P9wwnIWKNiIDLpB5dso23eRN/LR1ulPK932yRbOmYgGLrudKRFAB9KtGs7rYAIUwDVjTGP92Uw=
Message-ID: <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com>
Date: Thu, 3 May 2007 23:12:09 +0200
From: "=?ISO-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?=" <lorrides@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
	 <20070503205341.GB943@1wt.eu>
	 <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On May 3 2007 22:53, Willy Tarreau wrote:
> >> For the rest all we see in the arp cache is (incomplete)
> >
> >I suspect that your arp cache is full (128 entries by default).
> >Check /proc/sys/net/ipv4/neigh/gc_thresh1 (128 for me). You can
> >set it as high as gc_thresh2 (512 for me), and I don't know what
> >happens above.
>
> Above, you will perhaps need the not-so-elegant userspace arpd :-/

Yes, i was suspecting that the arp cache got full, but i will try
increasing it :)
Would there be any huge bugs if i change these lines in arp.c:

        .gc_thresh1 =   128,
        .gc_thresh2 =   512,

to

        .gc_thresh1 =   700,
        .gc_thresh2 =   700,

under the definition for struct arp_tbl?
This setup will only run for about 1-2 hours while we fix the hardware
router (it is running now, but only on a backup flash card solution.
the harddrive in it died ;)

I have been looking at arpd, but i quickly discarded it as an option
since its marked both experimental and obsolete ;)

regards
Øyvind Vågen Jægtnes
+47 96 22 03 08
lorrides@gmail.com
