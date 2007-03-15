Return-Path: <linux-kernel-owner+w=401wt.eu-S965338AbXCOF3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338AbXCOF3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXCOF3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:29:00 -0400
Received: from 1wt.eu ([62.212.114.60]:1184 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965338AbXCOF26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:28:58 -0400
Date: Thu, 15 Mar 2007 06:28:46 +0100
From: Willy Tarreau <w@1wt.eu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org
Subject: [OT] Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
Message-ID: <20070315052845.GR943@1wt.eu>
References: <200703130428.11014.gene.heskett@gmail.com> <200703132331.56140.gene.heskett@gmail.com> <2c0942db0703141449h5f6eb2e4sadf493741d67ecc0@mail.gmail.com> <200703142312.48852.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703142312.48852.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 11:12:48PM -0400, Gene Heskett wrote:
> On Wednesday 14 March 2007, Ray Lee wrote:
> >On 3/13/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> >> On Tuesday 13 March 2007, Gene Heskett wrote:
> >> >On Tuesday 13 March 2007, Gene Heskett wrote:
> >> >>Greetings;
> >> >>Someone suggested a fresh thread for this.
> >> >>
> >> >>I now have my scripts more or less under control, and I can report
> >> >> that kernel-2.6.20.1 with no other patches does not exhibit the
> >> >> undesirable behaviour where tar thinks its all new, even when told
> >> >> to do a level 2 on a directory tree that hasn't been touched in
> >> >> months to update anything.
> >> >>
> >> >>Next up, 2.6.20.2, plain and with the latest RDSL-0.30 patch.
> >> >
> >> >And amanda/tar worked normally for 2.6.20.2 plain.
> >> >
> >> >Next up, 2.6.21-rc1 if it will build here.
> >>
> >> It built, it booted, and its busted big time.  First, with an amdump
> >> running in the background, the machine is so close to unusable that I
> >> considered rebooting, but I needed the data to show the problem.  I am
> >> losing the keyboard and mouse for a minute or more at a time but the
> >> keystrokes seem to be being registered so it eventually catches up.
> >>
> >> Disk i/o seems to be the killer according to gkrellm.
> >>
> >> But to give one an idea of the fits this is giving tar, I'll snip a
> >> line or 2 from an amstatus report here:
> >> coyote:/GenesAmandaHelper-0.6 1 planner: [dumps way too big, 138200
> >> KB, must skip incremental dumps]
> >>
> >> Huh?  138.2GB?  A 'du -h .' in that dir says 766megs.
> >>
> >> coyote:/root                  1     4426m wait for dumping
> >> du -h says 5.0GB so that's ballpark, but its also a level 1, so maybe
> >> 20 megs is actually new since 15:57 this afternoon local.  kmails
> >> final maildir is in that dir.
> >>
> >> This goes on for much of the amstatus report, very few of the reported
> >> sizes are close to sane.
> >>
> >> Now, can someone suggest a patch I can revert that might fix this? 
> >> The total number of patches between 2.6.20 and 2.6.21-rc1 will have me
> >> building kernels to bisect this till the middle of June at this rate.
> >
> >In a previous email, you said you were using ext3. If that's the case,
> >there doesn't appear to be much going on in terms of patches between
> >2.6.20 and 2.6.21-rc1. The only one that even comes close to looking
> >like it might have an effect would only come in to play if you have a
> >filesystem that has ACL information, but is mounted by a kernel that
> >doesn't have ACL support.
> >
> >I have to echo wli here, I'm afraid, and recommend at least a *few*
> >bisections to help narrow down the list of suspect patches.
> >
> >There are tutorials out there for git users. I use the mercurial
> >repository, as I find the mercurial interface and workflow a lot more
> >intuitive, but it has the same capability.
> >
> >Even 2-5 bisections will greatly help others hunt the bug down.
> >
> >Ray
> 
> Probably.  But I've now put a week into this, and from some other clues 
> I've collected, I'm beginning to think tar has a tummy ache. After all, 
> and ls -lc reports totally sane mtimes.  So why is tar going bonkers 
> under kernels 2.6.21-rc*, with or without Cons patches?
> 
> I've also spent a day now looking for a valid place to put a bugzilla 
> entry against tar, but googles search results are sending me to 
> gcc.gnu.org and this is NOT the correct bugzilla for a tar problem.
> 
> Its no secret that with all the churn in tar over the last 5 years, worse 
> churn than the kernel IMO in going from 2.0 to 2.6, that I'm not a fan of 
> yet another _new_ version of tar, when what we just need is _one_ that 
> works.  It is not capable of executing the recovery command listed in the 
> first block of every amdump file it (amdump) ever built right now, and 
> I've played the equ of the 10,000 monkeys writing Shakespear for several 
> hours trying.  Damned frustrating is what it is.
> 
> The error it reports seems to indicate that it cannot write through the 
> pipes involved.  But with tar's error reporting, who the hell knows for 
> sure.
> 
> Here is an example
> [root@coyote data]# dd if=00010.coyote._lib.1 bs=32k count=1
> AMANDA: FILE 20070314104344 coyote /lib  lev 1 comp .gz program /bin/tar
> To restore, position tape at start of file and run:
>  dd if=<tape> bs=32k skip=1 |  /bin/gzip -dc |  /bin/tar -f - ...
> 
> And the elipsis is an error if not removed.  Then one is supposed to be 
> able to redirect tars output with the usual >/tmp/test/ syntax
> 
> So:
> [root@coyote data]# dd if=00010.coyote._lib.1 bs=32k 
> skip=1 |  /bin/gzip -dc |  /bin/tar -f - >/tmp/test/
> -bash: /tmp/test/: Is a directory
> 
> which is the return from any variation in how the redirect is done.
> 
> So what is it that am I doing wrong in the above command line?, so I can 
> add it to my helper scripts to be published eventually on zmanda.org.

with "/bin/tar -f - >/tmp/test/", you ask bash to open the file "/tmp/test/"
for write, then start tar and pass this file as its stdout. Obviously this
is wrong. I think that what you're trying to do is send extracted files to
/tmp/test, which is what '-C' is for. Also, you need to specify a command
for tar. You didn't. I bet if you do the following, it will work :

[root@coyote data]# dd if=00010.coyote._lib.1 bs=32k skip=1 |
    /bin/gzip -dc |  /bin/tar -C /tmp/test/ -xf -

Now, Gene, this is becoming totally off-topic right here.

Regards,
Willy

