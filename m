Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXJHKRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXJHKRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 06:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbXJHKRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 06:17:12 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:57502 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXJHKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 06:17:12 -0400
Message-ID: <470A0359.5090008@aitel.hist.no>
Date: Mon, 08 Oct 2007 12:15:53 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: gogi-k@gogi.tv
CC: linux-kernel@vger.kernel.org
Subject: Re: One process with multiple user ids.
References: <200710021256.08469.gogi-k@gogi.tv> <Pine.LNX.4.64.0710021322110.7130@fbirervta.pbzchgretzou.qr> <200710021334.34950.gogi-k@gogi.tv>
In-Reply-To: <200710021334.34950.gogi-k@gogi.tv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giuliano Gagliardi wrote:
> On Tuesday 02 October 2007, Jan Engelhardt wrote:
>   
>> On Oct 2 2007 12:56, Giuliano Gagliardi wrote:
>>     
>>> I have a server that has to switch to different user ids, but because it
>>> does other complex things, I would rather not have it run as root. I only
>>> need the server to be able to switch to certain pre-defined user ids.
>>>       
>> All you need is CAP_SETUID. Also see man setresuid,
>> where you could, I think, use saved_uid=0 if you do not
>> like to use real_uid=0 effective_uid=non-0.
>>     
>
> But CAP_SETUID would let me change to any uid, would it not? I would like my 
> process to have no possibility to change to any uid, except some predefined 
> set, so that in case of a security hole only those uids could be compromised.
Why exactly do you need to change UID to a predefined set?
Do your app need to work with files owned by those users perhaps?

If so, consider filesystem solutions:
 * make a group with all these users in, make the files rw for this group
or
 * Use ACLs and let whatever UID your process use, have access to
    the files in question.

Another approach if filesystem tricks don't fit your need:
Have a small process running as root. It should not do much
io or data processing, so its source is small and easy to audit. You
can make reasonably sure it has no security holes. This minimal app
will when needed:
 * fork,
 * set the correct UID for this particular job,
 * exec the app that do  work that is so complicated that
   security holes might happen.

Helge Hafting


