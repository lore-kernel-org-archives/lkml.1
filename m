Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbZD2Tpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbZD2Tpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbZD2TpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:45:19 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:54385 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbZD2TpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <20090429192650.GB15604@kroah.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> 
	<ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> 
	<20090429191841.GA1598@khazad-dum.debian.net> <20090429192650.GB15604@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 21:44:56 +0200
Message-ID: <ac3eb2510904291244u33512d96h34107027ff3704fb@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Greg KH <greg@kroah.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 21:26, Greg KH <greg@kroah.com> wrote:
> On Wed, Apr 29, 2009 at 04:18:41PM -0300, Henrique de Moraes Holschuh wrote:
>> On Wed, 29 Apr 2009, Kay Sievers wrote:
>> > >>> looks like update-usbids.sh was forgotten from EXTRA_DIST in
>> > >>> Makefile.am so the released tarball doesnt have the script ;(
>> >
>> > > np, i'll send patches for both
>> >
>> > Ah missed that, sorry. Sounds good if you add it to the tarball, but
>> > please don't add it to "make install", as packages should not ship
>> > scripts which change the installed package content, unless it's a
>> > config file.
>>
>> Debian places it in /var/lib/usbids/ for a good reason.  So does Ubuntu.
>> Both have working "update-usbids" scripts (might be the one from upstream,
>> or something different).  They also have the original file in /usr/share, I
>> don't know if usbutils was changed to check /var first then /usr, or what.
>
> Yeah, I was looking into doing some kind of "where to look first" type
> thing like lspci does.
>
> Any suggestions?  Specific directory locations and hierarchy that
> distros are already using?

Yeah, don't do it. There should be only a single place for it. This is
the reason udev rules are no longer in /etc, it is a nightmare to
support people thinking of "databases" as config files, they are not.

If you want to do that, introduce a directory, and merge all the the
entries based on the file order, then people can drop their content to
merge/overwrite there, but please don't do this with a single file
database.

You also really don't want to mark it in the package as a config file,
it should be overwritten with every package update, as long as there
is a single file only.

Thanks,
Kay
