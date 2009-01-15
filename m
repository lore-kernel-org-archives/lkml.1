Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbZAOOgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbZAOOgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765689AbZAOOg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:36:28 -0500
Received: from mail151.ix.emailantidote.com ([89.167.219.151]:1329 "EHLO
	iamta51.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765625AbZAOOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:36:26 -0500
Message-ID: <496F4919.8060302@draigBrady.com>
Date: Thu, 15 Jan 2009 14:32:57 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       austin-group-l@opengroup.org
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <200901032006.47652.rob@landley.net> <49601B94.3060408@zytor.com> <200901040029.03396.rob@landley.net>
In-Reply-To: <200901040029.03396.rob@landley.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jan 2009 14:34:31.0009 (UTC) FILETIME=[60985510:01C9771E]
x-MXSweep-KeywordsCount: 0
x-MXSweep-MetaScanResult: Clean
x-MXSweep-MetaScanThreat: 
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXSweep-Threat: Clean
X-MXUniqueID: 61bd7451-4f41-47d8-ad01-bdd25b75cd4e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> Implementing something by hand isn't _always_ a good alternative, sure.  That 
> would be the "thinking about the problem" part.  In this instance, avoiding 
> overflow is trivial.  (If 1<<-1 didn't wrap around, it wouldn't even need the 
> if statement.)

I don't think this affects your script but it's worth noting
that both bash and ksh use arithmetic rather than logical shift
for the >> operator.

Now arithmetic shift is not useful on 2's compliment machines,
and moreover it's compiler dependent as to whether arithmetic
or logical shift is done for >>. Therefore to increase usefulness
and decrease ambiguity, shells really should only shift unsigned
variables internally.

I know the opengroup spec says to use signed ints, but I think
that is intended to disambiguate input and output, rather than defining
internal operations. This is correct I think since the POSIX spec says
you can even use floating point internally if you like.

I asked the bash maintainer who said he would need clarification
from the austin group (CC'd) before changing anything.

cheers,
Pádraig.
