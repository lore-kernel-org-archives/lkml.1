Return-Path: <linux-kernel-owner+w=401wt.eu-S1759159AbYEGFo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbYEGFo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYEGFoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:44:19 -0400
Received: from outbound-mail-142.bluehost.com ([67.222.38.32]:45117 "HELO
	outbound-mail-142.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751765AbYEGFoR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:44:17 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net
Subject: Re: 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
Date: Tue, 6 May 2008 22:44:09 -0700
User-Agent: KMail/1.9.9
Cc: "Miles Lane" <miles.lane@gmail.com>,
       "Michel =?iso-8859-1?q?D=E4nzer?=" <michel@tungstengraphics.com>,
       David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>
References: <481E5EE6.6090503@gmail.com> <1209975302.26326.263.camel@thor.sulgenrain.local> <a44ae5cd0805051122p720481e2sc84c13fcaca0725d@mail.gmail.com>
In-Reply-To: <a44ae5cd0805051122p720481e2sc84c13fcaca0725d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805062244.10152.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2008 11:22 am Miles Lane wrote:
> On Mon, May 5, 2008 at 4:15 AM, Michel Dänzer
>
> <michel@tungstengraphics.com> wrote:
> > On Sun, 2008-05-04 at 21:12 -0400, Miles Lane wrote:
> >  > When I boot this kernel, everything seems okay, but after I leave the
> >  > machine for 30 minutes or so, I come back and find the machine locked
> >  > up.
> >
> >  Define 'locked up'. Can you ping it? Can you log in via ssh? Is the X
> >  server still alive? Where is it stuck? ...
>
> I don't know if I can ping the machine.  I can work on finding that
> out.  I don't have an ssh server running, but can try that.  I can't
> tell if X is running.  The screen remains black.
>
> >  > When I checked my log file after rebooting, I find the log filled with
> >  > "trying to get vblank count for disabled pipe 0".
> >
> >  [...]
> >
> >  > May  4 14:40:44 whirligig kernel: [   47.544109] ALSA
> >  > sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x12,
> >  > stream=0x5, channel=0, format=0x4011 May  4 14:40:46 whirligig kernel:
> >  > [   48.850489] trying to get vblank count for disabled pipe 0 May  4
> >  > 14:40:46 whirligig kernel: [   48.897990] trying to get vblank count
> >  > for disabled pipe 0 May  4 14:40:46 whirligig kernel: [   48.941691]
> >  > trying to get vblank count for disabled pipe 0 May  4 14:40:46
> >  > whirligig kernel: [   49.003556] trying to get vblank count for
> >  > disabled pipe 0 May  4 14:40:46 whirligig kernel: [   49.147880]
> >  > trying to get vblank count for disabled pipe 0 May  4 14:40:47
> >  > whirligig kernel: [   50.528654] trying to get vblank count for
> >  > disabled pipe 0 [...]
> >  > May  4 15:36:23 whirligig kernel: [ 3404.847515] ALSA
> >  > sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0xe May 
> >  > 4 16:06:53 whirligig kernel: [ 5241.488711] trying to get vblank count
> >  > for disabled pipe 1 May  4 16:06:53 whirligig kernel: [ 5241.488748]
> >  > trying to get vblank count for disabled pipe 1 May  4 16:06:53
> >  > whirligig kernel: [ 5241.496130] trying to get vblank count for
> >  > disabled pipe 1 May  4 16:06:53 whirligig kernel: [ 5241.516053]
> >  > trying to get vblank count for disabled pipe 1
> >
> >  Note that some of these are for pipe 1 as well as pipe 0. Does the
> >  problem only occur for one of them?
>
> I just checked my dmesg output and found this:
>
> [ 7196.890661] trying to get vblank count for disabled pipe 0
> [ 7258.233274] trying to get vblank count for disabled pipe 1
> [ 7258.233963] trying to get vblank count for disabled pipe 1
> [ 7261.219671] trying to get vblank count for disabled pipe 0
> [ 7261.234483] trying to get vblank count for disabled pipe 0
>
> So, since I am still using this boot session and haven't noticed
> anything lock up, it seems that getting either of these messages is
> not necessarily the indicator of what is keeping my screen black after
> the display has gone to sleep.  I have not let the display go to sleep
> yet during this boot session, so I don't know what will happen when it
> does.  I suspicion is that this is the trigger condition.

I put these messages in there to warn us when Mesa asks for an invalid vblank 
count.  It would be good to figure out why the DRM driver is getting called 
to retrieve the vblank count for a pipe that *should* be disabled...

Jesse

