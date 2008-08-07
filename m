Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYHGNg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYHGNg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYHGNgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:36:47 -0400
Received: from web53212.mail.re2.yahoo.com ([206.190.49.82]:47311 "HELO
	web53212.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751525AbYHGNgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:36:45 -0400
X-Greylist: delayed 4481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 09:36:45 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=uRb07dcCWcfM/IPdj58QHCOs8szMLcC6y1dUi1TElsxPFv8uSbg1e8cbgjkacXgYnGwu01Vw3w0OAvUfXCdmqGIqPBgubjn5A6LAOZxdcrLl4CTLsFtfrzOfWHR3K6CBrwmosNwLDWzAv9BYAK8FkIPWL7wSUESTOVPK4y5CeGY=;
X-Mailer: YahooMailWebService/0.7.218
Date: Thu, 7 Aug 2008 02:28:39 -0700 (PDT)
From: Emanoil Kotsev <deloptes@yahoo.com>
Reply-To: deloptes@yahoo.com
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
To: Alan Stern <stern@rowland.harvard.edu>, Simon Arlott <simon@fire.lp0.eu>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <489A1C68.3000905@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <467461.53792.qm@web53212.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using usb drive to boot from. I also use USB mouse and USB keyboard.

Indeed I have to put a delay in the init script in the initrd to delay and   give time for the initialization. I found out by testing that this delay should be >5sec.

I have tried compiling all the usb modules into the kernel, but this doesn't help much, now after following this discussion it might be related.

With 2.6.20 I can use the keyboard. With the same init script in 2.6.24 and 2.6.26 it is not working, but I really coudn't find time to investigate, because as Alan sais there is really not too much to do with keyboard and mouse during the bootprocess unless as I do I unlock crypted partitions.

Don't know if this information is somehow useful for you, but hope so.

I could also look at why the keyboard is not working in boot. Let me know

regards


--- On Wed, 8/6/08, Simon Arlott <simon@fire.lp0.eu> wrote:

> From: Simon Arlott <simon@fire.lp0.eu>
> Subject: Re: [PATCH RFC] USB: Add HCD fastboot
> To: "Alan Stern" <stern@rowland.harvard.edu>
> Cc: "Rene Herman" <rene.herman@keyaccess.nl>, "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org, mingo@elte.hu, "Daniel Walker" <dwalker@mvista.com>, "USB list" <linux-usb@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
> Date: Wednesday, August 6, 2008, 11:49 PM
> On 06/08/08 21:26, Alan Stern wrote:
> > On Wed, 6 Aug 2008, Simon Arlott wrote:
> > 
> >> No, by adding a 5 second delay you're
> intending for the device driver initcalls 
> >> to complete within that 5 seconds. If they take
> too long then the last one 
> >> blocks everything (I realise that's
> ridiculous, these initcalls take <1ms when 
> >> there are no devices yet). The best way to do is
> to make the driver initcalls 
> >> before the host ones, like you suggested.
> > 
> > Doing the HCD initcalls last certainly ought to work.
> 
> Right - so then all that's needed is to move usb/
> before most other things that 
> take a while to init, and it has some time to initialise
> usb devices in the 
> background.
> 
> >> > "it'll still have to wait..." 
> If by "it" you mean the initcall
> >> > thread, you're wrong.  If by
> "it" you mean the user, you still aren't
> >> > necessarily correct; the user can do plenty
> of other things while
> >> > waiting for USB devices to initialize.
> >> 
> >> Assuming userspace doesn't wait for all
> devices to settle and appear in /dev etc. 
> >> before continuing.
> > 
> > Whatever that involves...  /dev never truly settles;
> it's always 
> > possible to plug in a new device or remove an old one.
> 
> Yes... I'm not sure how that part would work.
> 
> >> > I suppose you could make the hub_thread delay
> time a module parameter 
> >> > for usbcore, defaulting to 0.  Then it could
> be set by just the people 
> >> > who want to use it -- many (most?) people
> keep their drivers in 
> >> > modules, and it wouldn't do them any
> good.
> >> 
> >> It really needs to have hcd initcalls done very
> early so that device init 
> > 
> > Please stop using the word "it" with no
> antecedent!  Do you mean "we"?
> 
> Yes. I'll try to avoid doing that.
> 
> >> has the rest of the (kernel and userspace) boot
> process to complete in the 
> >> background. This is negated by having device
> drivers initialised immediately 
> >> afterwards. Re-ordering initcalls and doing more
> of the init process 
> >> asynchronously is likely to expose bugs and cause
> inconsistent device order 
> >> on some systems, so if the makefile mess could be
> reduced then it can be a 
> >> Kconfig option.
> > 
> > So what exactly do you recommend?
> 
> I'm not an expert on what can be done with the Makefile
> process, perhaps there's 
> an easier way to move things around based on a config
> option. If host init is 
> moved before device init for everyone, wouldn't there
> be too many side effects?
> 
> I've not tried to use usb-storage as root but
> presumably that works. If that 
> already uses a hack of making the kernel wait X seconds
> before trying to mount 
> root then it'll still work.
> 
> >> How many people have *all* their USB components
> (hcd, drivers) as modules?
> > 
> > All the major distributions do, as far as I know.  (I
> haven't actually 
> > checked them all to be certain.)
> > 
> >> What do they do with their USB keyboards in the
> period between init and module 
> >> load?
> > 
> > Probably nothing.  What do you do on your keyboard
> while waiting for
> > system initialization to complete?
> 
> Lack of a keyboard makes it impossible to do anything if
> the module fails to 
> load... as I understand it when the HCD init runs, any BIOS
> emulation stops?
> Although if HCD is a module too...
> 
> >> If even one device driver and the hcd is compiled
> in, they'd need to 
> >> wait for every USB device to finish init before
> the usbhid probe could complete.
> > 
> > What if usbhid is the one device driver that is
> compiled in?  :-)
> 
> That was the situation I was thinking of - surely that
> would be compiled in 
> if the HCDs were?
> 
> -- 
> Simon Arlott
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html


      
