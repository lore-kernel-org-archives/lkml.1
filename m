Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYCYPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYCYPta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbYCYPtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:49:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:32969 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbYCYPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=copfuqJILBK0at/fYHP4SvVyEEirfkBds12rUgfmfZ8MmEFHunUlzRo7+N1sAiYrZkPs5uJoBNbJJzOZxKfHvIo3d2bJu+bYAqSbQ7FwQWB3A4a9BpNxtXCdfbXV/USu2OH1EJ5io/QhStog0EwABUeJponVmVV/VEXJrZyxXBc=
Message-ID: <2c0942db0803250849h5c784667if208a908d0bd4aed@mail.gmail.com>
Date: Tue, 25 Mar 2008 08:49:13 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: Kai <epimetreus@fastmail.fm>
Subject: Re: Serious performance regression in Wine applications and Linux 2.6.24.*
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1206447122.8428.1244147147@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206240595.9045.1243810639@webmail.messagingengine.com>
	 <2c0942db0803222147y27954bd6hf4cb0cc98ceda2da@mail.gmail.com>
	 <1206447122.8428.1244147147@webmail.messagingengine.com>
X-Google-Sender-Auth: 1d9a76c884ab8ae9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 5:12 AM, Kai <epimetreus@fastmail.fm> wrote:
>
>  On Sat, 22 Mar 2008 21:47:52 -0700, "Ray Lee" <ray-lk@madrabbit.org>
>  said:
>
>
> > On Sat, Mar 22, 2008 at 7:49 PM, Kai <epimetreus@fastmail.fm> wrote:
>  > > Performance degrades by about 60% when I run Wine under any of the
>  > >  2.6.24.* kernels. Attached are the output of lspci -vv and the two
>  > >  config files of each kernel.
>  > >
>  > >  I upgraded to 2.6.24, back to 2.6.23.(not sure), then tried 2.6.24.1 and
>  > >  2.6.24.3 and the issue is present in both; it's severe enough that Wine
>  > >  apps are virtually unusable for me with this version of the kernel; I'm
>  > >  having to use 2.6.23 until this somehow is resolved.
>  > >
>  > >  I'd like some help figuring out why this performance regression exists,
>  > >  and what can be done to mitigate it.
>  >
>  > As wine has a 'wineserver' running in a separate process, it may be
>  > related to scheduler changes.
>  >
>  > Regardless, if you have the time, please retest using he latest git
>  > head (or nightly snapshot), and see if the performance regression is
>  > still there, and report back. (There have been a lot of changes
>  > between 2.6.24 and current git head that impact the scheduler.)
>  >
>  > Please ensure that the fair group scheduler is disabled in your tests
>  > (just as you have in your 2.6.24 config you attached).
>
>  As mentioned in another response, it was happening as recently as
>  2.6.25-rc6-git7; I'm currently performing a git bisect between 2.6.23
>  and 2.6.24, unless someone has a better idea; it seems my best option,
>  as I'm not really very experienced with kernel hacking or debugging.
>

Andi's idea of looking for excessive context switches is good -- I
didn't see a response to that one. Other than that, if you're only
noticing the issue in 3d games, then it could be several things (not
just the scheduler). Even just a few bisects (or testings of nightly
snapshots) would help narrow it down.

Ray
