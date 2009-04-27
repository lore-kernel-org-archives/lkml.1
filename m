Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbZD0Vgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbZD0Vgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZD0Vgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:36:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:20897 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbZD0Vgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0904271715470.17474-100000@netrider.rowland.org>
References: <20090427210059.GA12446@kroah.com> <Pine.LNX.4.44L0.0904271715470.17474-100000@netrider.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 27 Apr 2009 23:36:26 +0200
Message-ID: <ac3eb2510904271436j7a7351e8sb2fc47c75be31dd0@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 23:21, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 27 Apr 2009, Greg KH wrote:
>
>> On Mon, Apr 27, 2009 at 04:48:00PM -0400, Alan Stern wrote:
>> > On Mon, 27 Apr 2009, Greg KH wrote:
>> >
>> > > Kay Sievers (11):
>> > >       rename configure.in -> configure.ac
>> > >       delete spec file
>> >
>> > Why delete the spec file?  Don't you want to keep it for people who
>> > would like to build an RPM?
>>
>> Do people build rpms out of tarballs that aren't coming from their
>> distro anymore?
>
> Sure they do.  If you've got an RPM-based system, and you want to
> install a package version that's more recent than the one bundled in
> your distribution (or if your distribution doesn't include the package
> at all), then you'd want to build your own RPM.
>
>>  I didn't realise this, and can put it back, but it's
>> one more thing to forget to bump the version number on :(
>
> It's not urgent.  You're going to be making other changes too...  new
> output formats and replacing libusb, right?  So include the spec file
> again when you do the next release.

Having a spec file in the repo needs configure.ac pre-processing to
create a proper spec file to use, to find out where to install the
files. As an example, SUSE puts the ids file in /usr/share/ Fedora in
/usr/share/hwdata/ (not even shipped with the usbutil package), other
distros put it in /usr/share/misc/.

Having multiple files installed, because we didn't find the right
place, may break other packages build which search for them at build
time, like udev-extras.

There is really not a good chance to get this stuff right, without
using the spec file that comes with the original package from the
distro that is used.

Thanks,
Kay
