Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZAYMz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZAYMz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 07:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZAYMzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 07:55:48 -0500
Received: from lucidpixels.com ([75.144.35.66]:52620 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbZAYMzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 07:55:47 -0500
Date: Sun, 25 Jan 2009 07:55:46 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
 (found solution)
In-Reply-To: <alpine.DEB.1.10.0901250740360.11258@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0901250752020.11258@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan> <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan> <alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
 <alpine.DEB.1.10.0901250740360.11258@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Jan 2009, Justin Piszcz wrote:

>
>
> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>
>> 
>> 
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>> 
>>> 
>>> 
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>> 
>>>> 
>>>> 
>>>> On Sun, 25 Jan 2009, Alan Cox wrote:

        root=<root-device>
               This specifies the device that should be mounted  as  root.   It
               may  be  specified as a global option.  If the special name cur-
               rent is used, the root device is set to the device on which  the
               root  file  system  is  currently  mounted. If the root has been
               changed with  -r , the respective device is used. If  the  vari-
               able `root' is omitted, the root device setting contained in the
               kernel image is used.  (And that is set at  compile  time  using
               the  ROOT_DEV  variable in the kernel Makefile, and can later be
               changed with the rdev(8) program.)

Change root= to root=current && lilo && reboot, this works as well, note I did
have the proper UUIDs set in /etc/fstab before doing this.

Trying without changing /etc/fstab, back to old entries:
/dev/hda2     /               xfs     noatime         0       1
/dev/hda1      none            swap    sw              0       0
#UUID=77ae4251-631f-4656-a365-c5723f5c5da8      /               xfs     noatime         0       1
#UUID=2ef862e1-cf78-4065-a205-d1784716d633      none            swap    sw              0       0

(which are wrong)

p254:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdd2              73G  2.2G   71G   3% /
p254:~# df -h

But using current!

p254:~# grep current /etc/lilo.conf
# case it installs in the MBR, and will overwrite the current MBR.
root=current
         root=current
p254:~#

p254:~# reboot

Does it come back?

$ uptime
  07:55:16 up 0 min,  1 user,  load average: 0.71, 0.20, 0.07

Yes it does, so the work-around is to use root=current, fix up your /etc/fstab
and other files after.

Justin.


