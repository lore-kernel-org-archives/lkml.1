Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbZCRHxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbZCRHxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 03:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZCRHwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 03:52:51 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:43533 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZCRHwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 03:52:50 -0400
Message-ID: <49C0A80E.1040603@cs.columbia.edu>
Date: Wed, 18 Mar 2009 03:51:42 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Dan Smith <danms@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>	<1236095764-19325-3-git-send-email-danms@us.ibm.com>	<1236097332.22399.8.camel@nimitz>	<878wnmrtp9.fsf@caffeine.danplanet.com>	<1236128437.22399.31.camel@nimitz> <20090304150519.GB10186@us.ibm.com>
In-Reply-To: <20090304150519.GB10186@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
>> On Tue, 2009-03-03 at 16:57 -0800, Dan Smith wrote:
>>> DH> Did you convince Nathan that this ends up being a good idea?
>>>
>>> Technically he hasn't seen this version, but my hopes are not high
>>> that he will change his mind.  If the feedback is that they're not
>>> liked, I'll happily remove them.
>> I just figure if Nathan feels that strongly that we'll encounter more
>> people who feel even more so.  So, I was curious if he changed his mind
>> somehow.
> 
> I maintain however that two strong advantages of moving the checkpoint
> and restart of simple registers etc into a single function are:
> 
> 	1. we won't forget to add (or accidentally lose) one or the
> 		other
> 	2. any actual special handling at checkpoint or restart, like
> 		the loading of access registers at restart on s390x,
> 		stand out
> 

I, too, think that this scheme is elegant, and at the same time I, too,
think that it obfuscates the code. Since I only touch arch-dependent code
only if I really really must, I don't have strong opinion about it ;)

However, a problem with this scheme is that checkpoint and restart
are not fully symmetric -- on restart we must sanitize the input data
before restoring the registers to that data. I'm not familiar with
s390, but it is likely that by not doing so we create a security issue.

Oren.

