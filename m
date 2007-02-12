Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXBLSRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXBLSRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964971AbXBLSRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:17:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:32320 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988AbXBLSRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:17:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c1jj/kD4xyNQoWxmDIftyPtG+cunPI3QXnn2xPAK1GtBBW+zPOnNoEtUhN3tL3kzlAZWaQLAZyih8pSHvaNG96hsu1lkTkeVfqQulNtFYyMxkduXcxaZnS7p0ijv2kF9INrKesoe952RcCCQhBH6z2jmN/q4fjpGGhVmHI1LN9M=
Message-ID: <2c0942db0702121017i3ab273b0qf9f31654f73519ba@mail.gmail.com>
Date: Mon, 12 Feb 2007 10:17:03 -0800
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Martin A. Fink" <fink@mpe.mpg.de>
Subject: Re: SATA-performance: Linux vs. FreeBSD
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200702121856.29729.fink@mpe.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702121502.17130.fink@mpe.mpg.de>
	 <200702121727.17108.fink@mpe.mpg.de> <p731wkvi5go.fsf@bingen.suse.de>
	 <200702121856.29729.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Martin A. Fink <fink@mpe.mpg.de> wrote:
> Am Montag, 12. Februar 2007 19:41 schrieben Sie:
> I have to store big amounts of data coming from 2 digital cameras to disk.
> Thus I have to write blocks of around 1 MB at 30 to 50 frames per second for
> a long period of time. So it is important for me that the harddisk drive is
> reliable in the sense of "if it is capable of 50 MB/s then it should operate
> at this speed. Constantly."

Ah, here is a misunderstanding, I think. By default, Linux won't start
writing out dirty buffers until something like 40% of memory is used.
This is to help common workloads where many temporary files are
created and destroyed, or even data that gets written then overwritten
shortly after.

If the kernel were to immediately write out that dirty data, it would
be slower than leaving it in memory for those workloads. But since
that isn't best for everyone, there's a parameter that controls that
dirty threshold. Setting that to a lower value will help even out the
writeout, and start it early, just as you seem to be requesting.

Hmm, it may be one of:

/proc/sys/vm/dirty_ratio
/proc/sys/vm/dirty_background_ratio

Try tweaking those to much lower values and see if that helps.

Ray
