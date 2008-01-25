Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbYAYOAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbYAYOAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYAYOAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:00:40 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:37493 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754973AbYAYOAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:00:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0TaA9qEzgsABbbgWyd0hxuGXYCQmLA73qRvjcxxPC/1tfvpZZ1K704EErPUnyEvgddUqf8ksieV75TWcL8zFfPkBaeo0KHW0zDguO3xUyD4S0BAagYKA/8XaGUQYGCEeC1xjSNk8QDjmgB8ifl40OCe5ZonhIiESTQhp91TbJuQ=  ;
X-YMail-OSG: R_qeSf4VM1nirrDJt9bB4Fheg.xUJM3OqKZuQgOkVaqMu2Diex0lVDQ55RvwJjLQ8.NRkV6_7A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Asbjorn Sannes <asbjorsa@ifi.uio.no>
Subject: Re: Unpredictable performance
Date: Sat, 26 Jan 2008 01:00:24 +1100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4799C8E8.9060501@ifi.uio.no>
In-Reply-To: <4799C8E8.9060501@ifi.uio.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801260100.24597.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 22:32, Asbjorn Sannes wrote:
> Hi,
>
> I am experiencing unpredictable results with the following test
> without other processes running (exception is udev, I believe):
> cd /usr/src/test
> tar -jxf ../linux-2.6.22.12
> cp ../working-config linux-2.6.22.12/.config
> cd linux-2.6.22.12
> make oldconfig
> time make -j3 > /dev/null # This is what I note down as a "test" result
> cd /usr/src ; umount /usr/src/test ; mkfs.ext3 /dev/cc/test
> and then reboot
>
> The kernel is booted with the parameter mem=81920000
>
> For 2.6.23.14 the results vary from (real time) 33m30.551s to 45m32.703s
> (30 runs)
> For 2.6.23.14 with nop i/o scheduler from 29m8.827s to 55m36.744s (24 runs)
> For 2.6.22.14 also varied a lot.. but, lost results :(
> For 2.6.20.21 only vary from 34m32.054s to 38m1.928s (10 runs)
>
> Any idea of what can cause this? I have tried to make the runs as equal
> as possible, rebooting between each run.. i/o scheduler is cfq as default.
>
> sys and user time only varies a couple of seconds.. and the order of
> when it is "fast" and when it is "slow" is completly random, but it
> seems that the results are mostly concentrated around the mean.

Hmm, lots of things could cause it. With such big variations in
elapsed time, and small variations on CPU time, I guess the fs/IO
layers are the prime suspects, although it could also involve the
VM if you are doing a fair amount of page reclaim.

Can you boot with enough memory such that it never enters page
reclaim? `grep scan /proc/vmstat` to check.

Otherwise you could mount the working directory as tmpfs to
eliminate IO.

bisecting it down to a single patch would be really helpful if you
can spare the time.

Thanks,
Nick
