Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYHRRnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYHRRnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYHRRm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:42:57 -0400
Received: from brmea-mail-1.Sun.COM ([192.18.98.31]:63351 "EHLO
	brmea-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYHRRm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:42:56 -0400
Date: Mon, 18 Aug 2008 09:42:26 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to a
 linux interface for on access scanning
In-reply-to: <20080818163148.0ef3e383@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       david@lang.hm, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl
Reply-to: davecb@sun.com
Message-id: <48A97C42.4040103@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080818142511.GC8184@mit.edu>
 <20080818153212.6A6FD33687F@pmx1.sophos.com>
 <20080818163148.0ef3e383@lxorguk.ukuu.org.uk>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tvrtko.ursulin wrote:
>>Huh? I was never advocating re-scan after each modification and I even 
>>explicitly said it does not make sense for AV not only for performance but 
>>because it will be useless most of the time. I thought sending out 
>>modified notification on close makes sense because it is a natural point, 
>>unless someone is trying to subvert which is out of scope. Other have 
>>suggested time delay and lumping up.

Alan Cox wrote: 
> You need a bit more than close I imagine, otherwise I can simply keep the
> file open forever. There are lots of cases where that would be natural
> behaviour - eg if I was to attack some kind of web forum and insert a
> windows worm into the forum which was database backed the file would
> probably never be closed. That seems to be one of the more common attack
> vectors nowdays.

  I suspect we're saying "on close" when what's really meant is
"opened for write". In the latter case, the notification would tell
the user-space program to watch for changes, possibly by something as
simple as doing a stat now and another when it gets around to 
deciding if it should scan the file. I see lots of room for
user-space alternatives for change detection, depending on how much
state it keeps. Rsync-like, perhaps?

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
