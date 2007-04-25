Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbXDYAMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbXDYAMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXDYAMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:12:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47049 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbXDYAME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:12:04 -0400
Message-Id: <1177459922.31000.1186391425@webmail.messagingengine.com>
X-Sasl-Enc: tcFGBwQ7XyF89EZvOmIAwScDMdKp3XNbxOXFT3TD4ngc 1177459922
From: lkml777@123mail.org
To: "Edward Shishkin" <edward@namesys.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>
Cc: "Alex Zarochentsev" <zam@namesys.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Eric Hopper" <hopper@omnifarious.org>, "Lex Lyamin" <flx@msu.ru>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Rik van Riel" <riel@redhat.com>, "Xu CanHao" <xucanhao@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
   <462E17AF.7090604@namesys.com>
Subject: Re: Question about Reiser4
In-Reply-To: <462E17AF.7090604@namesys.com>
Date: Tue, 24 Apr 2007 17:12:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007 19:00:46 -0700, "Eric Hopper"
> <hopper@omnifarious.org> said:

> I did.  That whole thread is some guy spouting off a ludicrous Bonnie++
> benchmark showing that compressing long strings of 0s results in things
> taking up very little space and being very fast.

I think you are deliberately being stupid here.

You are claiming that REISER4's good speed results when using
compression actually has a simple explanation and THEREFORE all good
result for the filesystem, even those results that have nothing to do
with compression, are negated.

NOTHING COULD BE FURTHER FROM THE TRUTH.

Your conclusion is a total travesty of logic.

As I understand it, the default Reiser4 DOES NOT USE any compression at
all, not even tail compression, but saves space by eliminating block
alignment wastage (tail compression is an option).

So lets LOSE the statistics that involve compression. The results now
look like this:

.-------------------------.
| FILESYSTEM | TIME |DISK |
| TYPE       |(secs)|USAGE|
.-------------------------.
|REISER4     | 3462 | 692 |
|EXT2        | 4092 | 816 |
|JFS         | 4225 | 806 |
|EXT4        | 4408 | 816 |
|EXT3        | 4421 | 816 |
|XFS         | 4625 | 779 |
|REISER3     | 6178 | 793 |
|FAT32       |12342 | 988 |
|NTFS-3g     |10414 | 772 |
.-------------------------.

These results are still EXTREMELY GOOD for REISER4.

These results still say that Reiser4 is a truly remarkable filesystem,
as stated in:

http://linuxhelp.150m.com/resources/fs-benchmarks.htm
http://m.domaindlx.com/LinuxHelp/fs-benchmarks.htm

So why do I see an anti-Reiser religion, in all that you people say.

You, concentrate on the fact that bonnie++'s use of files that are
mainly zeroes, will make the results using compression less good than
they are.

I can't see anywhere where this has been denied.

In fact the other set of statistics that you just ignore, states that in
more realistic situations, the compression speedup is slightly negative.

What is wrong here, is:

You say that the Bonnie++ tests using compression are subject to
interpretation. No argument here.
You ignore the tests that confirm your statement. You are clearly not
interested in the actual results or their interpretation.
You, by some incredibly twisted "logic" the state that Reiser4 is
therefore not good, even though it is clearly the best filesystem when
NOT using compression.

This of course is completely deceitful "logic".

That the speed advantage from compression would be small is clear from
the OTHER data that you ignore, namely:

.-------------------------------------------------.
|File         |Disk |Copy |Copy |Tar  |Unzip| Del |
|System       |Usage|655MB|655MB|Gzip |UnTar| 2.5 |
|Type         | (MB)| (1) | (2) |655MB|655MB| Gig |
.-------------------------------------------------.
|REISER4 lzo  | 278 | 138 |  56 |  80 |  34 |  84 |
|REISER4 gzip | 213 | 148 |  68 |  83 |  48 |  70 |
|REISER4      | 692 | 148 |  55 |  67 |  25 |  56 |
|EXT4         | 816 | 174 |  70 |  74 |  42 |  50 |
.-------------------------------------------------.


> So, the speed increase with compression (on very compressible kernel sources) is slightly negative,
> 
> but the speed is still comparable to that of EXT4.
> 
> > On Sun, 22 Apr 2007 19:00:46 -0700, "Eric Hopper"
> > <hopper@omnifarious.org> said:
> >
> > > I know that this whole effort has been put in disarray by the
> > > prosecution of Hans Reiser, but I'm curious as to its status. Is
> > > Reiser4 going to be going into the Linus kernel anytime soon? Is there
> > > somewhere I should be looking to find this out without wasting bandwidth
> > > here?
> >
> > There was a thread the other day, that talked about Reiser4.
> >
> > It took a while but I have found it (actually two)
> >
> > http://lkml.org/lkml/2007/4/5/360
> > http://lkml.org/lkml/2007/4/9/4
> >
> > You may want to check them out.
> 
> I did.  That whole thread is some guy spouting off a ludicrous Bonnie++
> benchmark showing that compressing long strings of 0s results in things
> taking up very little space and being very fast.
> 
> Such things will produce lots of flames and no useful information
> whatsoever as is evinced by the half conspiracy theory, half truth the
> thread degenerated into in the second message you linked to.
> 
-- 
  
  lkml777@123mail.org

-- 
http://www.fastmail.fm - mmm... Fastmail...

