Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYDUAIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYDUAIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYDUAH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:07:57 -0400
Received: from flatoutfitness.com ([66.178.130.209]:54930 "EHLO www.seiner.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbYDUAH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:07:56 -0400
X-Greylist: delayed 2119 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 20:07:56 EDT
Message-ID: <480BD294.9040504@seiner.com>
Date: Sun, 20 Apr 2008 16:32:36 -0700
From: Yan Seiner <yan@seiner.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: uinput question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to set up a system with multiple IR remotes acting as 
keyboards for specific X sessions.

lirc <http://www.lirc.org> is a way to send infrared remote keystrokes 
to applications.  Some time ago I wrote a small patch to kbdd 
<http://handhelds.org/moin/moin.cgi/kbdd> that lets me inject button 
pushes on an IR remote into the /dev/input/uinput system as keyboard 
events.

Now I'd like to send those keyboard events to only one X session, not 
all of them.

In the kbdd code, there is the following snippet when the 
/dev/input/uinput device is opened:

        memset(&dev, 0, sizeof(dev));
        strncpy(dev.name, "SerKBD", UINPUT_MAX_NAME_SIZE);
        dev.idbus = BUS_RS232;
        dev.idvendor = 0x00;
        dev.idproduct = 0x00;
        dev.idversion = 0x00;

So this would indicate to me that I can emulate different devices by 
changing the names, IDs, and events.  Then I want to select only those 
events that pertain to my app... 

So...
-   Create a 'virtual' eventNN device based on the data fed to kbdd
-   Send various keyboard events to the kernel via the uinput device 
from several physical devices
-   Select only those events destined for my virtual device
-   Have those events pop out of my eventNN device so I can handle them 
back in userspace

How do I do that?  Where can I find some information on how to handle 
uinput devices?

Thanks,

--Yan


-- 
  o__
  ,>/'_          o__
  (_)\(_)        ,>/'_        o__
Yan Seiner      (_)\(_)       ,>/'_     o__
Certified Personal Trainer   (_)\(_)    ,>/'_        o__
Licensed Professional Engineer         (_)\(_)       ,>/'_
Who says engineers have to be pencil necked geeks?  (_)\(_)

Help out my kids' school: http://www.seiner.com/blog/Travels/

