Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYDOXRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYDOXRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYDOXRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:17:30 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:43380 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751536AbYDOXR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:17:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TSyDOiFTYSt8+EszNgXFDki5nyudoTC4q3xAOtzDjAdjTMZUX5aDhmfPucHQcN+F1xAxWuxfoXTj/qUNf1DTGK7f+ka+0T9cNY2adFMFUnldQ7jNrYceNO46Uzue5lKYQbgfjZrY9Qs137HOtuqmv8ltw1PKalXsrZyqe4phFb0=  ;
X-YMail-OSG: oMMu.7kVM1mCKD6vw0RklDP8qKOQfn5Dk4yxvHnyETWFJntxBj52ac1M8GbRTWKLcfM.kLAo1bwZNT6uyEDg74m9tH_psJM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
Subject: Re: ehci-hcd affects hda speed
Date: Tue, 15 Apr 2008 16:17:22 -0700
User-Agent: KMail/1.9.6
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <47E1B062.4060709@keyaccess.nl> <alpine.LFD.1.10.0804152220560.6429@nev.ubzr>
In-Reply-To: <alpine.LFD.1.10.0804152220560.6429@nev.ubzr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804151617.23012.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2008, Lev A. Melnikovsky wrote:

> I have repeated experiments with P3B-F and VT6212L combination (to 
> improve visibility the AsyncSchedSleepTime is set to 1us):

Which you *know* is aggravating the problem.  What numbers
do you observe with a generic 2.6.25-rc9 kernel?  (That is,
without that abusive 1 usec setting ... that kernel includes
the patch switching to a more customary 10 usec value.)


> The oddest peculiarity for me is the hysteretic difference between #1 and 
> #3 states. I mean experimental data (hda throughput) depends not on the 
> state (hardware/loaded modules), but on the path we followed.
> 
> Interestingly enough, sampling registers (via /sys) often shows Async bit 
> set of the status register in the state #3. It is always cleared in #1.

With 2.6.25-rc9's default setting for async sleep time?


> The async file is empty in both states. I wonder, how many degrees of
> freedom does an empty schedule have? Does "empty" mean "has no incomplete
> requests" or "has no requests at all"? Just guessing...

Means "none at all".  So if the "Async" status bit is set
while the "Async" command is clear, it means the hardware
is clearly misbehaving.  That status bit is supposed to
turn itself off after the command bit is cleared ... within
a couple milliseconds.


> I don't think this is purely VIA problem. 

We've certainly seen enough "purely on VIA hardware" issues
though; and I don't recall evidence showing this is NOT
another one of those.  Example, that bogus 1 usec default...

One hopes that when http://linux.via.com.tw finally appears,
it will include errata for all relevant chipsets.

- Dave

