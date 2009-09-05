Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZIERHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZIERHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 13:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZIERHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 13:07:36 -0400
Received: from fifo99.com ([67.223.236.141]:48164 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZIERHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 13:07:35 -0400
Subject: Re: [RFC][PATCH 2/2] disable boot interrupts on Intel X58 and 55x0
From: Daniel Walker <dwalker@fifo99.com>
To: Olaf Dabrunz <Olaf.Dabrunz@gmx.net>
Cc: Stefan Assmann <sassmann@redhat.com>, linux-kernel@vger.kernel.org,
       jcm@redhat.com, sdietrich@novell.com, linux-acpi@vger.kernel.org,
       andi@firstfloor.org, hpa@zytor.com, mingo@elte.hu, ktokunag@redhat.com,
       tglx@linutronix.de, lenb@kernel.org
In-Reply-To: <20090905161852.GA19706@santana.dyndns.org>
References: <20090904165525.26294.31112.sendpatchset@t500>
	 <20090904165545.26294.94612.sendpatchset@t500>
	 <1252084019.22928.39.camel@desktop> <4AA22A6F.30003@redhat.com>
	 <1252162040.6877.7.camel@desktop>
	 <20090905161852.GA19706@santana.dyndns.org>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 10:07:39 -0700
Message-Id: <1252170459.6877.44.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 18:18 +0200, Olaf Dabrunz wrote:
> On 05-Sep-09, Daniel Walker wrote:
> > On Sat, 2009-09-05 at 11:07 +0200, Stefan Assmann wrote:
> > > On 04.09.2009 19:06, Daniel Walker wrote:
> > > > On Fri, 2009-09-04 at 12:55 -0400, Stefan Assmann wrote:
> > > >> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_QPI_TBG15,  quirk_disable_intel_tylersburg_boot_interrupt);
> > > >> +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,  PCI_DEVICE_ID_INTEL_QPI_TBG15,  quirk_disable_intel_tylersburg_boot_interrupt);
> > > > 
> > > > 
> > > > These lines are wildly long .. Could you reduce these down to a max of
> > > > 80 characters..
> > > 
> > > Hi Daniel,
> > > 
> > > you're right about the lines being to long, however if you take a peek
> > > at drivers/pci/quirks.c you'll see that all the quirks are done this
> > > way. :)
> > 
> > I looked, the whole thing is a mess .. Really all these lines need to be
> > cleaned up.. It doesn't help to have you add more to it tho. Especially
> > the tab's or spaces between the commas, I can say I understand why that
> > is.. If there is a good reason why it's like that I'm all ears..
> 
> It makes adding/deleting/modifying the entries easier, with one-line
> editor operations. And if all data for one ID-to-quirk relationship is
> on one line, with tabs to make for nice columns, I can more easily see
> which device is linked to which quirk. That is why I usually prefer one
> line per entry. And the entries in quirks.c are long, but not too long
> for that IMHO.

Firstly I would say these entries aren't consistent at all.. Some are
comma tab delimited, some are comma space delimited, and some are mixed
space plus tab delimited plus comma delimited.. Many are actually broken
down into less than 80 max length already..

I'm not sure I see how this makes "adding/deleting/modifying" easier ..
We have lots of other situations where lines are broken down less than
80, function arguments, macros, structures all sorts of stuff. 

Taking this block for instance,

DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
                        PCI_DEVICE_ID_TIGON3_5780,
                        quirk_msi_intx_disable_bug);
DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
                        PCI_DEVICE_ID_TIGON3_5780S,
                        quirk_msi_intx_disable_bug);
DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
                        PCI_DEVICE_ID_TIGON3_5714,
                        quirk_msi_intx_disable_bug);
DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
                        PCI_DEVICE_ID_TIGON3_5714S,
                        quirk_msi_intx_disable_bug);
DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
                        PCI_DEVICE_ID_TIGON3_5715,
                        quirk_msi_intx_disable_bug);
DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
                        PCI_DEVICE_ID_TIGON3_5715S,
                        quirk_msi_intx_disable_bug);

In this block there is a fairly clear pattern you can follow. One
problem with using tabs is that in order to get the perceive benefit
your suggesting you would be forced to have a terminal at a certain
size. Without that the single lines just end up line wrapped but in a
less consistent way. You also have the problem that people have to
deliberately add this formatting , sometimes one tab is enough,
sometimes you need two tabs, maybe someone uses spaces instead .. So you
end up with people potentially using all sorts of different methods and
maybe not getting it right (not to mention it's special formatting just
for this file)..

> So this will only be a problem for terminals that are limited to 80
> rows, and I do not think that anyone is that restricted nowadays.

It's more than that.. In order to un-wrap the lines in this file you
have to have a terminal at over 130 characters in width.

I think it would be better to create a script that parses this file and
produces consistent list in the format your describing, just for review
purposes.. That way it takes the human element out of it, and it still
lets you look at the formatting that your looking for.

Daniel

