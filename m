Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYLKPh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYLKPh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYLKPhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:37:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42219 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755711AbYLKPhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:37:46 -0500
Date: Thu, 11 Dec 2008 10:37:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: CSights <csights@fastmail.fm>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: idle USB harddrive spins up with 2.6.28-rc7 and 2.6.27.8, but
 not with 2.6.26.8
In-Reply-To: <20081210133240.8fa798bf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0812111036260.2526-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Andrew Morton wrote:

> (cc linux-usb)
> 
> On Tue, 9 Dec 2008 18:12:33 -0500
> CSights <csights@fastmail.fm> wrote:
> 
> > Hi LKML,
> > 	I've got an IDE harddrive in a USB external enclosure. It is /dev/sda.
> > 	When I'm compiling the kernel or doing other things on /dev/hda1 the USB 
> > harddrive (sda1) will spin-up or not spin-down.  This happens with kernel 
> > versions 2.6.28-rc7 and 2.6.27.8, but not with 2.6.26.8.
> > 	Also, I'm using laptop-mode-tools to turn on laptop mode.
> > 	I used the "btrace" script on /dev/sda while compiling a kernel on /dev/hda1.  
> > While running 2.6.26.8 btrace did not output anything.  With 2.6.27.8 and 
> > 2.6.28-rc7 a load of stuff was going on with /dev/sda.
> > 	I don't know what it means, but it is probably what is causing the harddrive 
> > to spin up. :)  Hopefully someone besides me will consider this 
> > a "regression".  Let me know if you need any other info.
> > 
> > Thanks!
> > 	C.
> > 
> > Using 2.6.26.8, btrace of /dev/sda while compiling on /dev/hda1
> > 	did not output anything.
> > 
> > Using 2.6.27.8, btrace of /dev/sda while compiling on /dev/hda1
> > Dec  9 11:15:32 localhost logger:   8,0    0        1     0.000000000  1109  A  
> > WS 14375 + 8 <- (8,1) 14312
> > Dec  9 11:15:32 localhost logger:   8,0    0        2     0.000006705  1109  Q  
> > WS 14375 + 8 [kjournald]
> > Dec  9 11:15:32 localhost logger:   8,0    0        3     0.000043581  1109  G  
> > WS 14375 + 8 [kjournald]
> > Dec  9 11:15:32 localhost logger:   8,0    0        4     0.000065651  1109  P   
> > N [kjournald]
> > Dec  9 11:15:32 localhost logger:   8,0    0        5     0.000076267  1109  I   
> > W 14375 + 8 [kjournald]
> > Dec  9 11:15:32 localhost logger:   8,0    0        6     0.000300318  1109  D   
> > W 14375 + 8 [kjournald]
> > Dec  9 11:15:32 localhost logger:   8,0    0        7     0.000423518  1109  U   
> > N [kjournald] 1
> > Dec  9 11:15:32 localhost logger:   8,0    0        8     0.010028373     3  C   
> > W 14375 + 8 [0]
> > Dec  9 11:15:35 localhost logger:   8,0    0        9     3.219049689  1109  A  
> > WS 14383 + 8 <- (8,1) 14320
> > Dec  9 11:15:35 localhost logger:   8,0    0       10     3.219058350  1109  Q  
> > WS 14383 + 8 [kjournald]
> > Dec  9 11:15:35 localhost logger:   8,0    0       11     3.219095505  1109  G  
> > WS 14383 + 8 [kjournald]
> > Dec  9 11:15:35 localhost logger:   8,0    0       12     3.219115061  1109  P   
> > N [kjournald]
> > Dec  9 11:15:35 localhost logger:   8,0    0       13     3.219127074  1109  I   
> > W 14383 + 8 [kjournald]
> > Dec  9 11:15:35 localhost logger:   8,0    0       14     3.219344699  1109  D   
> > W 14383 + 8 [kjournald]
> > Dec  9 11:15:35 localhost logger:   8,0    0       15     3.219543607  1109  U   
> > N [kjournald] 1
> > Dec  9 11:15:35 localhost logger:   8,0    0       16     3.229477275     3  C   
> > W 14383 + 8 [0]
> > Dec  9 11:15:40 localhost logger:   8,0    0       17     8.372429561  1109  A  
> > WS 14391 + 8 <- (8,1) 14328
> > Dec  9 11:15:40 localhost logger:   8,0    0       18     8.372437663  1109  Q  
> > WS 14391 + 8 [kjournald]
> > Dec  9 11:15:40 localhost logger:   8,0    0       19     8.372474539  1109  G  
> > WS 14391 + 8 [kjournald]
> > Dec  9 11:15:40 localhost logger:   8,0    0       20     8.372496329  1109  P   
> > N [kjournald]
> > Dec  9 11:15:40 localhost logger:   8,0    0       21     8.372508063  1109  I   
> > W 14391 + 8 [kjournald]
> > Dec  9 11:15:40 localhost logger:   8,0    0       22     8.372729320  1109  D   
> > W 14391 + 8 [kjournald]
> > Dec  9 11:15:40 localhost logger:   8,0    0       23     8.372839669  1109  U   
> > N [kjournald] 1
> > Dec  9 11:15:40 localhost logger:   8,0    0       24     8.382665781     3  C   
> > W 14391 + 8 [0]
> > Dec  9 11:15:49 localhost logger:   8,0    0       25    17.082110738  1109  A  
> > WS 14399 + 8 <- (8,1) 14336
> > Dec  9 11:15:49 localhost logger:   8,0    0       26    17.082119119  1109  Q  
> > WS 14399 + 8 [kjournald]
> > Dec  9 11:15:49 localhost logger:   8,0    0       27    17.082156834  1109  G  
> > WS 14399 + 8 [kjournald]
> > Dec  9 11:15:49 localhost logger:   8,0    0       28    17.082180859  1109  P   
> > N [kjournald]
> > Dec  9 11:15:49 localhost logger:   8,0    0       29    17.082193431  1109  I   
> > W 14399 + 8 [kjournald]
> > Dec  9 11:15:49 localhost logger:   8,0    0       30    17.082418878  1109  D   
> > W 14399 + 8 [kjournald]
> > Dec  9 11:15:49 localhost logger:   8,0    0       31    17.082527831  1109  U   
> > N [kjournald] 1
> > Dec  9 11:15:49 localhost logger:   8,0    0       32    17.092196101     3  C   
> > W 14399 + 8 [0]
> > ...etc...
> > 
> > Using kernel 2.6.28-rc7, btrace of /dev/sda while compiling on /dev/hda1
> > Dec  9 17:48:37 localhost logger:   8,0    0        1     0.000000000  1129  A  
> > WS 12567 + 8 <- (8,1) 12504
> > Dec  9 17:48:37 localhost logger:   8,0    0        2     0.000005587  1129  Q  
> > WS 12567 + 8 [kjournald]
> > Dec  9 17:48:37 localhost logger:   8,0    0        3     0.000038553  1129  G  
> > WS 12567 + 8 [kjournald]
> > Dec  9 17:48:37 localhost logger:   8,0    0        4     0.000061460  1129  P   
> > N [kjournald]
> > Dec  9 17:48:37 localhost logger:   8,0    0        5     0.000074032  1129  I   
> > W 12567 + 8 [kjournald]
> > Dec  9 17:48:37 localhost logger:   8,0    0        6     0.000266235  1129  D   
> > W 12567 + 8 [kjournald]
> > Dec  9 17:48:37 localhost logger:   8,0    0        7     0.000372394  1129  U   
> > N [kjournald] 1
> > Dec  9 17:48:37 localhost logger:   8,0    0        8     0.010619230     3  C   
> > W 12567 + 8 [0]
> > Dec  9 17:49:19 localhost logger:   8,0    0        9    41.770854333  1129  A  
> > WS 12575 + 8 <- (8,1) 12512
> > Dec  9 17:49:19 localhost logger:   8,0    0       10    41.770862156  1129  Q  
> > WS 12575 + 8 [kjournald]
> > Dec  9 17:49:19 localhost logger:   8,0    0       11    41.770895121  1129  G  
> > WS 12575 + 8 [kjournald]
> > Dec  9 17:49:19 localhost logger:   8,0    0       12    41.770917191  1129  P   
> > N [kjournald]
> > Dec  9 17:49:19 localhost logger:   8,0    0       13    41.770929483  1129  I   
> > W 12575 + 8 [kjournald]
> > Dec  9 17:49:19 localhost logger:   8,0    0       14    41.771122524  1129  D   
> > W 12575 + 8 [kjournald]
> > Dec  9 17:49:19 localhost logger:   8,0    0       15    41.771247680  1129  U   
> > N [kjournald] 1
> > Dec  9 17:49:19 localhost logger:   8,0    0       16    41.780654465     3  C   
> > W 12575 + 8 [0]
> > Dec  9 17:49:22 localhost logger:   8,0    0       17    44.820030708  1129  A  
> > WS 12583 + 8 <- (8,1) 12520
> > Dec  9 17:49:22 localhost logger:   8,0    0       18    44.820038530  1129  Q  
> > WS 12583 + 8 [kjournald]
> > Dec  9 17:49:22 localhost logger:   8,0    0       19    44.820069539  1129  G  
> > WS 12583 + 8 [kjournald]
> > Dec  9 17:49:22 localhost logger:   8,0    0       20    44.820091050  1129  P   
> > N [kjournald]
> > Dec  9 17:49:22 localhost logger:   8,0    0       21    44.820103622  1129  I   
> > W 12583 + 8 [kjournald]
> > Dec  9 17:49:22 localhost logger:   8,0    0       22    44.820291914  1129  D   
> > W 12583 + 8 [kjournald]
> > Dec  9 17:49:22 localhost logger:   8,0    0       23    44.820386898  1129  U   
> > N [kjournald] 1
> > Dec  9 17:49:22 localhost logger:   8,0    0       24    44.830135906     3  C   
> > W 12583 + 8 [0]
> > ...etc...

This is not a USB issue.  usb-storage merely passes on to the device 
the requests it gets from higher up.  If those requests cause the drive 
to spin-up or not spin-down, blame the higher-up subsystems.

Alan Stern

