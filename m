Return-Path: <linux-kernel-owner+w=401wt.eu-S968372AbXEHQFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968372AbXEHQFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968210AbXEHQFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:05:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:20290 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968081AbXEHQFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ruJxXmxuLP1QPGFiOGWooSQMsRNllbH5B+gK3vj+/ATWPU3o31sAI5MDyB25E4hkGL9OpOVDjwT9OLAk0M0kmdgU7vt9ZMuXxya0+MhkUHOSxNb1RLZWLvt8lGs5qwYeshlsPq+5fWSY0M40HEoKgjlvB69ADUngIwPQtFKVi9o=
Message-ID: <a781481a0705080905l609dc925s93357e6eb0d4c318@mail.gmail.com>
Date: Tue, 8 May 2007 09:05:39 -0700
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: Getting make net/built-in.o Error with 2.6.21.1 Build
Cc: chris@pcburn.com, linux-kernel@vger.kernel.org,
       "Marcel Holtmann" <marcel@holtmann.org>,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705081740550.16923@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463FB6B0.3070005@pcburn.com>
	 <a781481a0705071725i1d802dfejbcdaca4ab0a1ff55@mail.gmail.com>
	 <Pine.LNX.4.64.0705081740550.16923@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 5/8/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Tue, 8 May 2007, Satyam Sharma wrote:
>
> > >   CC      init/version.o
> > >   LD      init/built-in.o
> > >   LD      .tmp_vmlinux1
> > > net/built-in.o: In function `hidp_add_connection':
> > > (.text+0x8bb08): undefined reference to `hid_ff_init'
> > > make: *** [.tmp_vmlinux1] Error 1
> > You've got CONFIG_BT_HIDP=y there but CONFIG_USB_HID=m. The trivial
> > patch below solves it. To test, you can just "make oldconfig" on the
> > same .config that broke above and then proceed to make bzImage.
>
> I'd say we need a different fix here. First, the question is whether there
> are any force-feedback devices, supported by USBHID force-feedback layer,
> which have a bluetooth version?
>
> If there are none of them, we could just drop the FF initialization
> completely for now.
>
> On the other hand if there are such devices, just calling hid_ff_init() is
> presently not enough anyway, as the force feedback drivers for HID devices
> are currently USB-transport specific.

Sure, my aim here was to only solve the _build breakage_ by fixing the
Kconfig for this module (that used code from another kernel module
without listing it in its dependencies). If, as you say, the real
solution is that we should actually be taking out the offending call
to the other module itself, then please go ahead -- I don't know much
about the Bluetooth / HIDP subsytem anyway.

Thanks,
Satyam
