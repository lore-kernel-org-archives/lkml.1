Return-Path: <linux-kernel-owner+w=401wt.eu-S935235AbZJOSde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935235AbZJOSde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935220AbZJOSde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:33:34 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:44520 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935219AbZJOSdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mgOlPXls2tV9HNce/2xTAM6y1FO7YOQ+umgGYOqDm6r2UfRr0px9VJ27UFdjXB/cUV
         XLACMzshKlhu736Iz28V1l72wi7dH9CY6nvLtXytLFf3R0yP+TtfsEdUrd8XXKaQAYld
         odGZwVppyYx5IzGBSEwpzEIrXXOdJWXF8KNXw=
Date: Thu, 15 Oct 2009 11:27:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
	anymore
Message-ID: <20091015182706.GC8544@core.coreip.homeip.net>
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <4AD75AC0.6020705@tremplin-utc.net> <20091015181336.GB8544@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091015181336.GB8544@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 11:13:37AM -0700, Dmitry Torokhov wrote:
> On Thu, Oct 15, 2009 at 07:24:16PM +0200, Éric Piel wrote:
> > Op 14-10-09 04:05, Dmitry Torokhov schreef:
> > > On Tue, Oct 13, 2009 at 11:52:19AM +0200, Éric Piel wrote:
> > >>> Could you please try and let me know if unloading at suspend and
> > >>> reloading after resume atkbd and/or psmouse drivers and leaving i8042
> > >>> alone "fixes" the issue?
> > >>>
> > >> Unloading the modules before suspend and reloading them after works
> > >> around the issue, indeed.
> > >>
> > > 
> > > Do both of them need to be reloaded? Or only one (my guess psmouse) is
> > > enough. Hmm, this is HP laptop so it most likely has Synaptics touchpad.
> > > I wonder what happens if you force it to bare PS/2 protocol (or maybe
> > > Intellimouse)... Try adding "option psmouse proto=imps" and
> > > "option psmouse proto=bare" and suspend/resume.
> > Sorry for taking some time to answer back. The keyboard fails to come
> > back only on the first suspend-resume (the next suspends, the keyboard
> > comes back fine). So I need to reboot the computer for every single test.
> > 
> > So far, what I can tell is that once the keyboard is not working
> > anymore, just unloading and reloading atkbd fixes the problem. Attached
> > is a dmesg log from just before supsending to after resume. The keyboard
> > doesn't work anymore but the touchpad do. The lines at the very end of
> > the log correspond to keypresses: although the keyboard doesn't work,
> > there are still 3 interrupt per keypress generated:
> > 
> > drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [320670]
> > drivers/input/serio/i8042.c: f0 <- i8042 (interrupt, 0, 1) [320751]
> > drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [320753]
> > 
> > That's all the date for now. I'll test your questions about psmouse
> > later on, and report back.
> > 
> 
> It lokks like the keyboard controller switched from translated to
> non-translated mode: '1c' is make code and 'f0 1c' is break (aka
> release) code.
> 
> Could you tell me how the keyboard indentified (in dmesg) after fresh
> boot and after you do the bind/unbind trick on the older kernel?
> 

BTW, do you have i8042.reset parameyer on your command line? What
happens if you remove it?

-- 
Dmitry
