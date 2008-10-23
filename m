Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYJWUaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYJWUaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYJWUaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:30:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:53628 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYJWUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:30:30 -0400
Message-ID: <ac3eb2510810231330g791f4f35uf43efddaa3aeed@mail.gmail.com>
Date: Thu, 23 Oct 2008 22:30:27 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Gu, Mingkun" <Mingkun.Gu@gtech.com>
Subject: Re: Help: undesired 10 seconds delay in creating USB devices
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <32C88E5279F5DD46B7237443CD61E67901E455BC@cspmail02.gtk.gtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac3eb2510810231249uf633483p6ea0f543ffdcf900@mail.gmail.com>
	 <32C88E5279F5DD46B7237443CD61E67901E455BC@cspmail02.gtk.gtech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 22:04, Gu, Mingkun <Mingkun.Gu@gtech.com> wrote:
>> >> > On Thu, Oct 23, 2008 at 01:11:00PM -0300, Gu, Mingkun wrote:

>> >> > > [MKGU>] My device driver name is "usbled". Our USB device has
>> >> > > VendorID=11b4. After I unplugged the USB cable connecting to
> this
>> >> device
>> >> > > and kept the device driver "usbled" remaining loaded, I plugged
> in
>> >> the
>> >> > > USB cable back to the system again. I could see the device
>> >> information
>> >> > > retrieved from /proc/bus/usb/devices immediately but the device
>> name
>> >> > > /dev/usbled0 was seen after near 10 seconds.
>> >> >
>> >> > That sounds like a udev script issue, not a kernel issue,
> correct?
>> >> >
>> >>
>> >> [MKGU>] Yes. It seems related to udev.
>> >>
>> >> > > > If you run 'udevadm monitor', does it show a 10 second delay?
>> >> > >
>> >> > > [MKGU>] I don't have the program 'udevadm' on my system.
>> >> >
>> >> > Do you have the program 'udevmonitor'?  I suggest trying that.
>> >> >
>> >>
>> >> [MKGU>] Yes, I ran "udevmonitor" and captured the following
> messages:
>> >> UEVENT[1224775488.005799] remove   /class/usb/usbled0 (usb)
>> >> UEVENT[1224775488.007901] remove   /class/usb (class)
>> >> UEVENT[1224775488.011992] remove
>> >> /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
>> >> UEVENT[1224775488.019706] remove
>> >> /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
>> >> UEVENT[1224775496.176576] add
>> >> /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
>> >> UEVENT[1224775496.181732] add
>> >> /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
>> >> UEVENT[1224775496.186031] add      /class/usb/usbled0 (usb)
>> >
>> > Then I suggest filing a bug with your distro to get this looked at,
> as
>> > they are responsible for the udev scripts here, nothing wrong with
> your
>> > kernel :)
>>
>> You don't have UDEV[...] events here? The interesting output of
>> udevmonitor would the timing difference between the kernel events and
>> the udev events, but you completely miss the udev ones.
>>
>
> [MKGU>] Yes, I don't have UDEV[...] events captured. That's all what I
> captured. I was using "udevmonitor" in the udev-113 package.

>> What version of udev, and which distro is that?
>
> [MKGU>] I am not sure what version of my udev in use on the system. How
> can I check its version? I am using kernel 2.6.21.7-cfs-v22.

  /sbin/udevd -V
or
  udevinfo -V

> [MKGU>] In reply to your question in another email, I did not find the
> line containing the string WAIT_FOR_SYSFS= in all *.rules files under
> /etc/udev/ and /etc/udev/rules.d/.

Ok, sounds good. The default WAIT_FOR_SYSFS timeout is 10 seconds, so
that would be the usual suspect.

Kay
