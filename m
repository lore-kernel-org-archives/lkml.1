Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZDEW5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZDEW5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 18:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZDEW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 18:57:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:3566 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZDEW5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 18:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=S7Qaiue+TPQ07plph2/qGxYdfQkPm/jdg815G8YHvbjvcv85GJ7YPkKpOotcM9In8l
         ylHeFfJ5qJb+nXPj1RwqXc8QfGwnULB9P6dMhsLdOMVrE7uV521WeOymMOWSbkdSgyyn
         oNRLp8wbahdpRXqRoWwo8/H/V1lnjVS3rI6vI=
Message-ID: <49D93756.2080608@gmail.com>
Date: Sun, 05 Apr 2009 18:57:26 -0400
From: John Moser <john.r.moser@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: What would cause freezes that numlock fixes?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using Ubuntu's current beta 9.04 and it's having issues.  I think 
it's a kernel thing, but I have no debug data or anything; if anyone has 
any insight as to what might be happening I'd like that.  I can't do 
debugging here (unless they package a debugging kernel).

I'm using what Ubuntu calls "2.6.28-11.40" "generic", on x86-64, with 
the uname:

Linux icebox 2.6.28-11-generic #40-Ubuntu SMP Fri Apr 3 17:39:41 UTC 
2009 x86_64 GNU/Linux


What's happening is this:

I noticed immediately that the system lags a lot, especially when under 
load, sometimes when not under load.  I figured bad scheduling at first. 
Switching to ext4 helped.

Oddly enough, switching to elevator=as instead of CFQ helps as well. 
This helps, but doesn't fix the problem.  So, I'm guessing there's no 
bug in CFQ or EXT3, but running these rather than AS and EXT4 aggravates 
symptoms.

Occasionally almost everything in X will freeze.  Some programs (like, a 
terminal) still work until they try to access the disk (say, if I run a 
command, bash hangs).  I eventually had this happen while top was 
running and noticed stuff going into state D and staying there for up to 
5 minutes, while the disk halts.  I can still shift between virtual 
desktops in Gnome, with the stipulation that every application is frozen 
and I can't start any others.

At some point (today, actually) I found a workaround.  When 
applications-- either one, or all of them-- start to freeze, if I press 
(specifically) the Num Lock key, everything suddenly wakes up.  Disk 
starts cranking like crazy, windows redraw, and I assume everything 
instantly comes back out of D state.

Just Num Lock.  Not A, not CTRL, not Tab.  Just Num Lock.

Anyone have any guesses?
