Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZGKOy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZGKOy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 10:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZGKOyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 10:54:49 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:53348 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZGKOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 10:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VnSeAQ80xFifTe45SsEfBxXqBWBJdD9bAjjQJAUtJk3uKFaSnFMF0Lx9Q6O2ZreNB4
         mgmQwUVJvb31+oRTL01nZOH6VsGfI3BwdEhdkfiIAB77Jy5z9uQTXDUBY4jppaxT8dg+
         VU7ZPH3eN+Pqs6oPWF0Ug9y3dv20dv6FULRfI=
Date: Sat, 11 Jul 2009 10:54:42 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: xorg@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SIGQUIT from tty layer
Message-ID: <20090711145442.GA21222@ben-laptop>
Mail-Followup-To: xorg@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090709143141.GA17551@ben-laptop>
 <20090709150047.GE5328@const.famille.thibault.fr>
 <20090709171816.GA6046@ben-laptop>
 <20090710183346.GA7699@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710183346.GA7699@const.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 08:33:46PM +0200, Samuel Thibault wrote:
> Not writing to the tty, but producing input for the tty.  Are you
> using evdev or the legacy kbd driver? 

evdev.

> 0x1c is the keycode of the enter key, maybe your workload happens to
> restart the keyboard driver, which temporarily re-enables signal keys.
What syscall would one use to do this? Perhaps I could systemtap this.

> 
> Or maybe it's on another tty, do you have anything beyond /dev/mem,
> /dev/null, /dev/tty7, /dev/agpgart and /dev/dri/card* in
> lsof -p $(pidof Xorg) | grep CHR
> ?

[1038 ben@ben-laptop ~] $ sudo lsof -p $(pidof X)  | grep CHR
lsof: WARNING: can't stat() fuse.gvfs-fuse-daemon file system /home/ben/.gvfs
      Output information may be incomplete.
X       2787 root  mem    CHR              226,0                1191 /dev/dri/card0
X       2787 root    5w   CHR                4,7      0t0       1150 /dev/tty7
X       2787 root    8u   CHR              226,0      0t0       1191 /dev/dri/card0
X       2787 root   10u   CHR              13,66      0t0       1464 /dev/input/event2
X       2787 root   11u   CHR              13,67      0t0       1505 /dev/input/event3
X       2787 root   12u   CHR              13,65      0t0       1450 /dev/input/event1
X       2787 root   13u   CHR              13,68      0t0       1478 /dev/input/event4
X       2787 root   14u   CHR              13,69      0t0       1471 /dev/input/event5
X       2787 root   15u   CHR              13,72      0t0       4938 /dev/input/event8
X       2787 root   16u   CHR              13,71      0t0       4905 /dev/input/event7

So other than a bunch of event devices, not too much. Thanks for your
input,

- Ben

