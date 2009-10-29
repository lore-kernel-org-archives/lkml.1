Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZJ2AeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZJ2AeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZJ2AeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:34:14 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42019 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbZJ2AeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p2AToxzu8taf9sgs3ZL0irNbGr1CYK7g3RDjO49WNPkISrGrx07NmZoe0RoMaAqD6T
         k8qKGW+LYe6z/9pe7JXExdXI7M2R8OVb9wC2A/Ix7AfnT+vFs19yOSUZlgS1hx68njwm
         3bi5xVsp5EZW4Ot78R+47B/JPpY+cLHvgZQZo=
Date: Thu, 29 Oct 2009 08:33:26 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH][RFC] input: remove bios I8042_CTR_XLATE check to make
	keyboard usable
Message-ID: <20091029003325.GA2739@darkstar.vlan7>
References: <20091027053404.GA2241@darkstar.vlan7> <20091028054309.GA2368@core.coreip.homeip.net> <20091028100318.GA4861@suse.cz> <20091028104211.GA2207@darkstar.vlan7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028104211.GA2207@darkstar.vlan7>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 06:42:12PM +0800, Dave Young wrote:
> On Wed, Oct 28, 2009 at 11:03:18AM +0100, Vojtech Pavlik wrote:
> > On Tue, Oct 27, 2009 at 10:43:10PM -0700, Dmitry Torokhov wrote:
> > > Hi Dave,
> > > 
> > > On Tue, Oct 27, 2009 at 01:34:04PM +0800, Dave Young wrote:
> > > > 
> > > > Pressing somekey at early booting phase cause keyboard to be not usable
> > > > (The hardware is DELL latitude e5400):
> > 
> > Does early booting mean while the BIOS is coming up? Does the keyboard
> > work in GRUB then? Or is it during the early init of the Linux kernel?
> 
> Keyboard work under lilo.
> For the early booting I means the early init of the linux kernel
> 
> >  
> > > > atkbd.c: Unknown key pressed (raw set 2, code 0xd3 on isa0060/serio0).
> > > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > > > atkbd.c: Unknown key pressed (raw set 2, code 0x1d3 on isa0060/serio0).
> > > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > > > 
> > > > i8042.c set i8042_direct to true when the controller init. But the result
> > > > is keyboard not usable, The only option is press the power button to shutdown. 
> > > > 
> > > > So here remove the bios check to fix it.
> > 
> > My question would be: Why this happens? Could it be that the probe is
> > confused by the keypress and reads the CTR incorrectly? Or is it just
> > that the keyboard controller is in fact in translating mode, yet the CTR
> > indicates otherwise?
> > 
> > A i8042.debug=1 log of the bad init would be good.
> 
> Here it is (retrieve from syslog):

Syslog redirect the debug info to another log file, sorry, post again:

