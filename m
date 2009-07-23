Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZGWP5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZGWP5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZGWP5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:57:55 -0400
Received: from outbound-mail-302.bluehost.com ([67.222.53.9]:37975 "HELO
	outbound-mail-302.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752069AbZGWP5y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:57:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PbWPg7M3p+1L88g8N6X+pZ944EsZ/ZwEobXBCZXCtYDgDJ2vrgubOpzQkDv7JE+WMwcIpUwSH6SB/jvYZa4Zd31jYR2wFL6gCogqvBthLzevTucKkBDwpAlBlKGg23cr;
Date: Thu, 23 Jul 2009 08:57:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.31-rc4: strange change in iomem allocation
Message-ID: <20090723085751.1872545c@jbarnes-g45>
In-Reply-To: <86802c440907230742w2858e1d9i8357bb94ed996ff3@mail.gmail.com>
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain>
	<200907231614.23570.elendil@planet.nl>
	<86802c440907230742w2858e1d9i8357bb94ed996ff3@mail.gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 07:42:28 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Thu, Jul 23, 2009 at 7:14 AM, Frans Pop<elendil@planet.nl> wrote:
> > I'm seeing the following change in dmesg between -rc3 and -rc4:
> > -system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
> > +system 00:0c: iomem range 0xfec00000-0xfec000ff could not be
> > reserved
> >
> > There is nothing in the earlier part of dmesg that would explain
> > this change.
> >
> > The change is also visible in /proc/iomem:
> >  fec00000-fec00fff : IOAPIC 0
> >   fec00000-fec00fff : reserved
> > -    fec00000-fec000ff : pnp 00:0c
> >
> > I somewhat suspect 857fdc53a0a90c3ba7fcf5b1fb4c7a62ae03cf82:
> >    x86/pci: insert ioapic resource before assigning unassigned
> > resources
> >
> > System is HP 2510p notebook (x86_64).
> 
> should be ok. we don't need that
>    fec00000-fec000ff : pnp 00:0c

So the PNP ranges are duplicating the IOAPIC range?  Seems harmless
enough...

-- 
Jesse Barnes, Intel Open Source Technology Center
