Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbZDAB0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbZDAB0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZDABZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:25:51 -0400
Received: from france.micfo.com ([92.48.68.3]:45912 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbZDABZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:25:50 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Subject: Re: Ext4 and the "30 second window of death"
Date: Wed, 1 Apr 2009 03:25:43 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.28-ARCH; KDE/4.2.1; x86_64; ; )
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx>
In-Reply-To: <49D2A5AB.1090704@ursus.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904010325.43454.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009 01:22:19 Andreas T.Auer wrote:
> On 01.04.2009 00:02 Alberto Gonzalez wrote:
> > In fact, thinking about it, this option would be the ideal one for
> > desktops and especially laptops (servers running databases are a
> > different thing). What we need is that _no_ application uses fsync. The
> > decision as to when the data should be written to disk should be left to
> > the filesystem. And then the user can choose how often they want this to
> > happen (every 5, 15, 30, 60... seconds). So if Ext4 could have a
> > "nofsync" mount option that would disable fsync from applications (i.e,
> > it wouldn't honor an fsync call), that would be wonderful. But then of
> > course we have to make sure that if the kernel crashes (or there's a
> > power-off, etc..), we will just lose the new data that hasn't been
> > written to disk, but the old data will still be there. So maybe this
> > could be achieved with mounting the filesystem with nofsync, nodelalloc?
>
> You are always thinking about the few seconds/minutes of work you gonna
> lose, but there are different situations, too.
>
> E.g. your POP3 client receives a very important mail, saves it to disk,
> uses fsync to make sure it is out and tells the server to delete it. If
> you are gonna delay the fsync, you will have a long window in which the
> mail can get lost instead of a minimum window. Or are there any POP3
> clients, which can synchronize the mail-polling with a spinning a disk?

Yes, I guess this is a clear example of data that needs to be written to disk 
straight away.

>
> There are tasks that are not very important, that should not spin up the
> disk and there are tasks, that might better do so. It is the preference
> of the user, which tasks should or should not spin up the disk, but the
> application developer has to decide globally, whether or not to use
> fsync() and the filesystem can't even distinguish the tasks at all,
> except that it receives fsyncs or not.
>
> So fine-tuning the system to the ideal disk-writing policy is really
> problematic, especially given a lot of different people turning knobs:
> - different filesystem developers using different methods and default
> behaviors, which can be changed by distros and sys admins.
> - different applications trying to use or not use fsync() and other
> methods to get the best policies for any kind of fs. Or the developers
> are incompetent enough to expect features from the filesystem which are
> not always given, whether trained by ext3 data=ordered or trained by
> reiserfs or just bare of any better fs knowledge.
> - different users having different preferences on what data is how
> important, but usually they can not change the fsync-policy of the
> applications.

Yes, I agree with all the above. There's no magic recipe for any filesystem, 
and honestly, I've never had problems with reiserfs in the past or ext3 later 
on. I don't know why I got scared with all this "ext4 will give you zero-
length files on every crash unless all applications start to fsync like crazy 
and kill your hard drive in a year time" thing. Filesystem developers must 
have a bit of bit of knowledge about how this works to not do something too 
stupid.

> Andreas

Alberto.

