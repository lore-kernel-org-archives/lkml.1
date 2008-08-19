Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYHSBQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYHSBQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYHSBPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:15:53 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:6327 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909AbYHSBPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rCoti00LeMTLw3x/WNyxxV0fukPT/JA5vwxxxPli+Oy3pdNXykUuAdWq+sMjtfQ+RS
         yqLM0OuwI1Pjwg6OnkGLhBBHKEOt1MhCNn0b4QlfhPkWcSFZnmd5s4iOZAoU8zABOREU
         nt1ZW7zpcymFyUv+kPwj97OyJnPYM3ShbxGds=
Message-ID: <e7d8f83e0808181815v5ef628ebl3105197f03f4d334@mail.gmail.com>
Date: Tue, 19 Aug 2008 11:15:49 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to a linux interface for on access scanning
Cc: "Pavel Machek" <pavel@suse.cz>, tvrtko.ursulin@sophos.com, davecb@sun.com,
       david@lang.hm, "Adrian Bunk" <bunk@kernel.org>, rmeijer@xs4all.nl,
       "Mihai Don??u" <mdontu@bitdefender.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org,
       malware-list-bounces@dmesg.printk.net,
       "Casey Schaufler" <casey@schaufler-ca.com>, capibara@xs4all.nl,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <1219100824.15566.151.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080818142511.GC8184@mit.edu>
	 <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <20080818224058.GA2311@elf.ucw.cz>
	 <1219100824.15566.151.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 9:07 AM, Eric Paris <eparis@redhat.com> wrote:
> On Tue, 2008-08-19 at 00:40 +0200, Pavel Machek wrote:
>> Hi!
>>
>> > > On Mon, Aug 18, 2008 at 02:15:24PM +0100, tvrtko.ursulin@sophos.com
>> > wrote:
>> > > > Then there is still a question of who allows some binary to declare
>> > itself
>> > > > exempt. If that decision was a mistake, or it gets compromised
>> > security
>> > > > will be off. A very powerful mechanism which must not be easily
>> > > > accessible.  With a good cache your worries go away even without a
>> > scheme
>> > > > like this.
>> > >
>> > > I have one word for you --- bittorrent.  If you are downloading a very
>> > > large torrent (say approximately a gigabyte), and it contains many
>> > > pdf's that are say a few megabytes a piece, and things are coming in
>> > > tribbles, having either a indexing scanner or an AV scanner wake up
>> > > and rescan the file from scratch each time a tiny piece of the pdf
>> > > comes in is going to eat your machine alive....
>> >
>> > Huh? I was never advocating re-scan after each modification and I even
>> > explicitly said it does not make sense for AV not only for performance but
>> > because it will be useless most of the time. I thought sending out
>> > modified notification on close makes sense because it is a natural point,
>> > unless someone is trying to subvert which is out of scope. Other
>> > have
>>
>> Why do you think non-malicious applications won't write after close /
>> keep file open forever?
>
> If you ask this one more time without reading the many times I've
> answered these questions I think I'm going to explode.
>
> Permissions checks are done on open/read.  Decisions are invalidated at
> mtime update, which INCLUDES mmap after close!  I don't care if you keep
> your file open forever, if you wrote to it, we are just going to scan it
> next time a process decided to open/read it.  Please stop confusing this
> already long and almost pointless thread with implementation details
> that have repeatedly been explained.
>
You will see latter where what you just said fails and its issue is
preventable too downloader with build in previewer.

Funny enough solution to this is fairly simple.   But does require
looking at a white list methods and LSM.

Two major ways.    White list format check method tells you that file
is not complete enough so black list scanning is not required yet.  Ok
lighter than running 5000 black list signatures over it each time a
new block gets added.

Unfortunately scan of all pieces as them come in for possible threat
still has to be done reason on videos and the like people in some
applications start playing them before the download is complete.
Lots of video and audio formats have blocks that can be cleared piece
by piece.   Just like a bittorrent can scan and pass block by block so
does a white list scanner need to be able to.  More creative use can
be void block insert into some formats.   Ie part downloaded block at
X replaced with a equal to blank block to the player  that is external
to the download tool.   This is damaged data access prevention.
Nicely prevents some stability issues and gives users extra features.

White list scanner knowing the format can detect when enough segments
are in a file to run a black list scan avoiding jack hammering the cpu
eating black list scan.

Dealing with bittorrent clients with built in preview is a pain in the
you know what.   Since are they reading the file to send to someone
else are they reading the file to display in there internal viewer or
do they take straight from there download buffer to internal view.
Even worse lots of bittorrent streams are encrypted and cannot be
scanned while network packets.   So second solution required a LSM
around the downloader preventing it in case of breach being able to go
anywhere in the system.   LSM only allows access to files that the
downloader has downloaded by other applications with more rights when
its pasted White list and needed black list scanning.

Getting this to work without using white list of known format method
and LSM is basically imposable because a black list is going to take
far to much cpu time scanning incomplete files.

This is one of the reasons why the system is 4 tech groups.  HIDS,
white list methods, black list methods and LSM.      Without all 4 you
are stuffed trying to make a prevention system work because you will
get snagged somewhere trying to cover all setups and events.   A
combination is required some setups can get away without the black
list.   There are many points where current black list methods are
flawed or hurt way too much.

Some of these will require looking at two extra tech groups.   1 being
intergation into applications.   2 providing apis for applications to
do particular protocols and blocking out direct network access other
than threw those apis.

Lot of windows anti-virus people are way too focused on black list.
White list might annoy you from time to time but it can also grant
features that users may not want to give up.

Peter Dolding
