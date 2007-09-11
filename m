Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbXIKNoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbXIKNoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbXIKNoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:44:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44778 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbXIKNoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:44:09 -0400
X-Sasl-enc: hxrua6vaDchFdduC88jkM1DXepBps1CFeIIWt6vMDOIU 1189518258
Date: Tue, 11 Sep 2007 10:44:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: Re: Platform device id
Message-ID: <20070911134405.GA18443@khazad-dum.debian.net>
References: <20070910225205.GB1408@khazad-dum.debian.net> <C5k470vB.1189496614.5481670.khali@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5k470vB.1189496614.5481670.khali@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Jean Delvare wrote:
> >I will see what I can do about breaking it up in various modules.  But this
> >can be unoptimal. If I took it too seriously, thinkpad-acpi would break into
> >at least five different modules, if not more, and at least one or two
> >modules would need to be there for the common code.  There has to be a
> >middle ground somewhere, I think.
> 
> I don't know your code and I don't really have the time to look at it
> in depth, but I'm a bit surprised. Presumably your driver is
> implementing a number of interfaces (e.g. hwmon) and you create a class
> device for each one. You can have as many class devices hanging of a
> (physical) device, so I fail to see why you would need to register
> several (physical) devices.

Namespace clashes.  Now that class attributes are gone (or going, whatever),
everything lives in one namespace: the device.  I dread the day I find out
one class I need has attribute name clashes with another, or (more likely)
one of my driver-specific attributes clash with one from a generic class.

Even if clashes never happen, it can make quite a mess when you have four or
more classes in the same device. And you can have semanthic clashes, if one
looks at various attributes (from different classes or driver-specific) and
think they are related in some obvious way (only, it is not obvious at all,
and the user didn't read the docs to know it).

It is nothing too serious, but something to keep in mind when deciding what
to do with a big driver.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
