Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYAYRRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYAYRRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYAYRQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:16:58 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:2091 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbYAYRQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I0PcMbudukFDC8JNxvkyqhqZoNmHmey/yxewAiTMQD39ayvGPb0tuthfsyG9hyCQP93VqolIgvsfX6aP4HCiEHIUoxxe4jfbZQhxUxVbyuJ4k0Q+8JhKNjoLQX53YnqefMl2V+gA+KFcG2uO/zYkT3bxJT/OqFl+v+9IGKqSRcw=
Message-ID: <2c0942db0801250916v6b1f988fre454dd7e33d7985@mail.gmail.com>
Date: Fri, 25 Jan 2008 09:16:54 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Asbjorn Sannes" <asbjorsa@ifi.uio.no>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Unpredictable performance
In-Reply-To: <4799C8E8.9060501@ifi.uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4799C8E8.9060501@ifi.uio.no>
X-Google-Sender-Auth: 8e830b583479ddc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 3:32 AM, Asbjorn Sannes <asbjorsa@ifi.uio.no> wrote:
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

First off, not all tests are good tests. In particular, small timing
differences can get magnified horrendously by heading into swap.

That said, do you have the means and standard deviations of those
runs? That's a good way to tell whether the tests are converging or
not, and whether your results are telling you anything.

Also as you're on a uniprocessor system, make -j2 is probably going to
be faster than make -j3. Perhaps immaterial to whatever you're trying
to test, but there you go.
