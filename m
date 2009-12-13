Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbZLMIiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbZLMIiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 03:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZLMIiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 03:38:21 -0500
Received: from yop.chewa.net ([91.121.105.214]:38928 "HELO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751777AbZLMIiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 03:38:20 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Dec 2009 03:38:19 EST
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Organization: Remlab.net
To: Michael Stone <michael@laptop.org>
Subject: Re: Network isolation with RLIMIT_NETWORK, cont'd.
Date: Sun, 13 Dec 2009 10:32:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>
References: <20091213034418.GA4416@heat>
In-Reply-To: <20091213034418.GA4416@heat>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912131032.24251.remi@remlab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

Le dimanche 13 décembre 2009 05:44:18 Michael Stone, vous avez écrit :
> You were all meant to be included on the CC-list for the letter and patches
> which I just sent to lkml:
> 
>    http://lkml.org/lkml/2009/12/12/149

You explicitly mention the need to connect to the X server over local sockets.  
But won't that allow the sandboxed application to send synthetic events to any 
other X11 applications? Hence unless the whole X server has restricted network 
access, this seems a bit broken? D-Bus, which also uses local sockets, will 
exhibit similar issues, as will any unrestricted IPC mechanism in fact.

I am not sure if restricting network access but not other file descriptors 
makes that much sense... ? Then again, I'm not entirely clear what you are 
trying to solve.

If I had to sandbox something, I'd drop the process file limit to 0. That will 
effectively cut off network, file system, and POSIX IPCs. Unfortunately, the 
process can still use SysV IPC, ptrace(), and send signals to others. So those 
are the gaps I would first try to contain.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
