Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbXKBHyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbXKBHyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 03:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXKBHyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 03:54:44 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:50770 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbXKBHyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 03:54:43 -0400
Message-ID: <472AD7B6.8050301@debian.org>
Date: Fri, 02 Nov 2007 08:54:30 +0100
From: Giacomo Catenazzi <cate@debian.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Rik van Riel <riel@surriel.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Mark Gross <mgross@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
References: <20071014190128.6e3cdb44@bree.surriel.com>	<20071015170411.GB18550@linux.intel.com>	<20071015183017.GB23130@uranus.ravnborg.org>	<4713C582.4000504@debian.org>	<20071016200623.GB23157@linux.intel.com>	<Pine.LNX.4.64.0710162207540.4548@fbirervta.pbzchgretzou.qr> <20071016162310.1891914f@bree.surriel.com>
In-Reply-To: <20071016162310.1891914f@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Tue, 16 Oct 2007 22:09:04 +0200 (CEST)
> Jan Engelhardt <jengelh@computergmbh.de> wrote:
>> On Oct 16 2007 13:06, Mark Gross wrote:
>>> base function:
>>> Starting from a stock distro (FC, Ubuntu, OpenSuSE...) and put down a
>>> kernel.org tree and automatically create a .config with all the
>>> drivers needed for the platform I'm building on.
>> Too easy. Since opensuse's udev loads most of the modules for your
>> hardware, all that would be needed is to transform the lsmod list of
>> modules plus the static options in /proc/config.gz (stuff like
>> psmouse) back into kconfig options ;-)
> 
> Well, at that point it does not know whether or not you
> occasionally plug in an ipod or a digital camera.
> 
> Going back from the lsmod output to all the right CONFIG
> options is also not as trivial as it sounds, due to all
> the dependencies there are.

As part of Linux Kernel Driver DataBase, yesterday I "solved"
also this problem:
>From a module name, I can obtain relative the kernel
configuration item.

You can see the result in http://cateee.net/lkddb
(grep '^drv module' drivers-db). I count 2570 such items.

But I've some problems on few cases:
sometime there is one module name with more CONFIG_s.
Normally such cases happens in modules on the same directory,
as support module or as parent module.
I don't see a method to distinguish the right (minimal)
configuration.

One solution would be to remove some dependencies on
Makefile, and checking and ev. creating such dependencies
on Kconfig. But this require a kernel modification.

Or you think there is a better (non-invasive) method?

ciao
	cate

