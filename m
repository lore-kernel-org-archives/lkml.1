Return-Path: <linux-kernel-owner+w=401wt.eu-S932729AbZACUsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbZACUsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbZACUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:48:14 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40196 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbZACUsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:48:14 -0500
Date: Sat, 3 Jan 2009 21:49:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] Build failure in current mainline - firmware related
Message-ID: <20090103204948.GA5388@uranus.ravnborg.org>
References: <200901031247.14977.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901031247.14977.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 12:47:14PM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> I get the following error from 'make modules_install' on my test boxes:
> 
>   HOSTCC  firmware/ihex2fw                                                             
> /home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system                                            
> compilation terminated.                                                                
> make[3]: *** [firmware/ihex2fw] Error 1                                                
> make[2]: *** [_modinst_post] Error 2                                                   
> make[1]: *** [sub-make] Error 2                                                        
> make: *** [all] Error 2
> 
> where the configuration is that the kernel is compiled on a build box
> with 'make O=<destdir> -j5' and then <destdir> is mounted over NFS read-only by
> each test box (full path to this directory is the same on the build box and on
> the test boxes).  Then, I cd into <destdir>, run 'make modules_install' and get
> the error above.
> 
> 2.6.28 didn't have this problem.


Strange...
1) The string "opening dependency file" does not occur in my freshly pulled kernel
2) Line 268 is last line of ihex2fw.c

Could you try to do a "make modules_install V=1" to see the exact arguments supplied ti ihex2fw.c

I gave up on all the firmware stuff long time ago and has
never properly reviewed the implementation so I really
have no clue what is actually happening.

Walking through the 179 lines Makefile has not yet benn on my
"fun to do" list - and it most likely take a while before it hits it.

	Sam
