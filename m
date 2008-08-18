Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYHRRHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYHRRHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYHRRHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:07:43 -0400
Received: from mail.lang.hm ([64.81.33.126]:54685 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYHRRHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:07:42 -0400
Date: Mon, 18 Aug 2008 10:07:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: tvrtko.ursulin@sophos.com
cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to
 a linux interface for on access scanning
In-Reply-To: <20080818153212.6A6FD33687F@pmx1.sophos.com>
Message-ID: <alpine.DEB.1.10.0808181004380.15109@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, tvrtko.ursulin@sophos.com wrote:

> Theodore Tso <tytso@mit.edu> wrote on 18/08/2008 15:25:11:
>
>> On Mon, Aug 18, 2008 at 02:15:24PM +0100, tvrtko.ursulin@sophos.com
> wrote:
>>> Then there is still a question of who allows some binary to declare
> itself
>>> exempt. If that decision was a mistake, or it gets compromised
> security
>>> will be off. A very powerful mechanism which must not be easily
>>> accessible.  With a good cache your worries go away even without a
> scheme
>>> like this.
>>
>> I have one word for you --- bittorrent.  If you are downloading a very
>> large torrent (say approximately a gigabyte), and it contains many
>> pdf's that are say a few megabytes a piece, and things are coming in
>> tribbles, having either a indexing scanner or an AV scanner wake up
>> and rescan the file from scratch each time a tiny piece of the pdf
>> comes in is going to eat your machine alive....
>
> Huh? I was never advocating re-scan after each modification and I even
> explicitly said it does not make sense for AV not only for performance but
> because it will be useless most of the time. I thought sending out
> modified notification on close makes sense because it is a natural point,
> unless someone is trying to subvert which is out of scope. Other have
> suggested time delay and lumping up.
>
> Also, just to double-check, you don't think AV scanning would read the
> whole file on every write?

if it doesn't read the entire file and only reads the parts that change, 
out-of-order writes (which bittorrent does a _lot_ of) can assemble a 
virus from pieces and the scanner will never see it.

as for Ted's issue, the scanner(s) would get notified when the file was 
dirtied, they would then get notified if something scanned the file and it 
was marked dirty again after that. If nothing got around to scanning the 
file then all the following writes would not send any notification becouse 
the file would already be dirty.

David Lang
