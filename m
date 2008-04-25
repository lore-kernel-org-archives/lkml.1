Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbYDYS03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbYDYS03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757831AbYDYS0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:26:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3928 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761AbYDYS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YlBt+a93ujbbDfFi3ahWsOGjGGWyE+DVtIajNG3aVaX69Niqm/D1DlcT70IAn14rhtYsA06dWLqnU4nb9XSXpjRukbTJ3vnY5bEqNUOuUAh/QcdHcHkPX69sxSTXAhojkq2/ZoHixlwN3ULJIjyVJD3UAB6JAPjlQnqtpAeGiZA=
Date: Fri, 25 Apr 2008 14:26:13 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yan Seiner <yan@seiner.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: uinput question
Message-ID: <20080425142224.ZZRA012@mailhub.coreip.homeip.net>
References: <480BD294.9040504@seiner.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480BD294.9040504@seiner.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yan,

On Sun, Apr 20, 2008 at 04:32:36PM -0700, Yan Seiner wrote:
> I'm trying to set up a system with multiple IR remotes acting as keyboards 
> for specific X sessions.
>
> lirc <http://www.lirc.org> is a way to send infrared remote keystrokes to 
> applications.  Some time ago I wrote a small patch to kbdd 
> <http://handhelds.org/moin/moin.cgi/kbdd> that lets me inject button pushes 
> on an IR remote into the /dev/input/uinput system as keyboard events.
>
> Now I'd like to send those keyboard events to only one X session, not all 
> of them.
>
> In the kbdd code, there is the following snippet when the /dev/input/uinput 
> device is opened:
>
>        memset(&dev, 0, sizeof(dev));
>        strncpy(dev.name, "SerKBD", UINPUT_MAX_NAME_SIZE);
>        dev.idbus = BUS_RS232;
>        dev.idvendor = 0x00;
>        dev.idproduct = 0x00;
>        dev.idversion = 0x00;
>
> So this would indicate to me that I can emulate different devices by 
> changing the names, IDs, and events.  Then I want to select only those 
> events that pertain to my app... 
> So...
> -   Create a 'virtual' eventNN device based on the data fed to kbdd
> -   Send various keyboard events to the kernel via the uinput device from 
> several physical devices
> -   Select only those events destined for my virtual device
> -   Have those events pop out of my eventNN device so I can handle them 
> back in userspace
>

You would need to set up uinput instance for every set of remotes you
want to send events to a particular X instance and then make X use
evdev driver to listen to the input events coming from 'their'
/dev/input/eventXX. You may need to teach X not to release event
device when switching vts so events from the uinput-connected devices
never reach the standard consolde driver.

Hope this helps.

-- 
Dmitry
