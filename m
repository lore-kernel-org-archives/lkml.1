Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYCYRtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYCYRtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYCYRtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:49:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:20106 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbYCYRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gl3Xy+wpGRGRH20yNpFKyS1FkMbDlIuT/3aY6noH0nG0wiAa5+Ny0o8rAKFytwLLT6XXMYpHdm5jB5+tcaYBJziliOtFzInmN2qx5XnHh2yhsz/ELbs/Y9PMOW/LaBTPhNvRquYd6Scm+gzUxQsQGRq031v6AfAqvsRn/9JEMZc=
Message-ID: <5699f8f00803251049s1823098u86b5431eadad2917@mail.gmail.com>
Date: Tue, 25 Mar 2008 18:49:01 +0100
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Michael Meyer" <mike65134@yahoo.de>
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <57127.43039.qm@web25812.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87abkmhgg0.fsf@basil.nowhere.org>
	 <57127.43039.qm@web25812.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 6:23 PM, Michael Meyer <mike65134@yahoo.de> wrote:
>
>  --- Andi Kleen <andi@firstfloor.org> schrieb:
>
>
>  > Luciano Rocha <luciano@eurotux.com> writes:
>  >
>  > > On Tue, Mar 25, 2008 at 02:47:50PM +0100, Michael
>  > Meyer wrote:
>  > > > Hi,
>  > > >
>  > > > what is the difference between booting a dual
>  > core
>  > > > machine with "maxcpus=1" or by deactivating the
>  > second
>  > > > core at run time with "echo 0 >
>  > > > /sys/devices/system/cpu/cpu1/online"?
>  > >
>  > > maxcpus=1 should turn off the SMP alternative and
>  > switch to UP only,
>  > > optimising some locks and instructions.
>  >
>  > CPU hot unplug will do the same. But it is unlikely
>  > it accounts
>  > for that much performance difference.
>  >
>  > If he used maxcpus=0 it would make sense. maxcpus=0
>  > disables
>  > the IO-APIC which likely makes a large difference.
>  > But it should
>  > be actually slower.
>  >
>  > There should be actually no difference in theory
>  > between max_cpus=1
>  > and hot unplug to one CPU. Might be some bug.
>
>  I had the following time values:
>
>  maxcpus=1:
>  real    0m1.642s
>  user    0m1.528s
>  sys     0m0.068s
>
>  maxcpus=2 and
>  echo 1 > /sys/devices/system/cpu/cpu1/online:
>  real    0m2.579s
>  user    0m4.096s
>  sys     0m0.160s
>
>  maxcpus=2 and
>  echo 0 > /sys/devices/system/cpu/cpu1/online:
>  real    0m3.757s
>  user    0m3.632s
>  sys     0m0.112s
>
>

What kind of CPU are you using? Some Intel CPU's do "funny stuff",
like dynamically overclocking itself when working on a single thread,
or using all of the 2nd level cache instead of sharing it with the
second core.

Regards,
Wander Winkelhorst.
