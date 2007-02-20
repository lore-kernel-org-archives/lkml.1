Return-Path: <linux-kernel-owner+w=401wt.eu-S1030461AbXBTVfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030461AbXBTVfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030459AbXBTVfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:35:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50288 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030454AbXBTVe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:34:58 -0500
Date: Tue, 20 Feb 2007 13:31:32 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
Subject: Re: 2.6.19-rc6-mm1: drivers/net/chelsio/: unused code
Message-ID: <20070220133132.63f3e75e@localhost.localdomain>
In-Reply-To: <20070220000214.GB13958@stusta.de>
References: <20061123021703.8550e37e.akpm@osdl.org>
	<20061124001731.GO3557@stusta.de>
	<20061127102455.362fe88f@dxpl.pdx.osdl.net>
	<20061129073609.GA11084@stusta.de>
	<20061128234719.9b3a224d.akpm@osdl.org>
	<20070220000214.GB13958@stusta.de>
Organization: The Linux Foundation
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 01:02:14 +0100
Adrian Bunk <bunk@stusta.de> wrote:

> On Tue, Nov 28, 2006 at 11:47:19PM -0800, Andrew Morton wrote:
> > On Wed, 29 Nov 2006 08:36:09 +0100
> > Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > On Mon, Nov 27, 2006 at 10:24:55AM -0800, Stephen Hemminger wrote:
> > > > On Fri, 24 Nov 2006 01:17:31 +0100
> > > > Adrian Bunk <bunk@stusta.de> wrote:
> > > > 
> > > > > On Thu, Nov 23, 2006 at 02:17:03AM -0800, Andrew Morton wrote:
> > > > > >...
> > > > > > Changes since 2.6.19-rc5-mm2:
> > > > > >...
> > > > > > +chelsio-22-driver.patch
> > > > > >...
> > > > > >  netdev updates
> > > > > 
> > > > > It is suspicious that the following newly added code is completely unused:
> > > > >   drivers/net/chelsio/ixf1010.o
> > > > >     t1_ixf1010_ops
> > > > >   drivers/net/chelsio/mac.o
> > > > >     t1_chelsio_mac_ops
> > > > >   drivers/net/chelsio/vsc8244.o
> > > > >     t1_vsc8244_ops
> > > > > 
> > > > > cu
> > > > > Adrian
> > > > > 
> > > > 
> > > > All that is gone in later version. I reposted new patches
> > > > after -mm2 was done.
> > > 
> > > It seems these patches didn't make it into 2.6.19-rc6-mm2 ?
> > 
> > I dropped that patch and picked up Francois's tree instead.
> 
> These structs are still both present and unused as of 2.6.20-mm1.

Please use your eyes, not your tool. Those functions are called in 2.6.20

static struct cmac *ixf1010_mac_create(adapter_t *adapter, int index)
{
...
	mac->ops = &ixf1010_ops;

static struct cmac *mac_create(adapter_t *adapter, int index)
{
...

	mac->ops = &chelsio_mac_ops;

mac_create gets called by 

int __devinit t1_init_sw_modules(adapter_t *adapter,
				 const struct board_info *bi)
{

	for_each_port(adapter, i) {
		u8 hw_addr[6];
		struct cmac *mac;
		int phy_addr = bi->mdio_phybaseaddr + i;

		adapter->port[i].phy = bi->gphy->create(adapter, phy_addr,
							bi->mdio_ops);


