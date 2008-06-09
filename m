Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYFIAQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYFIAQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbYFIAPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:15:46 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:52339 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756595AbYFIAPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:15:45 -0400
Date: Sun, 8 Jun 2008 21:15:40 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080609001540.GA19072@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <200806081242.54896.IvDoorn@gmail.com> <20080608213513.GA30499@ime.usp.br> <200806090002.17938.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806090002.17938.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, yet again, Ivo.

On Jun 09 2008, Ivo van Doorn wrote:
> > Unfortunately, I don't have any kernel for which this has worked for
> > me. I just did an experiment: I plugged the adaptor on a ia32 notebook
> > where a rt61pci works fine (it is running Ubuntu's Hardy---well,
> > actually, there are some problems, but I can get to that latter), but
> > the USB key was non working with the symptoms that I described above.

Correction here: I just went to the ia32 notebook again and, now, running
Ubuntu's hardy kernel (which is a patched 2.6.24 kernel, AFAIK---yes, it
is; just checked it) I could make the D-Link stick work fine.

Unfortunately, it seems that while Ubuntu has debugfs compiled, it doesn't
have the rt2x00 debug information compiled in the standard kernel (I will
see if they have any debug version of their kernel---this ia32 notebook is a
Celeron 466MHz and it is also slow at compiling kernels, just as the iBook
is and it is my parents' only machine).

Unfortunately, I can't get your script to run here, since I got:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
root@rbrito-laptop:~# LANG= bash Desktop/regdump.txt 
ls: cannot access /debug/ieee80211/phy*/rt[0-9]*/: No such file or directory
root@rbrito-laptop:~# 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

> That is most unfortunate, since register dumps are usually most usefull when
> I can compare the actual register values between a working and non-working setup.
> However I just realized I had a D-Link stick myself, and apparently I have the exact
> same model/type. I'll compile a 2.6.26-rc5 kernel and see if that stick works for me,
> if so, I have the working register dump. And if not, then we can rule out
> endian problems.

Well, I think that I was a bit hasty with my tests on ia32 and this Ubuntu
notebook.

Here is, BTW, the output of iwconfig on this machine, where I could get
the stick working:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
root@rbrito-laptop:~# iwconfig
lo        no wireless extensions.

wmaster0  no wireless extensions.

ra0       IEEE 802.11g  ESSID:""  
          Mode:Managed  Frequency:2.437 GHz  Access Point:
          00:13:46:51:10:65   
          Bit Rate=2 Mb/s   Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B   
          Encryption key:XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XX
          Link Quality=71/100  Signal level=-50 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

wmaster1  no wireless extensions.

wlan0     IEEE 802.11g  ESSID:"default"  
          Mode:Managed  Frequency:2.437 GHz  Access Point:
          00:13:46:51:10:65   
          Bit Rate=54 Mb/s   Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B   
          Encryption key:XXXX-XXXX-XXXX-XXXX-XXXX-XXXX-XX
          Link Quality=47/100  Signal level=-77 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

root@rbrito-laptop:~# 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Notice that the field "Link Quality" is quite lower with the USB stick.

As you may have already noticed, I really do want to get this straightened,
so that I can use my iBook at work and will do many things to get this to
work well (and to have your drivers better in the short term).


Thanks, Rogério Brito.

P.S.: This message was written with the USB stick and an SSH connection. :-)
-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
