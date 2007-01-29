Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXA2WFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXA2WFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXA2WFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:05:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:6249 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXA2WFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YamFso70ufLgpn5N24AVZmulIo2nGLtvHQS7o/rxX3uyQQxJLTaJuyRA8Xp/RImBJmpYJdYtCiaMMqFSDKAIIEjIQY4gK+4SANNv04pCdep5DgwIIIHKBIqoduOar4k/cPn7zKi2369f5ekdoAyieYt3FEh9tlpX0YZ9XZQS/R0=
Subject: Re: i965 testers wanted (Re: intel-agp PM experiences)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: andi@lisas.de, davej@codemonkey.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, seife@suse.de,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
In-Reply-To: <20070123094456.GG6033@ucw.cz>
References: <20070116135727.GA2831@elf.ucw.cz>
	 <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com>
	 <20070116142432.GA6171@elf.ucw.cz>
	 <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com>
	 <20070117004012.GA11140@rhlx01.hs-esslingen.de>
	 <20070117005755.GB6270@elf.ucw.cz>
	 <20070118115105.GA28233@rhlx01.hs-esslingen.de>
	 <20070118231650.GA5352@ucw.cz>
	 <20070122044519.GA24398@zhen-devel.sh.intel.com>
	 <20070123094456.GG6033@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jan 2007 23:05:30 +0100
Message-Id: <1170108330.21603.5.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 janvier 2007 à 09:44 +0000, Pavel Machek a écrit :
> Hi!
> 
> > > > Whitelist? Let me blacklist it all the way to Timbuktu instead!
> > > 
> > > > I've been doing more testing, and X never managed to come back to working
> > > > state without some of my couple intel-agp changes:
> > > > - a proper suspend method, doing a proper pci_save_state()
> > > >   or improved equivalent
> > > > - a missing resume check for my i815 chipset
> > > > - global cache flush in _configure
> > > > - restoring AGP bridge PCI config space
> > > 
> > > Can you post a patch?
> > 
> > I've post a patch which trys to resolve pci config restore issue, see
> > http://lkml.org/lkml/2007/1/16/297. It resolves s3 issue with my 965G machine,
> > that my X can come back to live after s3, but I wasn't aware of the issues Andreas
> > has noted. It'll be good if more people could try this out. 
> 
> Ok, I guess we'd like some testing here... so that in can be fixed in
> mainline...

I can confirm that this patch is needed for my Intel Mac Mini to resume
correctly when used without BIOS emulation (EFI mode). Here're the
relevant lspci lines:

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)

Fred.


