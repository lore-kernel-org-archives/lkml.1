Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbYJaNfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbYJaNfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYJaNfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:35:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:26546 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYJaNfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=tR4SqQ3QroxOH9UyCTdescKTfSolbspnJdA6orREm14DI1qNwEsCok2lby2O5gKY5v
         i3SIb6yS8dxTfMZED6qKrXgDnC5xGQ0hpA8YqV4flfgwHvKtxqOJhXFFNF53FOqF3vnr
         5Y5Lsh/yU/XMwCVxDxMjmch/VILYLpTl8wmsE=
Message-ID: <490B0987.2050801@tuffmail.co.uk>
Date: Fri, 31 Oct 2008 13:35:03 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Shivdas Gujare <shivdas.tech@gmail.com>
CC: linux-kernel@vger.kernel.org, beagleboard@googlegroups.com
Subject: Re: Diff between Linux-2.6.27-omap1-dirty and Linux-2.6.27-omap1
 ?
References: <cf70f0210810310608x37f8e3dcu3ab0023891fcb339@mail.gmail.com>
In-Reply-To: <cf70f0210810310608x37f8e3dcu3ab0023891fcb339@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shivdas Gujare wrote:
> Hi All,
> 
> I am working on testing Linux-2.6.27 omap kernel on beagle board.
> 
> I cloned kernel from
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
> 
> and checked out to tag v2.6.27-omap1, I loaded kernel on beagle board,
> and was able to boot properly like....
> 
> OMAP3 beagleboard.org # bootm 0x80300000
> ## Booting kernel from Legacy Image at 80300000 ...
>    Image Name:   Linux-2.6.27-omap1
>    Image Type:   ARM Linux Kernel Image (uncompressed)
>    Data Size:    1614320 Bytes =  1.5 MB
>    Load Address: 80008000
>    Entry Point:  80008000
>    Verifying Checksum ... OK
>    Loading Kernel Image ... OK
> OK
> 
> Now, I done some operations, like checkout to master, checkout to
> v2.6.26-omap1 and v2.6.25-omap1, loaded corresponding uImages to
> beagle board
> and was able to boot board every time.
> 
> After this, I again checkout to v2.6.27-omap1, compiled and loaded
> uImage to beagleboard
> But this time I am not able to boot the board.
> and Got the message like
> 
> OMAP3 beagleboard.org # bootm 0x80300000
> ## Booting kernel from Legacy Image at 80300000 ...
>    Image Name:   Linux-2.6.27-omap1-dirty
>    Image Type:   ARM Linux Kernel Image (uncompressed)
>    Data Size:    1669176 Bytes =  1.6 MB
>    Load Address: 80008000
>    Entry Point:  80008000
>    Verifying Checksum ... OK
>    Loading Kernel Image ... OK
> OK
> 
> Starting kernel ...
> 
> Uncompressing Linux...........................................................................................................
> done, booting the kernel.
> 
> and it, stucks at here..
> 
> Here, the only difference I observed is "Image Name:
> Linux-2.6.27-omap1" and "Image Name:   Linux-2.6.27-omap1-dirty",
> where uImage with second Image name is not booting.
> 
> I think, I have done something wrong here, while compilation and checkout.
> 
> I just want to know in what cases "-dirty" is appended to linux kernel
> Image Names or anything I done wrong?

-dirty is appended to the version string when there are differences between the working tree and the git HEAD.  In other words, it sounds like you accidentally modified some file.

You can see which files have been modified with "git status".  It will also show extra files under "untracked"; you may see a few arch-specific object files, but all the .o, .ko, etc. files will be hidden by virtue of gitignore.

If the files were modified before the last "git checkout", it would have tried to preserve the modifications.  It would also warn you by listing the files, with an "M" next to their name.

Hope that helps.  You described your problem very well, btw.

Regards
Alan