Oct 28 18:31:40 darkstar kernel: [    2.656902] drivers/input/serio/i8042.c: 20 <- i8042 (flush, kbd) [0]
Oct 28 18:31:40 darkstar kernel: [    2.657060] drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
Oct 28 18:31:40 darkstar kernel: [    2.657068] drivers/input/serio/i8042.c: a0 <- i8042 (return) [0]
Oct 28 18:31:40 darkstar kernel: [    2.657131] drivers/input/serio/i8042.c: 60 -> i8042 (command) [0]
Oct 28 18:31:40 darkstar kernel: [    2.657346] drivers/input/serio/i8042.c: b0 -> i8042 (parameter) [0]
Oct 28 18:31:40 darkstar kernel: [    2.657406] drivers/input/serio/i8042.c: 65 <- i8042 (flush, kbd) [0]
Oct 28 18:31:40 darkstar kernel: [    2.657465] drivers/input/serio/i8042.c: d3 -> i8042 (command) [0]
Oct 28 18:31:40 darkstar kernel: [    2.657510] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [0]
Oct 28 18:31:40 darkstar kernel: [    2.657510] drivers/input/serio/i8042.c: 5a <- i8042 (return) [0]
Oct 28 18:31:40 darkstar kernel: [    2.661484] drivers/input/serio/i8042.c: a7 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.661541] drivers/input/serio/i8042.c: 20 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.661863] drivers/input/serio/i8042.c: b0 <- i8042 (return) [2]
Oct 28 18:31:40 darkstar kernel: [    2.661868] drivers/input/serio/i8042.c: a8 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.661925] drivers/input/serio/i8042.c: 20 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.662247] drivers/input/serio/i8042.c: 90 <- i8042 (return) [2]
Oct 28 18:31:40 darkstar kernel: [    2.662252] drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.662310] drivers/input/serio/i8042.c: b0 -> i8042 (parameter) [2]
Oct 28 18:31:40 darkstar kernel: [    2.662426] drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.662589] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [2]
Oct 28 18:31:40 darkstar kernel: [    2.662861] drivers/input/serio/i8042.c: f0 <- i8042 (return) [2]
Oct 28 18:31:40 darkstar kernel: [    2.662866] drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.662924] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [2]
Oct 28 18:31:40 darkstar kernel: [    2.663196] drivers/input/serio/i8042.c: 56 <- i8042 (return) [2]
Oct 28 18:31:40 darkstar kernel: [    2.663201] drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.663260] drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [2]
Oct 28 18:31:40 darkstar kernel: [    2.663584] drivers/input/serio/i8042.c: a4 <- i8042 (return) [2]
Oct 28 18:31:40 darkstar kernel: [    2.663623] drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.663682] drivers/input/serio/i8042.c: 92 -> i8042 (parameter) [2]
Oct 28 18:31:40 darkstar kernel: [    2.663813] drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
Oct 28 18:31:40 darkstar kernel: [    2.663924] drivers/input/serio/i8042.c: 83 -> i8042 (parameter) [2]
Oct 28 18:31:40 darkstar kernel: [    2.665885] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [3]
Oct 28 18:31:40 darkstar kernel: [    3.735576] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [324]
Oct 28 18:31:40 darkstar kernel: [    3.735636] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [324]
Oct 28 18:31:40 darkstar kernel: [    3.747159] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [327]
Oct 28 18:31:40 darkstar kernel: [    3.759002] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [327]
Oct 28 18:31:40 darkstar kernel: [    3.765945] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [333]
Oct 28 18:31:40 darkstar kernel: [    3.766539] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [333]
Oct 28 18:31:40 darkstar kernel: [    3.770884] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 28 18:31:40 darkstar kernel: [    3.785997] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [339]
Oct 28 18:31:40 darkstar kernel: [    3.799735] lib80211_crypt: registered algorithm 'NULL'
Oct 28 18:31:40 darkstar kernel: [    3.939601] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [385]
Oct 28 18:31:40 darkstar kernel: [    3.939740] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [385]
Oct 28 18:31:40 darkstar kernel: [    3.939872] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [385]
Oct 28 18:31:40 darkstar kernel: [    3.940576] PM: Checking image partition /dev/sda8
Oct 28 18:31:40 darkstar kernel: [    3.940620] PM: Resume from partition 8:8
Oct 28 18:31:40 darkstar kernel: [    3.940622] PM: Checking hibernation image.
Oct 28 18:31:40 darkstar kernel: [    4.195691] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [462]
Oct 28 18:31:40 darkstar kernel: [    4.195773] drivers/input/serio/i8042.c: 60 -> i8042 (command) [462]
Oct 28 18:31:40 darkstar kernel: [    4.195885] drivers/input/serio/i8042.c: 82 -> i8042 (parameter) [462]
Oct 28 18:31:40 darkstar kernel: [    4.195995] drivers/input/serio/i8042.c: 60 -> i8042 (command) [462]
Oct 28 18:31:40 darkstar kernel: [    4.196106] drivers/input/serio/i8042.c: 83 -> i8042 (parameter) [462]
Oct 28 18:31:40 darkstar kernel: [    4.196116] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 0) [462]
Oct 28 18:31:40 darkstar kernel: [    4.196209] drivers/input/serio/i8042.c: d4 -> i8042 (command) [462]
Oct 28 18:31:40 darkstar kernel: [    4.196372] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [462]
Oct 28 18:31:40 darkstar kernel: [    4.217278] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [469]
Oct 28 18:31:40 darkstar kernel: [    4.217289] drivers/input/serio/i8042.c: Interrupt 1, without any data [469]
Oct 28 18:31:40 darkstar kernel: [    4.228066] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [472]
Oct 28 18:31:40 darkstar kernel: [    4.228195] drivers/input/serio/i8042.c: 21 <- i8042 (interrupt, 0, 1) [472]
Oct 28 18:31:40 darkstar kernel: [    4.228769] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [472]
Oct 28 18:31:40 darkstar kernel: [    4.228914] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [472]
Oct 28 18:31:40 darkstar kernel: [    4.230807] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [472]
Oct 28 18:31:40 darkstar kernel: [    4.232831] drivers/input/serio/i8042.c: 24 <- i8042 (interrupt, 0, 1) [473]
Oct 28 18:31:40 darkstar kernel: [    4.232984] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [473]
Oct 28 18:31:40 darkstar kernel: [    4.234898] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [474]
Oct 28 18:31:40 darkstar kernel: [    4.245864] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [477]
Oct 28 18:31:40 darkstar kernel: [    4.256660] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [480]
Oct 28 18:31:40 darkstar kernel: [    4.256785] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [480]
Oct 28 18:31:40 darkstar kernel: [    4.256806] drivers/input/serio/i8042.c: 60 -> i8042 (command) [480]
Oct 28 18:31:40 darkstar kernel: [    4.256866] drivers/input/serio/i8042.c: 81 -> i8042 (parameter) [480]
Oct 28 18:31:40 darkstar kernel: [    4.256976] drivers/input/serio/i8042.c: 60 -> i8042 (command) [480]
Oct 28 18:31:40 darkstar kernel: [    4.257087] drivers/input/serio/i8042.c: 83 -> i8042 (parameter) [480]
Oct 28 18:31:40 darkstar kernel: [    4.257293] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [480]
Oct 28 18:31:40 darkstar kernel: [    4.257308] sr 1:0:0:0: Attached scsi CD-ROM sr0
Oct 28 18:31:40 darkstar kernel: [    4.257608] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [481]
Oct 28 18:31:40 darkstar kernel: [    4.268434] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [484]
Oct 28 18:31:40 darkstar kernel: [    4.268578] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [484]
Oct 28 18:31:40 darkstar kernel: [    4.268611] drivers/input/serio/i8042.c: 60 -> i8042 (command) [484]
Oct 28 18:31:40 darkstar kernel: [    4.268670] drivers/input/serio/i8042.c: 82 -> i8042 (parameter) [484]
Oct 28 18:31:40 darkstar kernel: [    4.268780] drivers/input/serio/i8042.c: 60 -> i8042 (command) [484]
Oct 28 18:31:40 darkstar kernel: [    4.268892] drivers/input/serio/i8042.c: 83 -> i8042 (parameter) [484]
Oct 28 18:31:40 darkstar kernel: [    4.269043] drivers/input/serio/i8042.c: d4 -> i8042 (command) [484]
Oct 28 18:31:40 darkstar kernel: [    4.269154] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [484]
Oct 28 18:31:40 darkstar kernel: [    4.271872] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [485]
Oct 28 18:31:40 darkstar kernel: [    4.272932] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [485]
Oct 28 18:31:40 darkstar kernel: [    4.272970] drivers/input/serio/i8042.c: d4 -> i8042 (command) [485]
Oct 28 18:31:40 darkstar kernel: [    4.273032] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [485]
Oct 28 18:31:40 darkstar kernel: [    4.275679] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [486]
Oct 28 18:31:40 darkstar kernel: [    4.275733] drivers/input/serio/i8042.c: d4 -> i8042 (command) [486]
Oct 28 18:31:40 darkstar kernel: [    4.275794] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [486]
Oct 28 18:31:40 darkstar kernel: [    4.276084] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [486]
Oct 28 18:31:40 darkstar kernel: [    4.276113] drivers/input/serio/i8042.c: d4 -> i8042 (command) [486]
Oct 28 18:31:40 darkstar kernel: [    4.276175] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [486]
Oct 28 18:31:40 darkstar kernel: [    4.281510] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [488]
Oct 28 18:31:40 darkstar kernel: [    4.281589] drivers/input/serio/i8042.c: d4 -> i8042 (command) [488]
Oct 28 18:31:40 darkstar kernel: [    4.284074] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [488]
Oct 28 18:31:40 darkstar kernel: [    4.284429] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [489]
Oct 28 18:31:40 darkstar kernel: [    4.284471] drivers/input/serio/i8042.c: d4 -> i8042 (command) [489]
Oct 28 18:31:40 darkstar kernel: [    4.285535] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [489]
Oct 28 18:31:40 darkstar kernel: [    4.290952] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [490]
Oct 28 18:31:40 darkstar kernel: [    4.291064] drivers/input/serio/i8042.c: d4 -> i8042 (command) [491]
Oct 28 18:31:40 darkstar kernel: [    4.291129] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [491]
Oct 28 18:31:40 darkstar kernel: [    4.291557] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [491]
Oct 28 18:31:40 darkstar kernel: [    4.291621] drivers/input/serio/i8042.c: d4 -> i8042 (command) [491]
Oct 28 18:31:40 darkstar kernel: [    4.291685] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [491]
Oct 28 18:31:40 darkstar kernel: [    4.296717] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [492]
Oct 28 18:31:40 darkstar kernel: [    4.296810] drivers/input/serio/i8042.c: d4 -> i8042 (command) [493]
Oct 28 18:31:40 darkstar kernel: [    4.296876] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [493]
Oct 28 18:31:40 darkstar kernel: [    4.297260] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [493]
Oct 28 18:31:40 darkstar kernel: [    4.297327] drivers/input/serio/i8042.c: d4 -> i8042 (command) [493]
Oct 28 18:31:40 darkstar kernel: [    4.297391] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [493]
Oct 28 18:31:40 darkstar kernel: [    4.302484] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [494]
Oct 28 18:31:40 darkstar kernel: [    4.302572] drivers/input/serio/i8042.c: d4 -> i8042 (command) [494]
Oct 28 18:31:40 darkstar kernel: [    4.302636] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [494]
Oct 28 18:31:40 darkstar kernel: [    4.303025] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [494]
Oct 28 18:31:40 darkstar kernel: [    4.303097] drivers/input/serio/i8042.c: d4 -> i8042 (command) [494]
Oct 28 18:31:40 darkstar kernel: [    4.303161] drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [494]
Oct 28 18:31:40 darkstar kernel: [    4.308265] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [496]
Oct 28 18:31:40 darkstar kernel: [    4.308350] drivers/input/serio/i8042.c: d4 -> i8042 (command) [496]
Oct 28 18:31:40 darkstar kernel: [    4.310938] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [496]
Oct 28 18:31:40 darkstar kernel: [    4.311258] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [497]
Oct 28 18:31:40 darkstar kernel: [    4.311306] drivers/input/serio/i8042.c: d4 -> i8042 (command) [497]
Oct 28 18:31:40 darkstar kernel: [    4.311475] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [497]
Oct 28 18:31:40 darkstar kernel: [    4.311493] drivers/input/serio/i8042.c: a4 <- i8042 (interrupt, 0, 1) [497]
Oct 28 18:31:40 darkstar kernel: [    4.316576] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [498]
Oct 28 18:31:40 darkstar kernel: [    4.316666] drivers/input/serio/i8042.c: d4 -> i8042 (command) [498]
Oct 28 18:31:40 darkstar kernel: [    4.316731] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [498]
Oct 28 18:31:40 darkstar kernel: [    4.317121] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [499]
Oct 28 18:31:40 darkstar kernel: [    4.317196] drivers/input/serio/i8042.c: d4 -> i8042 (command) [499]
Oct 28 18:31:40 darkstar kernel: [    4.317260] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [499]
Oct 28 18:31:40 darkstar kernel: [    4.322687] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [500]
Oct 28 18:31:40 darkstar kernel: [    4.322774] drivers/input/serio/i8042.c: d4 -> i8042 (command) [500]
Oct 28 18:31:40 darkstar kernel: [    4.322839] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [500]
Oct 28 18:31:40 darkstar kernel: [    4.323235] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [500]
Oct 28 18:31:40 darkstar kernel: [    4.323308] drivers/input/serio/i8042.c: d4 -> i8042 (command) [500]
Oct 28 18:31:40 darkstar kernel: [    4.323372] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [500]
Oct 28 18:31:40 darkstar kernel: [    4.328416] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [502]
Oct 28 18:31:40 darkstar kernel: [    4.328502] drivers/input/serio/i8042.c: d4 -> i8042 (command) [502]
Oct 28 18:31:40 darkstar kernel: [    4.328567] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [502]
Oct 28 18:31:40 darkstar kernel: [    4.328955] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [502]
Oct 28 18:31:40 darkstar kernel: [    4.329027] drivers/input/serio/i8042.c: d4 -> i8042 (command) [502]
Oct 28 18:31:40 darkstar kernel: [    4.329091] drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [502]
Oct 28 18:31:40 darkstar kernel: [    4.334235] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [504]
Oct 28 18:31:40 darkstar kernel: [    4.334320] drivers/input/serio/i8042.c: d4 -> i8042 (command) [504]
Oct 28 18:31:40 darkstar kernel: [    4.336699] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [504]
Oct 28 18:31:40 darkstar kernel: [    4.337031] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [505]
Oct 28 18:31:40 darkstar kernel: [    4.337079] drivers/input/serio/i8042.c: d4 -> i8042 (command) [505]
Oct 28 18:31:40 darkstar kernel: [    4.337144] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [505]
Oct 28 18:31:40 darkstar kernel: [    4.342815] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [506]
Oct 28 18:31:40 darkstar kernel: [    4.342876] drivers/input/serio/i8042.c: d4 -> i8042 (command) [506]
Oct 28 18:31:40 darkstar kernel: [    4.342941] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [506]
Oct 28 18:31:40 darkstar kernel: [    4.343350] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [506]
Oct 28 18:31:40 darkstar kernel: [    4.343429] drivers/input/serio/i8042.c: d4 -> i8042 (command) [507]
Oct 28 18:31:40 darkstar kernel: [    4.343494] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [507]
Oct 28 18:31:40 darkstar kernel: [    4.348529] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [508]
Oct 28 18:31:40 darkstar kernel: [    4.348616] drivers/input/serio/i8042.c: d4 -> i8042 (command) [508]
Oct 28 18:31:40 darkstar kernel: [    4.348680] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [508]
Oct 28 18:31:40 darkstar kernel: [    4.351647] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [509]
Oct 28 18:31:40 darkstar kernel: [    4.352722] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [509]
Oct 28 18:31:40 darkstar kernel: [    4.352809] drivers/input/serio/i8042.c: d4 -> i8042 (command) [509]
Oct 28 18:31:40 darkstar kernel: [    4.352873] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [509]
Oct 28 18:31:40 darkstar kernel: [    4.353267] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [509]
Oct 28 18:31:40 darkstar kernel: [    4.353340] drivers/input/serio/i8042.c: d4 -> i8042 (command) [509]
Oct 28 18:31:40 darkstar kernel: [    4.353405] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [509]
Oct 28 18:31:40 darkstar kernel: [    4.358597] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [511]
Oct 28 18:31:40 darkstar kernel: [    4.358681] drivers/input/serio/i8042.c: d4 -> i8042 (command) [511]
Oct 28 18:31:40 darkstar kernel: [    4.361376] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [511]
Oct 28 18:31:40 darkstar kernel: [    4.361717] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [512]
Oct 28 18:31:40 darkstar kernel: [    4.361765] drivers/input/serio/i8042.c: d4 -> i8042 (command) [512]
Oct 28 18:31:40 darkstar kernel: [    4.361882] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [512]
Oct 28 18:31:40 darkstar kernel: [    4.361900] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [512]
Oct 28 18:31:40 darkstar kernel: [    4.367150] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [514]
Oct 28 18:31:40 darkstar kernel: [    4.367238] drivers/input/serio/i8042.c: d4 -> i8042 (command) [514]
Oct 28 18:31:40 darkstar kernel: [    4.367303] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [514]
Oct 28 18:31:40 darkstar kernel: [    4.367688] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [514]
Oct 28 18:31:40 darkstar kernel: [    4.367760] drivers/input/serio/i8042.c: d4 -> i8042 (command) [514]
Oct 28 18:31:40 darkstar kernel: [    4.367825] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [514]
Oct 28 18:31:40 darkstar kernel: [    4.372928] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [515]
Oct 28 18:31:40 darkstar kernel: [    4.373011] drivers/input/serio/i8042.c: d4 -> i8042 (command) [515]
Oct 28 18:31:40 darkstar kernel: [    4.373076] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [515]
Oct 28 18:31:40 darkstar kernel: [    4.373475] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [516]
Oct 28 18:31:40 darkstar kernel: [    4.373548] drivers/input/serio/i8042.c: d4 -> i8042 (command) [516]
Oct 28 18:31:40 darkstar kernel: [    4.373612] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [516]
Oct 28 18:31:40 darkstar kernel: [    4.378700] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [517]
Oct 28 18:31:40 darkstar kernel: [    4.378785] drivers/input/serio/i8042.c: d4 -> i8042 (command) [517]
Oct 28 18:31:40 darkstar kernel: [    4.378849] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [517]
Oct 28 18:31:40 darkstar kernel: [    4.381651] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [518]
Oct 28 18:31:40 darkstar kernel: [    4.384750] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [519]
Oct 28 18:31:40 darkstar kernel: [    4.387499] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [520]
Oct 28 18:31:40 darkstar kernel: [    4.387715] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 1, 12) [520]
Oct 28 18:31:40 darkstar kernel: [    4.387800] drivers/input/serio/i8042.c: d4 -> i8042 (command) [520]
Oct 28 18:31:40 darkstar kernel: [    4.387865] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [520]
Oct 28 18:31:40 darkstar kernel: [    4.390680] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [521]
Oct 28 18:31:40 darkstar kernel: [    4.390765] drivers/input/serio/i8042.c: d4 -> i8042 (command) [521]
Oct 28 18:31:40 darkstar kernel: [    4.390830] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [521]
Oct 28 18:31:40 darkstar kernel: [    4.391257] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [521]
Oct 28 18:31:40 darkstar kernel: [    4.391330] drivers/input/serio/i8042.c: d4 -> i8042 (command) [521]
Oct 28 18:31:40 darkstar kernel: [    4.391395] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [521]
Oct 28 18:31:40 darkstar kernel: [    4.396501] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [522]
Oct 28 18:31:40 darkstar kernel: [    4.396588] drivers/input/serio/i8042.c: d4 -> i8042 (command) [522]
Oct 28 18:31:40 darkstar kernel: [    4.396652] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [522]
Oct 28 18:31:40 darkstar kernel: [    4.399454] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [523]
Oct 28 18:31:40 darkstar kernel: [    4.399539] drivers/input/serio/i8042.c: d4 -> i8042 (command) [523]
Oct 28 18:31:40 darkstar kernel: [    4.399603] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [523]
Oct 28 18:31:40 darkstar kernel: [    4.402405] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [524]
Oct 28 18:31:40 darkstar kernel: [    4.402491] drivers/input/serio/i8042.c: d4 -> i8042 (command) [524]
Oct 28 18:31:40 darkstar kernel: [    4.404975] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [524]
Oct 28 18:31:40 darkstar kernel: [    4.407839] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [526]
Oct 28 18:31:40 darkstar kernel: [    4.407899] drivers/input/serio/i8042.c: d4 -> i8042 (command) [526]
Oct 28 18:31:40 darkstar kernel: [    4.407964] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [526]
Oct 28 18:31:40 darkstar kernel: [    4.410812] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [527]
Oct 28 18:31:40 darkstar kernel: [    4.414815] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [528]
Oct 28 18:31:40 darkstar kernel: [    4.414948] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [528]
Oct 28 18:31:40 darkstar kernel: [    4.415202] drivers/input/serio/i8042.c: 64 <- i8042 (interrupt, 1, 12) [528]
Oct 28 18:31:40 darkstar kernel: [    4.415289] drivers/input/serio/i8042.c: d4 -> i8042 (command) [528]
Oct 28 18:31:40 darkstar kernel: [    4.415354] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [528]
Oct 28 18:31:40 darkstar kernel: [    4.415696] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [528]
Oct 28 18:31:40 darkstar kernel: [    4.436998] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [535]
Oct 28 18:31:40 darkstar kernel: [    4.437071] drivers/input/serio/i8042.c: d4 -> i8042 (command) [535]
Oct 28 18:31:40 darkstar kernel: [    4.437136] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [535]
Oct 28 18:31:40 darkstar kernel: [    4.442400] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [536]
Oct 28 18:31:40 darkstar kernel: [    4.442464] drivers/input/serio/i8042.c: d4 -> i8042 (command) [536]
Oct 28 18:31:40 darkstar kernel: [    4.445053] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [536]
Oct 28 18:31:40 darkstar kernel: [    4.448139] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [538]
Oct 28 18:31:40 darkstar kernel: [    4.448198] drivers/input/serio/i8042.c: d4 -> i8042 (command) [538]
Oct 28 18:31:40 darkstar kernel: [    4.448262] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [538]
Oct 28 18:31:40 darkstar kernel: [    4.451545] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [539]
Oct 28 18:31:40 darkstar kernel: [    4.451634] drivers/input/serio/i8042.c: d4 -> i8042 (command) [539]
Oct 28 18:31:40 darkstar kernel: [    4.451699] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [539]
Oct 28 18:31:40 darkstar kernel: [    4.455359] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [540]
Oct 28 18:31:40 darkstar kernel: [    4.455446] drivers/input/serio/i8042.c: d4 -> i8042 (command) [540]
Oct 28 18:31:40 darkstar kernel: [    4.455510] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [540]
Oct 28 18:31:40 darkstar kernel: [    4.458678] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [541]
Oct 28 18:31:40 darkstar kernel: [    4.461604] drivers/input/serio/i8042.c: 73 <- i8042 (interrupt, 1, 12) [542]
Oct 28 18:31:40 darkstar kernel: [    4.461740] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [542]
Oct 28 18:31:40 darkstar kernel: [    4.461990] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 1, 12) [542]
Oct 28 18:31:40 darkstar kernel: [    4.462089] drivers/input/serio/i8042.c: d4 -> i8042 (command) [542]
Oct 28 18:31:40 darkstar kernel: [    4.462154] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [542]
Oct 28 18:31:40 darkstar kernel: [    4.462537] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [542]
Oct 28 18:31:40 darkstar kernel: [    4.462610] drivers/input/serio/i8042.c: d4 -> i8042 (command) [542]
Oct 28 18:31:40 darkstar kernel: [    4.462675] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [542]
Oct 28 18:31:40 darkstar kernel: [    4.468246] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [544]
Oct 28 18:31:40 darkstar kernel: [    4.468331] drivers/input/serio/i8042.c: d4 -> i8042 (command) [544]
Oct 28 18:31:40 darkstar kernel: [    4.470814] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [544]
Oct 28 18:31:40 darkstar kernel: [    4.473921] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [545]
Oct 28 18:31:40 darkstar kernel: [    4.473973] drivers/input/serio/i8042.c: d4 -> i8042 (command) [545]
Oct 28 18:31:40 darkstar kernel: [    4.474038] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [545]
Oct 28 18:31:40 darkstar kernel: [    4.477337] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [547]
Oct 28 18:31:40 darkstar kernel: [    4.477424] drivers/input/serio/i8042.c: d4 -> i8042 (command) [547]
Oct 28 18:31:40 darkstar kernel: [    4.477489] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [547]
Oct 28 18:31:40 darkstar kernel: [    4.480662] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [548]
Oct 28 18:31:40 darkstar kernel: [    4.480750] drivers/input/serio/i8042.c: d4 -> i8042 (command) [548]
Oct 28 18:31:40 darkstar kernel: [    4.480814] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [548]
Oct 28 18:31:40 darkstar kernel: [    4.484016] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [549]
Oct 28 18:31:40 darkstar kernel: [    4.486877] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [550]
Oct 28 18:31:40 darkstar kernel: [    4.489560] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [550]
Oct 28 18:31:40 darkstar kernel: [    4.489788] drivers/input/serio/i8042.c: 64 <- i8042 (interrupt, 1, 12) [550]
Oct 28 18:31:40 darkstar kernel: [    4.489873] drivers/input/serio/i8042.c: d4 -> i8042 (command) [550]
Oct 28 18:31:40 darkstar kernel: [    4.490832] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [550]
Oct 28 18:31:40 darkstar kernel: [    4.491165] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [551]
Oct 28 18:31:40 darkstar kernel: [    4.491214] drivers/input/serio/i8042.c: d4 -> i8042 (command) [551]
Oct 28 18:31:40 darkstar kernel: [    4.491279] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [551]
Oct 28 18:31:40 darkstar kernel: [    4.496387] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [552]
Oct 28 18:31:40 darkstar kernel: [    4.496473] drivers/input/serio/i8042.c: d4 -> i8042 (command) [552]
Oct 28 18:31:40 darkstar kernel: [    4.496537] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [552]
Oct 28 18:31:40 darkstar kernel: [    4.499750] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [553]
Oct 28 18:31:40 darkstar kernel: [    4.499836] drivers/input/serio/i8042.c: d4 -> i8042 (command) [553]
Oct 28 18:31:40 darkstar kernel: [    4.499901] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [553]
Oct 28 18:31:40 darkstar kernel: [    4.503072] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [554]
Oct 28 18:31:40 darkstar kernel: [    4.503158] drivers/input/serio/i8042.c: d4 -> i8042 (command) [554]
Oct 28 18:31:40 darkstar kernel: [    4.503222] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [554]
Oct 28 18:31:40 darkstar kernel: [    4.506403] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [555]
Oct 28 18:31:40 darkstar kernel: [    4.506489] drivers/input/serio/i8042.c: d4 -> i8042 (command) [555]
Oct 28 18:31:40 darkstar kernel: [    4.506553] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [555]
Oct 28 18:31:40 darkstar kernel: [    4.509764] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [556]
Oct 28 18:31:40 darkstar kernel: [    4.512702] drivers/input/serio/i8042.c: 73 <- i8042 (interrupt, 1, 12) [557]
Oct 28 18:31:40 darkstar kernel: [    4.515599] drivers/input/serio/i8042.c: 24 <- i8042 (interrupt, 0, 1) [558]
Oct 28 18:31:40 darkstar kernel: [    4.515814] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [558]
Oct 28 18:31:40 darkstar kernel: [    4.516031] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 1, 12) [558]
Oct 28 18:31:40 darkstar kernel: [    4.516115] drivers/input/serio/i8042.c: d4 -> i8042 (command) [558]
Oct 28 18:31:40 darkstar kernel: [    4.516180] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [558]
Oct 28 18:31:40 darkstar kernel: [    4.519368] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [559]
Oct 28 18:31:40 darkstar kernel: [    4.522257] drivers/input/serio/i8042.c: 10 <- i8042 (interrupt, 1, 12) [560]
Oct 28 18:31:40 darkstar kernel: [    4.522386] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [560]
Oct 28 18:31:40 darkstar kernel: [    4.522638] drivers/input/serio/i8042.c: 64 <- i8042 (interrupt, 1, 12) [560]
Oct 28 18:31:40 darkstar kernel: [    4.522726] drivers/input/serio/i8042.c: d4 -> i8042 (command) [560]
Oct 28 18:31:40 darkstar kernel: [    4.522791] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [560]
Oct 28 18:31:40 darkstar kernel: [    4.525908] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [561]
Oct 28 18:31:40 darkstar kernel: [    4.525991] drivers/input/serio/i8042.c: d4 -> i8042 (command) [561]
Oct 28 18:31:40 darkstar kernel: [    4.526056] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [561]
Oct 28 18:31:40 darkstar kernel: [    4.529201] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [562]
Oct 28 18:31:40 darkstar kernel: [    4.529287] drivers/input/serio/i8042.c: d4 -> i8042 (command) [562]
Oct 28 18:31:40 darkstar kernel: [    4.529352] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [562]
Oct 28 18:31:40 darkstar kernel: [    4.529749] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [562]
Oct 28 18:31:40 darkstar kernel: [    4.529822] drivers/input/serio/i8042.c: d4 -> i8042 (command) [562]
Oct 28 18:31:40 darkstar kernel: [    4.532306] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [562]
Oct 28 18:31:40 darkstar kernel: [    4.537655] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [565]
Oct 28 18:31:40 darkstar kernel: [    4.537718] drivers/input/serio/i8042.c: d4 -> i8042 (command) [565]
Oct 28 18:31:40 darkstar kernel: [    4.537783] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [565]
Oct 28 18:31:40 darkstar kernel: [    4.540895] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [566]
Oct 28 18:31:40 darkstar kernel: [    4.540983] drivers/input/serio/i8042.c: d4 -> i8042 (command) [566]
Oct 28 18:31:40 darkstar kernel: [    4.541048] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [566]
Oct 28 18:31:40 darkstar kernel: [    4.544145] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [567]
Oct 28 18:31:40 darkstar kernel: [    4.544231] drivers/input/serio/i8042.c: d4 -> i8042 (command) [567]
Oct 28 18:31:40 darkstar kernel: [    4.544296] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [567]
Oct 28 18:31:40 darkstar kernel: [    4.547404] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [568]
Oct 28 18:31:40 darkstar kernel: [    4.547490] drivers/input/serio/i8042.c: d4 -> i8042 (command) [568]
Oct 28 18:31:40 darkstar kernel: [    4.547554] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [568]
Oct 28 18:31:40 darkstar kernel: [    4.550734] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [569]
Oct 28 18:31:40 darkstar kernel: [    4.553645] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 1, 12) [570]
Oct 28 18:31:40 darkstar kernel: [    4.556388] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [570]
Oct 28 18:31:40 darkstar kernel: [    4.556606] drivers/input/serio/i8042.c: 0a <- i8042 (interrupt, 1, 12) [570]
Oct 28 18:31:40 darkstar kernel: [    4.556837] drivers/input/serio/i8042.c: d4 -> i8042 (command) [571]
Oct 28 18:31:40 darkstar kernel: [    4.556902] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [571]
Oct 28 18:31:40 darkstar kernel: [    4.560016] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [571]
Oct 28 18:31:40 darkstar kernel: [    4.560106] drivers/input/serio/i8042.c: d4 -> i8042 (command) [572]
Oct 28 18:31:40 darkstar kernel: [    4.560171] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [572]
Oct 28 18:31:40 darkstar kernel: [    4.563287] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [572]
Oct 28 18:31:40 darkstar kernel: [    4.563413] drivers/input/serio/i8042.c: d4 -> i8042 (command) [573]
Oct 28 18:31:40 darkstar kernel: [    4.563478] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [573]
Oct 28 18:31:40 darkstar kernel: [    4.566593] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [573]
Oct 28 18:31:40 darkstar kernel: [    4.566821] drivers/input/serio/i8042.c: d4 -> i8042 (command) [574]
Oct 28 18:31:40 darkstar kernel: [    4.566886] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [574]
Oct 28 18:31:40 darkstar kernel: [    4.570001] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [574]
Oct 28 18:31:40 darkstar kernel: [    4.570090] drivers/input/serio/i8042.c: d4 -> i8042 (command) [575]
Oct 28 18:31:40 darkstar kernel: [    4.570154] drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [575]
Oct 28 18:31:40 darkstar kernel: [    4.573755] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [576]
Oct 28 18:31:40 darkstar kernel: [    4.573839] drivers/input/serio/i8042.c: d4 -> i8042 (command) [576]
Oct 28 18:31:40 darkstar kernel: [    4.576587] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [576]
Oct 28 18:31:40 darkstar kernel: [    4.579675] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [577]
Oct 28 18:31:40 darkstar kernel: [    4.579733] drivers/input/serio/i8042.c: d4 -> i8042 (command) [577]
Oct 28 18:31:40 darkstar kernel: [    4.579902] drivers/input/serio/i8042.c: ea -> i8042 (parameter) [577]
Oct 28 18:31:40 darkstar kernel: [    4.579921] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [577]
Oct 28 18:31:40 darkstar kernel: [    4.582984] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [578]
Oct 28 18:31:40 darkstar kernel: [    4.590306] drivers/input/serio/i8042.c: a1 <- i8042 (interrupt, 0, 1) [579]
Oct 28 18:31:40 darkstar kernel: [    4.606321] drivers/input/serio/i8042.c: a4 <- i8042 (interrupt, 0, 1) [581]
Oct 28 18:31:40 darkstar kernel: [    4.607019] drivers/input/serio/i8042.c: d4 -> i8042 (command) [586]
Oct 28 18:31:40 darkstar kernel: [    4.607079] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [586]
Oct 28 18:31:40 darkstar kernel: [    4.607385] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [586]
Oct 28 18:31:40 darkstar kernel: [    4.607416] drivers/input/serio/i8042.c: d4 -> i8042 (command) [586]
Oct 28 18:31:40 darkstar kernel: [    4.607478] drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [586]
Oct 28 18:31:40 darkstar kernel: [    4.614997] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [588]
Oct 28 18:31:40 darkstar kernel: [    4.615039] drivers/input/serio/i8042.c: d4 -> i8042 (command) [588]
Oct 28 18:31:40 darkstar kernel: [    4.615101] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [588]
Oct 28 18:31:40 darkstar kernel: [    4.615407] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [588]
Oct 28 18:31:40 darkstar kernel: [    4.615437] drivers/input/serio/i8042.c: d4 -> i8042 (command) [588]
Oct 28 18:31:40 darkstar kernel: [    4.615498] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [588]
Oct 28 18:31:40 darkstar kernel: [    4.621834] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [590]
Oct 28 18:31:40 darkstar kernel: [    4.621874] drivers/input/serio/i8042.c: d4 -> i8042 (command) [590]
Oct 28 18:31:40 darkstar kernel: [    4.621935] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [590]
Oct 28 18:31:40 darkstar kernel: [    4.624548] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [591]
Oct 28 18:31:40 darkstar kernel: [    4.636453] drivers/input/serio/i8042.c: d4 -> i8042 (command) [594]
Oct 28 18:31:40 darkstar kernel: [    4.636515] drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [594]
Oct 28 18:31:40 darkstar kernel: [    4.639517] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [595]
Oct 28 18:31:40 darkstar kernel: [    4.639606] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [595]
Oct 28 18:31:40 darkstar kernel: [    4.639944] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [595]
Oct 28 18:31:40 darkstar kernel: [    4.640163] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [595]
Oct 28 18:31:40 darkstar kernel: [    4.640398] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [595]
Oct 28 18:31:40 darkstar kernel: [    4.640450] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [595]
Oct 28 18:31:40 darkstar kernel: [    4.643170] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [596]
Oct 28 18:31:40 darkstar kernel: [    4.643213] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [596]
Oct 28 18:31:40 darkstar kernel: [    4.643624] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [596]
Oct 28 18:31:40 darkstar kernel: [    4.643676] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [596]
Oct 28 18:31:40 darkstar kernel: [    4.643996] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [596]
Oct 28 18:31:40 darkstar kernel: [    4.644038] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [596]
Oct 28 18:31:40 darkstar kernel: [    4.644305] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [597]
Oct 28 18:31:40 darkstar kernel: [    4.644349] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [597]
Oct 28 18:31:40 darkstar kernel: [    4.644706] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [597]
Oct 28 18:31:40 darkstar kernel: [    4.692923] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [611]
Oct 28 18:31:40 darkstar kernel: [    4.696839] drivers/input/serio/i8042.c: 24 <- i8042 (interrupt, 0, 1) [611]
Oct 28 18:31:40 darkstar kernel: [    4.783262] PM: Resume from disk failed.
Oct 28 18:31:40 darkstar kernel: [    4.832311] drivers/input/serio/i8042.c: a4 <- i8042 (interrupt, 0, 1) [646]
Oct 28 18:31:40 darkstar kernel: [    4.873838] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [666]
Oct 28 18:31:40 darkstar kernel: [    4.951973] drivers/input/serio/i8042.c: 21 <- i8042 (interrupt, 0, 1) [689]
Oct 28 18:31:40 darkstar kernel: [    4.962087] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [692]
Oct 28 18:31:40 darkstar kernel: [    5.081834] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [728]
Oct 28 18:31:40 darkstar kernel: [    5.085138] drivers/input/serio/i8042.c: 24 <- i8042 (interrupt, 0, 1) [728]
Oct 28 18:31:40 darkstar kernel: [    5.125679] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [741]
Oct 28 18:31:40 darkstar kernel: [    5.250987] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [779]
Oct 28 18:31:40 darkstar kernel: [    5.288840] drivers/input/serio/i8042.c: a4 <- i8042 (interrupt, 0, 1) [790]
Oct 28 18:31:40 darkstar kernel: [    5.390605] drivers/input/serio/i8042.c: 24 <- i8042 (interrupt, 0, 1) [821]
Oct 28 18:31:40 darkstar kernel: [    5.390732] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [821]
Oct 28 18:31:40 darkstar kernel: [    5.410290] drivers/input/serio/i8042.c: a1 <- i8042 (interrupt, 0, 1) [827]
Oct 28 18:31:40 darkstar kernel: [    5.519831] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [859]
Oct 28 18:31:40 darkstar kernel: [    5.544088] drivers/input/serio/i8042.c: a4 <- i8042 (interrupt, 0, 1) [867]
Oct 28 18:31:40 darkstar kernel: [    5.547392] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [867]
Oct 28 18:31:40 darkstar kernel: [    5.659241] drivers/input/serio/i8042.c: 21 <- i8042 (interrupt, 0, 1) [901]
Oct 28 18:31:40 darkstar kernel: [    5.659398] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [901]
Oct 28 18:31:40 darkstar kernel: [    5.689219] drivers/input/serio/i8042.c: 24 <- i8042 (interrupt, 0, 1) [908]
Oct 28 18:31:40 darkstar kernel: [    5.719043] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [916]
Oct 28 18:31:40 darkstar kernel: [    5.798687] drivers/input/serio/i8042.c: a1 <- i8042 (interrupt, 0, 1) [943]
Oct 28 18:31:40 darkstar kernel: [    5.858420] drivers/input/serio/i8042.c: a4 <- i8042 (interrupt, 0, 1) [961]
Oct 28 18:31:40 darkstar kernel: [    6.047709] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [1018]
Oct 28 18:31:40 darkstar kernel: [    6.051009] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [1027]
Oct 28 18:31:40 darkstar kernel: [    6.051009] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [1027]
Oct 28 18:31:40 darkstar kernel: [    9.123604] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
Oct 28 18:31:40 darkstar kernel: [    9.123629] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
Oct 28 18:31:40 darkstar kernel: [    9.145917] phy0: Selected rate control algorithm 'minstrel'
Oct 28 18:31:40 darkstar kernel: [    9.588484] HDA Intel 0000:00:1b.0: setting latency timer to 64
Oct 28 18:31:40 darkstar kernel: [    9.881730] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc0001679c05c]
Oct 28 18:31:40 darkstar kernel: [   17.290291] REISERFS debug (device sda5): journal-1153: found in header: first_unflushed_offset 530, last_flushed_trans_id 121108
Oct 28 18:31:40 darkstar kernel: [   17.296745] REISERFS debug (device sda5): journal-1206: Starting replay from offset 520159194251794, trans_id 24
Oct 28 18:31:40 darkstar kernel: [   17.296753] REISERFS debug (device sda5): journal-1299: Setting newest_mount_id to 349
Oct 28 18:31:47 darkstar kernel: [   25.233113] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [6773]
Oct 28 18:31:47 darkstar kernel: [   25.358636] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [6811]
Oct 28 18:31:47 darkstar kernel: [   25.563296] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [6872]
Oct 28 18:31:47 darkstar kernel: [   25.687388] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [6910]
Oct 28 18:31:48 darkstar kernel: [   25.841767] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [6956]
Oct 28 18:31:48 darkstar kernel: [   25.956466] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [6990]

