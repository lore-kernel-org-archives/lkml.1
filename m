Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbZD2Tuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbZD2Tuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZD2Tul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:50:41 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50176 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbZD2Tuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:50:40 -0400
X-Sasl-enc: xCWIhGs1TL5rLLo0Nxg4qIwrb0H1pCnfUF+5vpWLdbzo 1241034639
Date: Wed, 29 Apr 2009 16:50:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090429195037.GC1598@khazad-dum.debian.net>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> <20090429191841.GA1598@khazad-dum.debian.net> <ac3eb2510904291227v48628c8j181dffc8fdfa1de6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510904291227v48628c8j181dffc8fdfa1de6@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Kay Sievers wrote:
> > Debian places it in /var/lib/usbids/ for a good reason.  So does Ubuntu.
> > Both have working "update-usbids" scripts (might be the one from upstream,
> > or something different).  They also have the original file in /usr/share, I
> > don't know if usbutils was changed to check /var first then /usr, or what.
> 
> Having several files on the same system sounds crazy from a distro
> standpoint. There needs to be only a single database by default. Users

We are talking about two files, here.  Not several.

> can do whatever they want anyway, but packages should not support such
> a thing.

If they are to be useful, yes, they do.  Or do you want us to package just
the usb-ids text file by itself and keep updating it all the time?  That's
the only other possibility, and it is done for the tzdata.

But update-usbids (like update-pciids and update-intel-microcode) works just
fine, so likely the usbutils maintainer didn't have any reasons to move from
update-usbids to a volatile package.

> If the user updates it, what does a new ids file do? Overwrite it

Well, the package overwrites the older one if the download suceeds with a
mv.  No mess.  If the download fails, the temp file is removed, and the
older one remains untouched.

There is no mess here.  And it might be a simple case of the package
creating /var/lib/usbids/usb.ids at post-install time from the static
packaged data, and usbutils always using just /var/lib/usbids/usb.ids. I am
not the maintainer of that package, and sincerely, given your tone, I am not
inclined to go fetch the source and read the scripts.

Now, I am not sure there is any checking against partial downloads.  That is
one thing a more controlled volatile package would be better at.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
