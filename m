Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYJNVNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYJNVNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYJNVNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:13:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:53940 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYJNVNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fIZgef2Sh1eUrhcpdAi9Bcc923qxFrHDz3qhywk7UYVphbK3Dq4n7SV0mh4MNwZKro
         Q65jUAoNthv7c0BVzUIzr3KxF8tEZo3l0TOdvcKHI548vqG6jKfQunMK57u7bIObR+k+
         +Wm+4NNuEVv+04RBUzb8J9SiDAGFHtKazSEAY=
Message-ID: <68676e00810141413w384882dbg53af93a1b522e0d3@mail.gmail.com>
Date: Tue, 14 Oct 2008 23:13:39 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: SDHCI: timeout during data transfer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <68676e00810140234o5e85f438l18058c907a7c6260@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923212459.GA13888@dreamland.darkstar.lan>
	 <20081002101754.031d6710@mjolnir.drzeus.cx>
	 <68676e00810030427g63c07643rf637ca894df795b2@mail.gmail.com>
	 <20081012105227.513bb9a8@mjolnir.drzeus.cx>
	 <68676e00810140234o5e85f438l18058c907a7c6260@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 11:34 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> On Sun, Oct 12, 2008 at 10:52 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
>> On Fri, 3 Oct 2008 13:27:52 +0200
>> "Luca Tettamanti" <kronos.it@gmail.com> wrote:
>>>
>>> Hum, cannot reproduce (but it was consistently failing when I tested
>>> the patch... the only difference is a mkfs in between). I just got a
>>> few retries:
>>
>> A silly question, but did you also try disabling the debugging? Since
>> this is a timing issue, the debugging output could be just enough to
>> make the problem go away.
>
> Ok, I managed to reproduce without the debugging, but this time it
> took over a couple of GB before it started failing. Block numbers
> differ from the previous failures (so maybe it's not a cluster of
> broken blocks).
> Will go back and test with debugging enabled.

I finally managed to capture a failure with debug enabled, I'm
attaching the log.
To recap:
- heavy write loads sometimes result in a timeout
- reads seem unaffected (I read the card multiple times without errors)
- doubling the timeout (as per my first patch) makes the timeout disappear
- windows doesn't suffer from the issue

I've tested two other cards that do not show the problem, but they are
not "high speed":

mmc0: new high speed SD card at address 0002 (troubles)
vs:
mmc0: new SD card at address e624 (OK)

Luca
