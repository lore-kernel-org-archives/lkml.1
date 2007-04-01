Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXDAFA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXDAFA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 01:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbXDAFA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 01:00:27 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:51632 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbXDAFA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 01:00:26 -0400
Date: Sun, 01 Apr 2007 01:00:17 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Subject: plain 2.6.21-rc5 (1) vs amanda (0)
To: Ingo Molnar <mingo@elte.hu>, amanda-hackers@amanda.org,
       linux-kernel@vger.kernel.org, amanda-users@amanda.org
Message-id: <200704010100.19016.gene.heskett@verizon.net>
Organization: Organization? Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo;

Running 2.6.21-rc5 tonight.

It appears that as of 2.6.21-rc5, (actually anything with a 2.6.21 in its
version string) amanda is still a loser.
>From an amstatus report as the back up is just getting started, 
and amanda has completed the estimates:

[root@coyote Daily]# amstatus Daily
Using /usr/local/var/amanda/Daily/amdump from Sun Apr  1 00:05:04 EDT 2007

coyote:/GenesAmandaHelper-0.5 1 planner: [dumps way too big, 156684 KB, must skip incremental dumps]
coyote:/GenesAmandaHelper-0.6 4 planner: [dumps way too big, 780226 KB, must skip incremental dumps]
coyote:/bin                   1 planner: [dumps way too big, 10 KB, must skip incremental dumps]
coyote:/boot                  1        3m wait for dumping
coyote:/dev                   0        0m wait for dumping
coyote:/etc                   2 planner: [dumps way too big, 18533 KB, must skip incremental dumps]
coyote:/home                  0      858m wait for dumping
coyote:/lib                   1 planner: [dumps way too big, 100080 KB, must skip incremental dumps]
coyote:/opt                   1     2192m wait for dumping
coyote:/root                  2 planner: [dumps way too big, 1684448 KB, must skip incremental dumps]
coyote:/sbin                  1        0m wait for dumping
coyote:/tmp                   1 planner: [dumps way too big, 8972 KB, must skip incremental dumps]
coyote:/usr/X11R6             1 planner: [dumps way too big, 232 KB, must skip incremental dumps]
coyote:/usr/bin               1 planner: [dumps way too big, 26030 KB, must skip incremental dumps]
coyote:/usr/dlds              1 planner: [dumps way too big, 93030 KB, must skip incremental dumps]
coyote:/usr/dlds-misc         2      155m wait for dumping
coyote:/usr/dlds-rpms         1 planner: [dumps way too big, 10 KB, must skip incremental dumps]
coyote:/usr/dlds-tgzs         1        0m wait for dumping
coyote:/usr/games             0        0m wait for dumping
coyote:/usr/include           1       85m wait for dumping
coyote:/usr/kerberos          1 planner: [dumps way too big, 1360 KB, must skip incremental dumps]
coyote:/usr/lib               3 planner: [dumps way too big, 337013 KB, must skip incremental dumps]
coyote:/usr/libexec           1 planner: [dumps way too big, 20138 KB, must skip incremental dumps]
coyote:/usr/local             1 planner: [dumps way too big, 42374 KB, must skip incremental dumps]
coyote:/usr/man               1 planner: [dumps way too big, 710 KB, must skip incremental dumps]
coyote:/usr/movies            1     7271m dumping     5298m ( 72.87%) (0:12:48)
coyote:/usr/music             1 planner: [dumps way too big, 2448290 KB, must skip incremental dumps]
coyote:/usr/pix               1 planner: [dumps way too big, 856480 KB, must skip incremental dumps]
coyote:/usr/sbin              1 planner: [dumps way too big, 2305 KB, must skip incremental dumps]
coyote:/usr/share             2 planner: [dumps way too big, 348843 KB, must skip incremental dumps]
coyote:/usr/src               1 planner: [dumps way too big, 2519056 KB, must skip incremental dumps]
coyote:/var                   3     3774m wait for dumping

SUMMARY          part      real  estimated
                           size       size
