Return-Path: <linux-kernel-owner+w=401wt.eu-S964905AbXAWMsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905AbXAWMsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbXAWMsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:48:11 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21651 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852AbXAWMsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:48:10 -0500
Message-ID: <45B60403.1060201@tls.msk.ru>
Date: Tue, 23 Jan 2007 15:48:03 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.8 (X11/20061128)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan> <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown> <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan> <45B5ECAA.6000100@tls.msk.ru> <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> On Tue, 23 Jan 2007, Michael Tokarev wrote:
> 
>> Disabling pre-emption on critical and/or server machines seems to be a good
>> idea in the first place.  IMHO anyway.. ;)
>
> So bottom line is make sure not to use preemption on servers or else you 
> will get weird spinlock/deadlocks on RAID devices--GOOD To know!

This is not a reason.  The reason is that preemption usually works worse
on servers, esp. high-loaded servers - the more often you interrupt a
(kernel) work, the more nedleess context switches you'll have, and the
more slow the whole thing works.

Another point is that with preemption enabled, we have more chances to
hit one or another bug somewhere.  Those bugs should be found and fixed
for sure, but important servers/data isn't a place usually for bughunting.

/mjt
