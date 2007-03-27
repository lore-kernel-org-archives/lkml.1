Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbXC0BO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbXC0BO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933909AbXC0BO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:14:59 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:6625 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933903AbXC0BO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:14:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGoNCEZKhRO4dGdsb2JhbACPbAE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Fix sudden warps in mousedev
Date: Mon, 26 Mar 2007 21:14:44 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       Peter Osterlund <petero2@telia.com>
References: <20070324001610.724a820a.zaitcev@redhat.com> <d120d5000703261230h1724e453je2c14769fc099ad3@mail.gmail.com> <20070326144206.93805eeb.zaitcev@redhat.com>
In-Reply-To: <20070326144206.93805eeb.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703262114.45287.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 17:42, Pete Zaitcev wrote:
> On Mon, 26 Mar 2007 15:30:42 -0400, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
> 
> > Regarding the synaptics driver and scroll problem. Yesterday I
> > scrolled twice through entire Remarque's "Spark of Life" off lib.ru
> > (once with 0.14.2 and once with latest git pull) and did not see any
> > scrollbar getting "stuck". Could it be newer xorg problem instead of
> > individual driver problem? I am using whatever xorg was installed in
> > FC3 which is somewhat dated... Also, could it be that the scroll issue
> > happens only in a certain application?
> 
> It's not a "scroll" issue. The issue is that the "up" event is getting
> lost. It can be observed with any GUI elements, such as buttons.
> However, since the event is delivered upon any motion, there's no
> harm done with a button. Needless to say, this is not application
> specific. It may be GNOME specific though.

Could be as I am KDE user.

> 
> FC-3 is far too old to be a good reference. I don't even know if it
> has a usable synaptics module in its pre-modular X. You may be looking
> at very different software stack.
>

See above. _My_ box certainly has usable synaptics module.
 
> I don't think that you need to concern yourself with this too much
> at present. If X11 people (e.g. Kristian) present evidence that kernel
> fails to deliver an event, then we'll look at it. However it might
> help if evtest continued to work when X11 reads from /dev/input/eventN.
> It was an unpleasant surprise that it doesn't.
> 

The driver grabs tochpad with EVIOCGRAB ioctl to prevent input events
from bveing delivered to X through /dev/input/mice which is still in
whidespread use. That's why evtest does not work. We could as Peter
(CCed) to implement an option to turn off grabbing so users who don't
use mousedev multiplexor can use evtest and other commands.

-- 
Dmitry
