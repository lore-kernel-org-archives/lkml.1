Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZETQyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZETQyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZETQyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:54:12 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:61630 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZETQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:54:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18964.13712.941366.200541@stoffel.org>
Date: Wed, 20 May 2009 12:53:36 -0400
From: "John Stoffel" <john@stoffel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: John Stoffel <john@stoffel.org>,
       David Watson <kernel-nospam@dbwatson.ukfsn.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13232] ext3/4 with synchronous writes gets wedged by
	Postfix
In-Reply-To: <20090519204152.GE9053@mit.edu>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
	<pQ9WADCjgyE.A.yJG.DA0DKB@chimera>
	<20090518132517.GL32019@mit.edu>
	<20090519171713.GA3354@dbwatson.ukfsn.org>
	<20090519175312.GC9053@mit.edu>
	<18962.64002.324970.49512@stoffel.org>
	<20090519204152.GE9053@mit.edu>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Theodore" == Theodore Tso <tytso@mit.edu> writes:

Oops.  It looks like 2.6.29.3 is actually quite solid.  My fault, I
must have gotten confused.  I know that 2.6.30-rc* was unstable on
there and locked up easily.  


Theodore> On Tue, May 19, 2009 at 02:27:14PM -0400, John Stoffel wrote:
>> I wonder if this is the reason my main file server has been locking up
>> solid under 2.6.29 or newer kernels lately, but 2.6.28 is rock solid.
>> Since it's my main file server at home, and with my home dir NFS
>> mounted from it onto another system, it's been hard to catch.  I spent
>> some time fiddling around getting netconsole setup, but then I ran out
>> of time.

Theodore> Unless you have your partition mounted with the "sync" mount
Theodore> option (which has negative performance implifications; it
Theodore> makes sense for a mail queue directory, but not necessarily
Theodore> for a general purpose file server) or you have a directory
Theodore> chattr'ed with the sync flag, probably not...

Theodore> If you want to try it, though, the patch is available here:

Theodore>    http://bugzilla.kernel.org/attachment.cgi?id=21436

Ok, then it's probably not something I need to test, since I'm only
mounting stuff noatime.  

>> If someone could send me the patch, I'll apply it and see how well
>> 2.6.29.[34] works, and whether or not 2.6.30-rcN works as well.
>> Reproducing the problem was pretty easy for me.  

Theodore> Anything on the console?  Any oops messages, or soft lockup warnings?

Nothing.  I've not had the time lately to reboot the system to try
2.6.29 or newer with all the lockup debugging stuff yet.  Maybe
tonight I'll get a chance.

Theodore> What filesystem(s) are you using?

ext3 for everything, except one staging area running ext4 which is
only used for bacula to stage data before writing to tape.  It's solid
under 2.6.29.3 (dammit, I must have mis-remembered) and it's been up
now for six days running backups and serving NFS files.  

Here's my filesystems:

  > mount
  /dev/sda2 on / type ext3 (rw,errors=remount-ro)
  tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
  proc on /proc type proc (rw,noexec,nosuid,nodev)
  sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
  procbususb on /proc/bus/usb type usbfs (rw)
  /udev on /dev type tmpfs (rw,mode=0755)
  tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
  devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
  fusectl on /sys/fs/fuse/connections type fusectl (rw)
  /dev/sda5 on /var type ext3 (rw,noatime)
  /dev/sda1 on /boot type ext3 (rw,noatime)
  /dev/sda6 on /usr type ext3 (rw,noatime)
  /dev/dm-1 on /home type ext3 (rw,noatime)
  /dev/dm-2 on /local type ext3 (rw,noatime)
  overflow on /tmp type tmpfs (rw,size=1048576,mode=1777,size=50%)
  rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
  nfsd on /proc/fs/nfsd type nfsd (rw)
  binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
  (rw,noexec,nosuid,nodev)
  /dev/mapper/onetwenty-staging on /staging type ext4 (rw,noatime)


When the system locks up, there's nothing in the logs, nothing on the
screen, even when I leave it turned to VT1 (Ctl-Alt-F1) and then wait
for a lockup, the screen is completely blank.

I'll see about finding some more time to beat on this and get better
results back to people.

John
