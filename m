Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZGJSeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZGJSeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbZGJSdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:33:51 -0400
Received: from solo.fdn.fr ([80.67.169.19]:60399 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480AbZGJSdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:33:50 -0400
Date: Fri, 10 Jul 2009 20:33:46 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, xorg@lists.freedesktop.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SIGQUIT from tty layer
Message-ID: <20090710183346.GA7699@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, xorg@lists.freedesktop.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090709143141.GA17551@ben-laptop> <20090709150047.GE5328@const.famille.thibault.fr> <20090709171816.GA6046@ben-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090709171816.GA6046@ben-laptop>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gamari, le Thu 09 Jul 2009 13:18:16 -0400, a écrit :
> On Thu, Jul 09, 2009 at 05:00:47PM +0200, Samuel Thibault wrote:
> > SIGQUIT is sent to the X server if the controling tty of the X server
> > (probably its VT) receives the QUIT character (usually control-\, i.e.
> > 0x1c)
> 
> This, however, would imply that something is sending the character and
> this something is certainly not me. Where else might this character come
> from? How might I trace who's writing to the tty?

Not writing to the tty, but producing input for the tty.  Are you
using evdev or the legacy kbd driver? 0x1c is the keycode of the enter
key, maybe your workload happens to restart the keyboard driver, which
temporarily re-enables signal keys.

Or maybe it's on another tty, do you have anything beyond /dev/mem,
/dev/null, /dev/tty7, /dev/agpgart and /dev/dri/card* in
lsof -p $(pidof Xorg) | grep CHR
?

Samuel
