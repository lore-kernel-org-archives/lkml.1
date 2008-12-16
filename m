Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYLPVHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYLPVHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYLPVG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:06:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57000 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYLPVG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:06:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: hibernation bug - swap goes AWOL
Date: Tue, 16 Dec 2008 22:06:53 +0100
User-Agent: KMail/1.9.9
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
References: <4947ED8C.1010709@tuffmail.co.uk>
In-Reply-To: <4947ED8C.1010709@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812162206.53744.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 16 of December 2008, Alan Jenkins wrote:
> This is on 2.6.27-rc9.  I can easily test patches, or a more recent
> kernel version.
> 
> I think I've run across a bug in hibernation.  Steps to reproduce:
> 
> 1) Conspire to ensure insufficient swap space for hibernation
> 2) Attempt to hibernate, and fail
> 3) Attempt to hibernate *again*, and fail
> 4) try swapoff

> Outcome:
> 
> # swapoff /dev/sda6
> swapoff: /dev/sda6: Invalid argument
> # cat /proc/swaps
> Filename                                Type            Size    Used   
> Priority
> /dev/sda6                               partition       1494004 1350564 -1
> 
> Incidentally "swapoff -a" fails silently, which I think is a bug in
> swapoff (i.e. it should report the error).
> 
> I don't see any backtraces in dmesg; the only errors it shows is the
> failure to hibernate
> 
> If I free up some memory and try to hibernate again, I get a different
> error - "Cannot find swap device, try swapon -a.".  Now swapon -a
> doesn't work, but if I target the specific device...
> 
> # swapon /dev/sda6
> # cat /proc/swaps
> Filename                                Type            Size    Used   
> Priority
> /dev/sda6                               partition       1494004 331060  -1
> /dev/sda6                               partition       1494004 0       -2
> 
> Wheee!  Interestingly I can now hibernate and resume.  But it's not
> safe; my desktop session dies horribly.

Well, I'm not sure if the bug is in the hibernate code or in the swap code.

Anyway, please file a bugzilla report about that.

Thanks,
Rafael
