Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbXITQOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbXITQOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbXITQOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:14:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:21484 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbXITQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M0y6w3rFlPIrHmSaRfh0lLMTxdiWb2VZWX1LnFH166F3aPrMy0XOgowPN+TYsZglt+R07ehVtL3QCYbUIFm0AyYj+rqPHEfNR1ycBnTPcYWzp47kBmAOftB4y+J+e1+uBE6Jn3xnlgBDq4AG65NIG4VoscHE4ZsQ27ZklLS4fck=
Message-ID: <2c0942db0709200914p5ba04307pee519d4991f62299@mail.gmail.com>
Date: Thu, 20 Sep 2007 09:14:09 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Low Yucheng" <ylow@andrew.cmu.edu>
Subject: Re: PROBLEM: System Freeze on Particular workload with kernel 2.6.22.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46F0E19D.8000400@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46F0E19D.8000400@andrew.cmu.edu>
X-Google-Sender-Auth: 217ed5ea81465a8c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Low Yucheng <ylow@andrew.cmu.edu> wrote:
> [1.] Summary
> System Freeze on Particular workload with kernel 2.6.22.6
>
> [2.] Description
> System freezes on repeated application of the following command
> for f in *png ; do convert -quality 100 $f `basename $f png`jpg; done
>
> Problem is consistent and repeatable.
> Problem persists when running on a different drive, and also in pure console (no X).
>
> One time, the following error logged in syslog:
> Sep 19 04:22:11 mossnew kernel: [  301.883919] VM: killing process convert
> Sep 19 04:22:11 mossnew kernel: [  301.884382] swap_free: Unused swap offset entry 0000ff00
> Sep 19 04:22:11 mossnew kernel: [  301.884421] swap_free: Unused swap offset entry 00000300
> Sep 19 04:22:11 mossnew kernel: [  301.884456] swap_free: Unused swap offset entry 00000200
> Sep 19 04:22:11 mossnew kernel: [  301.884491] swap_free: Unused swap offset entry 0000ff00
> Sep 19 04:22:11 mossnew kernel: [  301.884527] swap_free: Unused swap offset entry 0000ff00
> Sep 19 04:22:11 mossnew kernel: [  301.884562] swap_free: Unused swap offset entry 00000100
>
> Should not be a RAM problem. RAM has survived 12 hrs of Memtest with no errors.
> Should not be a CPU problem either. I have been running CPU intensive tasks for days.

The "Unused swap offset entry" is almost always a sign of bad memory,
if google can be trusted. Your workload is *extremely* CPU and memory
intensive (and even hits the disk!), so this looks like bad RAM, bad
cooling, or a marginal power supply that is failing under load.

memtest86+ doesn't stress the CPU nearly as much, so it often doesn't
show all the problems.

Take your RAM down to one stick and try again (looks like you have 2G
installed?). If that still fails, try different RAM. If that still
fails, then swap out the power supply for another if you can, and try
again.

Ray
