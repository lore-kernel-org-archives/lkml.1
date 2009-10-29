Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZJ2D0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZJ2D0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 23:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZJ2D0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 23:26:35 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:53641 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZJ2D0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 23:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZvRQCPl1PyllEa+rwS/ynNXkSBN4cuTXNEqIX3v2xAvM5FxkuBy9Ct79DFqHjE239N
         /rPPY6EUzuasV+g5Nk3HuFfSVlCa0DI5DFFbCiHLTTkDkK/Ub78zomoZtzlvTzq4y00i
         KBj/oRQ4nm8ZjFwjNFsW1Sfy9n1rXiL9KpJHU=
Date: Wed, 28 Oct 2009 20:26:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH][RFC] input: remove bios I8042_CTR_XLATE check to make
	keyboard usable
Message-ID: <20091029032633.GA7959@core.coreip.homeip.net>
References: <20091027053404.GA2241@darkstar.vlan7> <20091028054309.GA2368@core.coreip.homeip.net> <20091028100318.GA4861@suse.cz> <20091028104211.GA2207@darkstar.vlan7> <20091029003325.GA2739@darkstar.vlan7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029003325.GA2739@darkstar.vlan7>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 08:33:26AM +0800, Dave Young wrote:
> On Wed, Oct 28, 2009 at 06:42:12PM +0800, Dave Young wrote:
> > On Wed, Oct 28, 2009 at 11:03:18AM +0100, Vojtech Pavlik wrote:
> > > On Tue, Oct 27, 2009 at 10:43:10PM -0700, Dmitry Torokhov wrote:
> > > > Hi Dave,
> > > > 
> > > > On Tue, Oct 27, 2009 at 01:34:04PM +0800, Dave Young wrote:
> > > > > 
> > > > > Pressing somekey at early booting phase cause keyboard to be not usable
> > > > > (The hardware is DELL latitude e5400):
> > > 
> > > Does early booting mean while the BIOS is coming up? Does the keyboard
> > > work in GRUB then? Or is it during the early init of the Linux kernel?
> > 
> > Keyboard work under lilo.
> > For the early booting I means the early init of the linux kernel
> > 
> > >  
> > > > > atkbd.c: Unknown key pressed (raw set 2, code 0xd3 on isa0060/serio0).
> > > > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > > > > atkbd.c: Unknown key pressed (raw set 2, code 0x1d3 on isa0060/serio0).
> > > > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > > > > 
> > > > > i8042.c set i8042_direct to true when the controller init. But the result
> > > > > is keyboard not usable, The only option is press the power button to shutdown. 
> > > > > 
> > > > > So here remove the bios check to fix it.
> > > 
> > > My question would be: Why this happens? Could it be that the probe is
> > > confused by the keypress and reads the CTR incorrectly? Or is it just
> > > that the keyboard controller is in fact in translating mode, yet the CTR
> > > indicates otherwise?
> > > 
> > > A i8042.debug=1 log of the bad init would be good.
> > 
> > Here it is (retrieve from syslog):
> 
> Syslog redirect the debug info to another log file, sorry, post again:
> 

Any chance of reconfiguring syslog so debug is captured in the same
file? It is easier to see what is happening with the rest of context
present...

-- 
Dmitry
