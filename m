Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYHRSNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYHRSNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYHRSNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:13:47 -0400
Received: from mail.lang.hm ([64.81.33.126]:43360 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYHRSNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:13:46 -0400
Date: Mon, 18 Aug 2008 11:13:26 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Collier-Brown <davecb@sun.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, capibara@xs4all.nl,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to
 a linux interface for on access scanning
In-Reply-To: <48A97C42.4040103@sun.com>
Message-ID: <alpine.DEB.1.10.0808181110040.15109@asgard.lang.hm>
References: <20080818142511.GC8184@mit.edu> <20080818153212.6A6FD33687F@pmx1.sophos.com> <20080818163148.0ef3e383@lxorguk.ukuu.org.uk> <48A97C42.4040103@sun.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, David Collier-Brown wrote:

> tvrtko.ursulin wrote:
>>> Huh? I was never advocating re-scan after each modification and I even 
>>> explicitly said it does not make sense for AV not only for performance but 
>>> because it will be useless most of the time. I thought sending out 
>>> modified notification on close makes sense because it is a natural point, 
>>> unless someone is trying to subvert which is out of scope. Other have 
>>> suggested time delay and lumping up.
>
> Alan Cox wrote: 
>> You need a bit more than close I imagine, otherwise I can simply keep the
>> file open forever. There are lots of cases where that would be natural
>> behaviour - eg if I was to attack some kind of web forum and insert a
>> windows worm into the forum which was database backed the file would
>> probably never be closed. That seems to be one of the more common attack
>> vectors nowdays.
>
> I suspect we're saying "on close" when what's really meant is
> "opened for write". In the latter case, the notification would tell
> the user-space program to watch for changes, possibly by something as
> simple as doing a stat now and another when it gets around to deciding if it 
> should scan the file. I see lots of room for
> user-space alternatives for change detection, depending on how much
> state it keeps. Rsync-like, perhaps?

trying to have every scanner program monitor every file that any program 
opens for write by doing periodic stat commands on it sounds like a very 
inefficiant process (and unless they then get notified on close as well, 
how do they know when to stop monitoring?)

getting a notification on the transition from scanned -> dirty is much 
less of a load (yes, it does leave open the possiblilty of a file getting 
scanned multiple times as it keeps getting dirtied, but that's a policy 
question of how aggressive the scanner is set to be in scanning files)

David Lang
