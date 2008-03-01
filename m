Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYCAKuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYCAKuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 05:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYCAKuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 05:50:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:47775 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYCAKuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 05:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lNcv02NIwat6zx/aRnagX+F4bZPSv//xefhMzL3H6BxxhW4Cr/Mtn2zHpMKjD5CtsZuFfPr+Ft9RcycdXSZThjHTjucDYIdZ6jtlMNa+KbnjtsgRFfKKUJ47ugXsZPkn8TrDwsDZky9CuWpgfQ88jNnRq+9Yxq59A8i0zQKg2zQ=
Message-ID: <b6fcc0a0803010250p42035759r97babcca98adaaec@mail.gmail.com>
Date: Sat, 1 Mar 2008 13:50:03 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: ptb@inv.it.uc3m.es
Subject: Re: sysctl in 2.6.24.2 excludes unapproved files from /proc/sys?
Cc: "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200803010222.m212MAq16160@inv.it.uc3m.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6fcc0a0802291746y7375ba71ja0dc0beb58c4ccb1@mail.gmail.com>
	 <200803010222.m212MAq16160@inv.it.uc3m.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/08, Peter T. Breuer <ptb@inv.it.uc3m.es> wrote:
> "Also sprach Alexey Dobriyan:"
> > On 3/1/08, Peter T. Breuer <ptb@inv.it.uc3m.es> wrote:
> > > A change in 2.6.24.x kernel/sysctl.c seems to exclude exo-kernel drivers
> > > from using the /proc/sys/ interface:
> >
> > That's somewhat correct.
>
> OK. Thanks. That's a relief. It's always good to know that it's the
> universe that's crazy, not me.
>
> > > What's a person to do?
> >
> > If I understand you correcty, the answer is drop '.ctl_name' bits from
> > new sysctls and make sure common parts of tables match the ones
> > in mainline.
>
> You are saying, O wise delphic oracle, that I *can* add stuff in the
> /proc/sys tree, provided it's at an approved leaf? Or that I must use
> CTL_UNNUMBERED for flipping efferything, not just most things? (one
> would have thought one was entitled to number things in ones own
> subdirectories, failing some comment to the contrary). I tried
> CTL_UNNUMBERED at least on my top level directory, and didn't add any
> entries to it, and THAT failed. So on the face of it that
> interpretation of your words cannot be correct.
>
> /proc/sys/dev is where I am trying to add a directory, because I am none
> of
>
> { DEV_CDROM, "cdrom", trans_cdrom_table },
> { DEV_PARPORT, "parport", trans_parport_table },
> { DEV_RAID, "raid", trans_raid_table },
> { DEV_MAC_HID, "mac_hid", trans_mac_hid_files },
> { DEV_SCSI, "scsi", trans_scsi_table },
> { DEV_IPMI, "ipmi", trans_ipmi_table },
>
> and those are the legal entries at the moment, and I can't see any
> commonality in or among any of those or between them and me.
>
> That's not a leaf. However, none of its eventual leaves have anything
> to do with my driver. So here in dev/ would be just fine to plonk a new
> device driver subtree, methinks.
>
> And you want me to use CTL_UNNUMBERED for everything in my subtree
> from where it branches off?
>
> OK. I'm game. I'll try. I've tried a lot of other things over the past
> few days.
>
> And how am I supposed to maintain this driver, now that it's full of
> #iffoo < 2.6.24 every two lines?

Out of tree driver -- nobody cares.

> And while I am here, what's the purpose of this change? What's the
> point of checking that only the pre-approved entries to this tree are
> made? I don't get it! If you don't want somebody adding something
> to /proc/sys just delete their registration call from the kernel
> tree, surely! Is this some sort of in-kernel fight? Defenders of
> /proc/sys against attackers? Is the problem that one can't persuade
> some maintainers to stop their authors from adding to /proc/sys, so
> instead it's been made it necessary to ask permission of the /proc/sys
> maintainer instead via this change?

All of this silly and not silly questions are answered by corresponding
commit message. You cited actual patch which started to error out
bad sysctl tables, have you read changelog? It will be very enlightening
for you to do so.

> Now every author has to make a change in their code AND make a change in
> the sysctl code in a totally different part of the kernel when they want
> a single change - adding a file or dir to their file hierarchy.

Correct only for "their code" part.

> And what's the registration function for, now that the details are
> largely there in sysctl.c and sysctl_check.c? It just adds detail
> like strategy and proc_handler? And says when to put up and tear down
> the subtree in question? Why not move ALL the detail over to
> kernel/sysctl.c too!