> 
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: RSDP 000fbce0 00024 (v02 DELL  )
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: XSDT 3d391e00 00064 (v01 DELL    M09     27D9041D ASL  00000061)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: FACP 3d391c9c 000F4 (v04 DELL    M09     27D9041D ASL  00000061)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: DSDT 3d392400 06857 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: FACS 3d3a0c00 00040
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: HPET 3d391f00 00038 (v01 DELL    M09     00000001 ASL  00000061)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: DMAR 3d3a0400 000F8 (v01 DELL    M09     27D9041D ASL  00000061)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: APIC 3d392000 00068 (v01 DELL    M09     27D9041D ASL  00000047)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: ASF! 3d391c00 00076 (v32 DELL    M09     27D9041D ASL  00000061)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: MCFG 3d391fc0 0003E (v16 DELL    M09     27D9041D ASL  00000061)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: TCPA 3d392300 00032 (v01                 00000000 ASL  00000000)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ACPI: SSDT 3d3902e7 0066C (v01  PmRef    CpuPm 00003000 INTL 20050624)
> Oct 28 18:31:40 darkstar kernel: [    0.000000] Zone PFN ranges:
> Oct 28 18:31:40 darkstar kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
> Oct 28 18:31:40 darkstar kernel: [    0.000000]   Normal   0x00001000 -> 0x000377fe
> Oct 28 18:31:40 darkstar kernel: [    0.000000]   HighMem  0x000377fe -> 0x0003d38d
> Oct 28 18:31:40 darkstar kernel: [    0.000000] Movable zone start PFN for each node
> Oct 28 18:31:40 darkstar kernel: [    0.000000] early_node_map[2] active PFN ranges
> Oct 28 18:31:40 darkstar kernel: [    0.000000]     0: 0x00000000 -> 0x0000009f
> Oct 28 18:31:40 darkstar kernel: [    0.000000]     0: 0x00000100 -> 0x0003d38d
> Oct 28 18:31:40 darkstar kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 248708
> Oct 28 18:31:40 darkstar kernel: [    0.000000] Console: colour dummy device 80x25
> Oct 28 18:31:40 darkstar kernel: [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCK_DEPTH:          48
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ... CLASSHASH_SIZE:          4096
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> Oct 28 18:31:40 darkstar kernel: [    0.000000] ... CHAINHASH_SIZE:          16384
> Oct 28 18:31:40 darkstar kernel: [    0.000000]  memory used by lock dependency info: 3567 kB
> Oct 28 18:31:40 darkstar kernel: [    0.000000]  per task-struct memory footprint: 1152 bytes
> Oct 28 18:31:40 darkstar kernel: [    0.000000] Fast TSC calibration using PIT
> Oct 28 18:31:40 darkstar kernel: [    0.000000] Detected 1995.305 MHz processor.
> Oct 28 18:31:40 darkstar kernel: [    0.003477] Mount-cache hash table entries: 512
> Oct 28 18:31:40 darkstar kernel: [    0.073332] lockdep: fixing up alternatives.
> Oct 28 18:31:40 darkstar kernel: [    0.167889] khelper used greatest stack depth: 6736 bytes left
> Oct 28 18:31:40 darkstar kernel: [    0.167906] Time: 18:31:22  Date: 10/28/09
> Oct 28 18:31:40 darkstar kernel: [    0.183926] bio: create slab <bio-0> at 0
> Oct 28 18:31:40 darkstar kernel: [    0.233917] ACPI: SSDT 3d3a0c80 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
> Oct 28 18:31:40 darkstar kernel: [    0.699300] highmem bounce pool size: 64 pages
> Oct 28 18:31:40 darkstar kernel: [    0.707157] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Oct 28 18:31:40 darkstar kernel: [    0.713658] ALI M7101 PMU not found.
> Oct 28 18:31:40 darkstar kernel: [    0.727193] Console: switching to colour frame buffer device 128x48
> Oct 28 18:31:40 darkstar kernel: [    0.745940] ACPI: SSDT 3d390953 002C3 (v01  PmRef   BspIst 00003000 INTL 20050624)
> Oct 28 18:31:40 darkstar kernel: [    0.747451] ACPI: SSDT 3d390ded 005C6 (v01  PmRef   BspCst 00003001 INTL 20050624)
> Oct 28 18:31:40 darkstar kernel: [    0.750953] ACPI: SSDT 3d390c16 001D7 (v01  PmRef    ApIst 00003000 INTL 20050624)
> Oct 28 18:31:40 darkstar kernel: [    0.752370] ACPI: SSDT 3d3913b3 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
> Oct 28 18:31:40 darkstar kernel: [    0.808726] i8k: unable to get SMM BIOS version
> Oct 28 18:31:40 darkstar kernel: [    0.831297] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> Oct 28 18:31:40 darkstar kernel: [    0.836900] Hangcheck: Using get_cycles().
> Oct 28 18:31:40 darkstar kernel: [    0.858621] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> Oct 28 18:31:40 darkstar kernel: [    0.888873] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String at index 9 (20090903/nsrepair-132)
> Oct 28 18:31:40 darkstar kernel: [    0.894759] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String at index 10 (20090903/nsrepair-132)
> Oct 28 18:31:40 darkstar kernel: [    0.900646] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String at index 11 (20090903/nsrepair-132)
> Oct 28 18:31:40 darkstar kernel: [    0.906408] ACPI Warning for \_SB_.BAT0._BIF: Converted Buffer to expected String at index 12 (20090903/nsrepair-132)
> Oct 28 18:31:40 darkstar kernel: [    1.006024] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-B
> Oct 28 18:31:40 darkstar kernel: [    1.022192] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-C
> Oct 28 18:31:40 darkstar kernel: [    1.033201] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-D
> Oct 28 18:31:40 darkstar kernel: [    1.652138] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
> Oct 28 18:31:40 darkstar kernel: [    1.657946] Console: switching to colour dummy device 80x25
> Oct 28 18:31:40 darkstar kernel: [    1.940032] async/0 used greatest stack depth: 6204 bytes left
> Oct 28 18:31:40 darkstar kernel: [    2.033774] Console: switching to colour frame buffer device 160x50
> Oct 28 18:31:40 darkstar kernel: [    2.114389] ACPI Warning for \_SB_.PCI0.VID2._DOD: Return Package has no elements (empty) (20090903/nspredef-433)
> Oct 28 18:31:40 darkstar kernel: [    2.657074] i8042.c: Warning: Keylock active.
> Oct 28 18:31:40 darkstar kernel: [    2.666119] Driver 'rtc_cmos' needs updating - please use bus_type methods
> Oct 28 18:31:40 darkstar kernel: [    3.796606] Netfilter messages via NETLINK v0.30.
> Oct 28 18:31:40 darkstar kernel: [    3.796700] nf_conntrack version 0.5.0 (15347 buckets, 61388 max)
> Oct 28 18:31:40 darkstar kernel: [    3.797524] ctnetlink v0.93: registering with nfnetlink.
> Oct 28 18:31:40 darkstar kernel: [    4.196617]  sda1 sda2 sda3 sda4 <
> Oct 28 18:31:40 darkstar kernel: [    4.234941] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> Oct 28 18:31:40 darkstar kernel: [    4.415478]  sda5
> Oct 28 18:31:40 darkstar kernel: [    4.662008]  sda6 sda7
> Oct 28 18:31:40 darkstar kernel: [    4.696955]  sda8 >
> Oct 28 18:31:40 darkstar kernel: [    4.696839] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    4.696839] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    4.783405] registered taskstats version 1
> Oct 28 18:31:40 darkstar kernel: [    4.811084]   Magic number: 13:516:545
> Oct 28 18:31:40 darkstar kernel: [    4.832325] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    4.832327] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.081883] atkbd.c: Unknown key pressed (raw set 2, code 0x126 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.085138] atkbd.c: Use 'setkeycodes 26 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.125712] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.128995] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.266914] async/1 used greatest stack depth: 5944 bytes left
> Oct 28 18:31:40 darkstar kernel: [    5.288891] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.292146] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.390758] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.410290] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.410290] atkbd.c: Unknown key pressed (raw set 2, code 0x121 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.410290] atkbd.c: Use 'setkeycodes 21 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.544134] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.545078] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
> Oct 28 18:31:40 darkstar kernel: [    5.547392] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.659418] atkbd.c: Unknown key pressed (raw set 2, code 0x126 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.680843] atkbd.c: Use 'setkeycodes 26 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.719052] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.719055] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.798708] atkbd.c: Unknown key pressed (raw set 2, code 0x121 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.802006] atkbd.c: Use 'setkeycodes 21 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    5.858461] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    5.861732] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    6.047765] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Unknown key pressed (raw set 2, code 0x11e on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Use 'setkeycodes 1e <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Unknown key pressed (raw set 2, code 0x11f on isa0060/serio0).
> Oct 28 18:31:40 darkstar kernel: [    6.051009] atkbd.c: Use 'setkeycodes 1f <keycode>' to make it known.
> Oct 28 18:31:40 darkstar kernel: [    8.220557] cdrom_id used greatest stack depth: 5856 bytes left
> Oct 28 18:31:40 darkstar kernel: [   17.219715] REISERFS warning (device sda5):  reiserfs_fill_super: CONFIG_REISERFS_CHECK is set ON
> Oct 28 18:31:40 darkstar kernel: [   17.230511] REISERFS warning (device sda5):  reiserfs_fill_super: - it is slow mode for debugging.
> Oct 28 18:31:40 darkstar kernel: [   17.374339] mount used greatest stack depth: 5796 bytes left
> Oct 28 18:31:46 darkstar kernel: [   24.237922] update-mime-dat used greatest stack depth: 5772 bytes left
> Oct 28 18:31:47 darkstar kernel: [   25.233169] atkbd.c: Unknown key pressed (raw set 2, code 0x20 on isa0060/serio0).
> Oct 28 18:31:47 darkstar kernel: [   25.233176] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
> Oct 28 18:31:47 darkstar kernel: [   25.358673] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
> Oct 28 18:31:47 darkstar kernel: [   25.358681] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
> Oct 28 18:31:47 darkstar kernel: [   25.563353] atkbd.c: Unknown key pressed (raw set 2, code 0x20 on isa0060/serio0).
> Oct 28 18:31:47 darkstar kernel: [   25.563360] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
> Oct 28 18:31:47 darkstar kernel: [   25.687429] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
> Oct 28 18:31:47 darkstar kernel: [   25.687437] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
> Oct 28 18:31:48 darkstar kernel: [   25.841800] atkbd.c: Unknown key pressed (raw set 2, code 0x20 on isa0060/serio0).
> Oct 28 18:31:48 darkstar kernel: [   25.841808] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
> Oct 28 18:31:48 darkstar kernel: [   25.956515] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
> Oct 28 18:31:48 darkstar kernel: [   25.956522] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
> 
> > 
> > > I would be a little hesitant to force translation by default on all
> > > architectures, although it may make sense on x86...
> > 
> > The old 2.4 kernel sources say that there are some IBM PowerPC portables
> > that don't support translation at all. I wouldn't be surprised if there
> > were more examples like that in the embedded space.
> > 
> > I'm not aware of any x86 machine that wouldn't support the translated
> > mode.
> > 
> > > Vojtech, you wrote the thing, do you see any issues with forcing
> > > translation? I think most of the x86 boxes work in translated mode and
> > > the only time it is in raw is when BIOS screwed up initialization.
> > > 
> > > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > > > ---
> > > >  drivers/input/serio/i8042.c |    8 --------
> > > >  1 file changed, 8 deletions(-)
> > > > 
> > > > --- linux-2.6.orig/drivers/input/serio/i8042.c	2009-10-13 08:57:07.000000000 +0800
> > > > +++ linux-2.6/drivers/input/serio/i8042.c	2009-10-27 13:15:13.000000000 +0800
> > > > @@ -869,14 +869,6 @@ static int i8042_controller_init(void)
> > > >  	spin_unlock_irqrestore(&i8042_lock, flags);
> > > >  
> > > >  /*
> > > > - * If the chip is configured into nontranslated mode by the BIOS, don't
> > > > - * bother enabling translating and be happy.
> > > > - */
> > > > -
> > > > -	if (~i8042_ctr & I8042_CTR_XLATE)
> > > > -		i8042_direct = true;
> > > > -
> > > > -/*
> > > >   * Set nontranslated mode for the kbd interface if requested by an option.
> > > >   * After this the kbd interface becomes a simple serial in/out, like the aux
> > > >   * interface is. We don't do this by default, since it can confuse notebook
> > 
> > -- 
> > Vojtech Pavlik
> > Director SuSE Labs
