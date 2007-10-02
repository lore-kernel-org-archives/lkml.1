Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbXJBNXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbXJBNXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXJBNXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:23:42 -0400
Received: from rtr.ca ([76.10.145.34]:4270 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXJBNXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:23:41 -0400
Message-ID: <4702465C.7030207@rtr.ca>
Date: Tue, 02 Oct 2007 09:23:40 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: gogi-k@gogi.tv
Cc: linux-kernel@vger.kernel.org
Subject: Re: One process with multiple user ids.
References: <200710021256.08469.gogi-k@gogi.tv> <Pine.LNX.4.64.0710021322110.7130@fbirervta.pbzchgretzou.qr> <200710021334.34950.gogi-k@gogi.tv>
In-Reply-To: <200710021334.34950.gogi-k@gogi.tv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giuliano Gagliardi wrote:
> On Tuesday 02 October 2007, Jan Engelhardt wrote:
>> On Oct 2 2007 12:56, Giuliano Gagliardi wrote:
>>> I have a server that has to switch to different user ids, but because it
>>> does other complex things, I would rather not have it run as root. I only
>>> need the server to be able to switch to certain pre-defined user ids.
>> All you need is CAP_SETUID. Also see man setresuid,
>> where you could, I think, use saved_uid=0 if you do not
>> like to use real_uid=0 effective_uid=non-0.
> 
> But CAP_SETUID would let me change to any uid, would it not? I would like my 
> process to have no possibility to change to any uid, except some predefined 
> set, so that in case of a security hole only those uids could be compromised.

It really sounds like the app should be restructured.
If security is that important to it, then it shouldn't
be changing uids back and forth on the fly (too risky).

There's probably a nice redesign possible where it just
forks off 3 sub-processes, one for each UID,
and then farms out the work to each as required.

Cheers