partition       :  32
estimated       :  32                42307m
flush           :   0         0m
failed          :  21                27964m           ( 66.10%)
wait for dumping:  10                 7070m           ( 16.71%)
dumping to tape :   0                    0m           (  0.00%)
dumping         :   1      5298m      7271m ( 72.87%) ( 12.52%)
dumped          :   0         0m         0m (  0.00%) (  0.00%)
wait for writing:   0         0m         0m (  0.00%) (  0.00%)
wait to flush   :   0         0m         0m (100.00%) (  0.00%)
writing to tape :   0         0m         0m (  0.00%) (  0.00%)
failed to tape  :   0         0m         0m (  0.00%) (  0.00%)
taped           :   0         0m         0m (  0.00%) (  0.00%)
  tape 1        :   0         0m         0m (  0.00%) Dailys-17
8 dumpers idle  : not-idle
taper idle
network free kps:      6800
holding space   :     66234m (100.00%)
 dumper0 busy   :  0:00:00  (  0.00%)
 0 dumpers busy :  0:00:00  (  0.00%)
 1 dumper busy  :  0:00:00  (  0.00%)
[root@coyote Daily]#  

Anything above that's 'way too big' is within a percent or so, regardless
of the level, of a full, every byte backup.  The number in column 31 above
is the backup level that disklist entry is getting right now.
 
As a sample of how it is being messed with, for a single, approximately 2.5GB 
collection of music I have, are the outputs of the sendsize function
for the last 2 runs, yesterdays dated files were obtained running 2.6.20.4
and todays were obtained with 2.6.21-rc5.

Good, 2.6.20.4 was running
sendsize.20070331000507.debug:sendsize[762]: time 248.361: getting size via gnutar for /usr/music level 0
sendsize.20070331000507.debug:sendsize[762]: estimate time for /usr/music level 0: 1.239
sendsize.20070331000507.debug:sendsize[762]: estimate size for /usr/music level 0: 2466050 KB
sendsize.20070331000507.debug:sendsize[762]: time 249.605: getting size via gnutar for /usr/music level 1
sendsize.20070331000507.debug:sendsize[762]: estimate time for /usr/music level 1: 0.027
sendsize.20070331000507.debug:sendsize[762]: estimate size for /usr/music level 1: 80 KB

Bad, 2.6.21-rc5 is running
sendsize.20070401000504.debug:sendsize[18465]: time 167.371: getting size via gnutar for /usr/music level 0
sendsize.20070401000504.debug:sendsize[18465]: estimate time for /usr/music level 0: 0.398
sendsize.20070401000504.debug:sendsize[18465]: estimate size for /usr/music level 0: 2466050 KB
sendsize.20070401000504.debug:sendsize[18465]: time 167.773: getting size via gnutar for /usr/music level 1
sendsize.20070401000504.debug:sendsize[18465]: estimate time for /usr/music level 1: 0.049
sendsize.20070401000504.debug:sendsize[18465]: estimate size for /usr/music level 1: 2448290 KB

Yesterdays run, dated 20070331000507 were correct as that directory hasn't been
write accessed in a couple of months.

Today's, dated 20070401000504, shows totally bogus figures for exactly 
the same data.

This effect I have isolated down to something in the 31 patches from
2.6.20.4 to 2.6.20.5-rc1, but I'm going to need additional guidance in
setting up the bisect to find it.  If indeed its a kernel problem.

This same effect has been present in any and every 2.6.21.* release.

Now, strange it seems, the outputs of the ls command which show these
timestamps that amanda and in this case tar supposedly uses to
determine whats new and changed since the last backup run (as determined
by the dates and levels stored in the /etc/amandates file) are completely
sane unless I'm using them wrong.  Somebody might want to make sure I'm
doing that right.

I've also filed a bz entry in the redhat/fedora bugzilla against the rpm 
of tar supplied with an uptodate FC6, but so far in 2 weeks, the activity
there has been nill, zip, ignored.

I personally think its a tar problem but can't manage to find enough data
to be able to nail that blob of jelly to the tree.

What I do know is that this IS a showstopper for amanda, the backup utility.

The manpages for tar haven't been touched since 1.14, and the (p)info entries
I'd almost erase for lack of info, so if someone can tell me how to
construct a tar command line that will make tar give me a size answer
for whats new since timestamp yyyymmddhhmmss I'd have yet another tool
to use as a finger pointer that would carry some weight amongst the
non-believers here.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
When I sell liquor, it's called bootlegging; when my patrons serve
it on silver trays on Lake Shore Drive, it's called hospitality.
		-- Al Capone
