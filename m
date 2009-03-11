Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZCKTKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZCKTKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZCKTK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:10:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154AbZCKTKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:10:25 -0400
Date: Wed, 11 Mar 2009 12:08:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: qingtao.cao@windriver.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: [v1 PATCH 3/8] EDAC: AMD8111 driver source file
Message-Id: <20090311120813.456762f1.akpm@linux-foundation.org>
In-Reply-To: <918342.94228.qm@web50101.mail.re2.yahoo.com>
References: <918342.94228.qm@web50101.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 11:55:36 -0700 (PDT)
Doug Thompson <norsk5@yahoo.com> wrote:

> 
> --- On Tue, 3/10/09, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: Re: [v1 PATCH 3/8] EDAC: AMD8111 driver source file
> > To: "Harry Ciao" <qingtao.cao@windriver.com>
> > Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
> > Date: Tuesday, March 10, 2009, 2:46 PM
> > On Mon,__ 9 Mar 2009 16:08:12
> > +0800
> > Harry Ciao <qingtao.cao@windriver.com>
> > wrote:
> 
> <snip>
> 
> > > +static void edac_pci_write_dword(struct pci_dev *dev,
> > int reg, u32 val32)
> > > +{
> > > +______ int ret;
> > > +
> > > +______ ret = pci_write_config_dword(dev,
> > reg, val32);
> > > +______ if (ret > 0)
> > > +______ ______ printk(KERN_ERR
> > AMD8111_EDAC_MOD_STR
> > > +______ ______
> > ______ " PCI Access Write Error at 0x%x\n",
> > reg);
> > > +}
> > > +
> > > +static void edac_pci_write_byte(struct pci_dev *dev,
> > int reg, u8 val8)
> > > +{
> > > +______ int ret;
> > > +
> > > +______ ret = pci_write_config_byte(dev,
> > reg, val8);
> > > +______ if (ret > 0)
> > > +______ ______ printk(KERN_ERR
> > AMD8111_EDAC_MOD_STR
> > > +______ ______
> > ______ " PCI Access Write Error at 0x%x\n",
> > reg);
> > > +}
> > 
> > 
> > <spends a while trying to work out what the return value
> > of
> > pci_read_config_dword() means>
> > 
> > <gets frustrated and gives up>
> > 
> > Is it correct that all of these functions treat a +ve
> > return value as
> > an error?
> 
> Yes, the config APIs do return an error code on an operation error.

OK, but presumably they're negative error codes, so

	if (ret > 0)
		error()

isn't right.

<checks>

Harry has turned that into

	if (ret != 0)
		error();

which looks better.

