Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYG2RO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYG2RO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYG2ROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:14:20 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:48873 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYG2ROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:14:19 -0400
Date: Tue, 29 Jul 2008 13:11:12 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: directory sort order no longer beginning with "." and ".."?
In-reply-to: <2c0942db0807290935s67eba63te5bb826a0ab7c752@mail.gmail.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Oliver.Soltys@rsel.renesas.com,
       linux-kernel@vger.kernel.org
Reply-to: davecb@sun.com
Message-id: <488F4F30.1070903@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <488EE7BF.4020908@rsel.renesas.com> <488F2EDA.2090709@goop.org>
 <2c0942db0807290935s67eba63te5bb826a0ab7c752@mail.gmail.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ray Lee wrote:
> On Tue, Jul 29, 2008 at 7:53 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
>>Oliver Soltys wrote:
>>
>>>My question: is this a bug, or a feature? I could not find anything about
>>>that
>>>anywhere...
>>>
>>>Does anybody have an idea, how I can fix this? Unfortunately, our
>>>application
>>>can not be changed.
>>
>>No Unix-like system makes any guarantee about the order of '.' and '..' with
>>respect to other directory entries.  They've often appeared first as an
>>implementation side-effect, but that's highly system and filesystem
>>dependent.

 Alas, this implementation side-effect dates back to v6[1], and is so
depended upon that even  CD filesystems, which are by no means Unix-like,
contain dummy "." and ".." entries[2].

  I'd recommend either reproducing it or starting a project
to hunt down and kill all the programs which assume it (;-))

--dave
[1. I helped on the DPS-6 upgrade from v6 to v7, and it was a (dis)feature then]
[2. Andy Tannenbaum "Modern Operating Systems", 2nd Edition]

> That's a good idea, though based on his description it's even easier.
> The LD_PRELOAD just needs to artificially introduce . and .., at the
> beginning and toss them out once it hits them in the list. No sorting
> required.
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
