Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYCZHP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYCZHP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYCZHPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:15:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:28722 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYCZHPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XxFWPzwyxg7Bs8GmAC51+vZcSSWzX679YMEeFekRZ/i7p8ev7sKuDq+tfxwhyt3JMMRRnE8wdOuQWj04zxnzeTODFlbuYVCI5Osprq8EyBEgUJwPPzFsO9RQPGsVXDFksaqHWLg9EV8AYJAtAnAd35k+ovkXmNqCegYqOG3lQC8=
Message-ID: <e2e108260803260015l5e8ba4f7n4fdbac771b13cbba@mail.gmail.com>
Date: Wed, 26 Mar 2008 08:15:15 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: RAID-1 performance under 2.4 and 2.6
Cc: "Emmanuel Florac" <eflorac@intellique.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47E975F8.3000702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080325194306.4ac71ff2@galadriel.home>
	 <47E975F8.3000702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 11:00 PM, Chris Snook <csnook@redhat.com> wrote:
> Emmanuel Florac wrote:
>  > I post there because I couldn't find any information about this
>  > elsewhere : on the same hardware ( Athlon X2 3500+, 512MB RAM, 2x400 GB
>  > Hitachi SATA2 hard drives ) the 2.4 Linux software RAID-1 (tested 2.4.32
>  > and 2.4.36.2, slightly patched to recognize the hardware :p) is way
>  > faster than 2.6 ( tested 2.6.17.13, 2.6.18.8, 2.6.22.16, 2.6.24.3)
>  > especially for writes. I actually made the test on several different
>  > machines (same hard drives though) and it remained consistent across
>  > the board, with /mountpoint a software RAID-1.
>  > Actually checking disk activity with iostat or vmstat shows clearly a
>  > cache effect much more pronounced on 2.4 (i.e. writing goes on much
>  > longer in the background) but it doesn't really account for the
>  > difference. I've also tested it thru NFS from another machine (Giga
>  > ethernet network):
>  >
>  > dd if=/dev/zero of=/mountpoint/testfile bs=1M count=1024
>  >
>  > kernel        2.4       2.6        2.4 thru NFS   2.6 thru NFS
>  >
>  > write        90 MB/s    65 MB/s      70 MB/s       45 MB/s
>  > read         90 MB/s    80 MB/s      75 MB/s       65 MB/s
>  >
>  > Duh. That's terrible. Does it mean I should stick to  (heavily
>  > patched...) 2.4 for my file servers or... ? :)
>
>  It means you shouldn't use dd as a benchmark.

If you want to benchmark write speed, you should add
oflag=direct,dsync to the dd command line. For benchmarking read speed
you should specify iflag=direct. Or, even better, you can use xdd with
the flags -dio -processlock.

Bart.
