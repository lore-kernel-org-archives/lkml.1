Return-Path: <linux-kernel-owner+w=401wt.eu-S933426AbXC0X3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbXC0X3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 19:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbXC0X3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 19:29:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:37727 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426AbXC0X3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 19:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ozDGUKrP+UB5vp9SNQGeQNFCLaX1we5/H4j4Ftttn8oIABY2beFPon7sfEA3wdn3p3atRBiXHv4g4RI/isTWT4YECKt0774sXqDy5m5DRq2leN5uE7yJ9ja/mIl68h3OXtiItbvXJMLYnGOKU8yE+kBJJU2sYlOoTUGOuynmu0c=
From: Maxim <maximlevitsky@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Date: Wed, 28 Mar 2007 01:29:10 +0200
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       davidz@redhat.com
References: <200703271824.46804.maximlevitsky@gmail.com> <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org> <20070327110524.975e7113.zaitcev@redhat.com>
In-Reply-To: <20070327110524.975e7113.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703280129.10197.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 20:05:24 Pete Zaitcev wrote:
> On Tue, 27 Mar 2007 13:15:14 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > Suspend to disk still causes "virtual replugging"  and I think that controller is reset and will unplug/replug devices anyway
> > > Resolving this problem is very difficult. Maybe it possible to check on unplugging event that this caused by suspend  if the same device is
> > > replugged then don't remove/reinstall driver, but this is very difficult to implement properly,
> > > Maybe just refuse to suspend if some valuable device is connected (sorry if it is done this way already)
> > 
> > Long ago I posted a patch that would take care of all this.  Not just for
> > UHCI, but for any USB controller.  Maybe I should dig it out, update it,
> > and submit it.
> 
> Alan, BTW, look at this please:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233697
> 
> > From David Zeuthen
> 
> > If I suspend my box, then on the resume path I see all my USB devices being
> > removed and then added back. This is a problem with storage devices connected
> > via USB.
> .....
> > The kernel not send an "remove" event if it's going to send an "add" right
> > after. Instead it should enumerate the bus on resume and only send the events
> > that represents how to get from the previous device tree to the current one.
> 
> > From Pete Zaitcev
> 
> > What does happen if a user suspends, unplugs a USB key, modifies its contents,
> > plugs it back, and resumes? In such a case, there would be no change between
> > the state of USB bus between the before-suspend state and after-resume state.
> 
> > From David Zeuthen
> 
> > In that case the user would see data corruption - just as if he mounts a piece
> > of removable media in a USB card reader; yanks out the card and modifies it
> > elsewhere, and then puts it back in.
> 
> > I my opinion we can't really defend ourselves against such users... We can of
> > course add checks in the file system drivers in the resume hooks to validate the
> > super block and mount read-only if something change. 
> 
> The GNOME hath spoken?
> 
> -- Pete
> 

Hi, 
	I also thought about that,
	
	I think that the best solution is still to hide connect/disconnect of usb devices from userspace (now it also causes corruption)
	But to refuse suspend with any usb mass storage device connected with mounted systems (and add a module param override
	 for users who know what they are doing)

	What do you think ?

	Regards,
		Maxim Levitsky
