Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZCSPnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZCSPnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbZCSPnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:43:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:43604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbZCSPnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:43:42 -0400
Subject: Re: oops in tracepoint_update_probe_range()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090319132248.GA20200@Krystal>
References: <1237393396.3322.6.camel@localhost.localdomain>
	 <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com>
	 <20090319074616.GA17144@elte.hu>  <20090319132248.GA20200@Krystal>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 21:12:39 +0530
Message-Id: <1237477359.3202.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 09:22 -0400, Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> > > Ingo Molnar wrote:
> > > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > > 
> > > >> Good: f4c3c4cdb1de232
> > > >> Bad : 1e08816af0bc345
> > > >>
> > > >> Config:
> > > >> http://userweb.kernel.org/~jaswinder/oops_20090318/config-hpdv5-tip-bad-20090318
> > > >>
> > > >> oops:
> > > >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page1.jpg
> > > >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page2.jpg
> > > >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page3.jpg
> > > >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page4.jpg
> > > >>
> > > >> <freeze>
> > > > 
> > > > Steve, Frederic - the crashes above are in:
> > > > 
> > > > 	tracepoint_update_probe_range()
> > > > 
> > > > in a modular kernel apparently.
> > > > 
> > > >
> > > 
> 
> Jaswinder : maybe you have old modules in your /lib/modules/`uname -r`
> directory which have the correct version, but the wrong module.h header ?
> 

yes, it was having old modules, after deleting old modules.

[root@hpdv5 linux-2.6-tip]# make modules_install
  INSTALL arch/x86/kernel/test_nx.ko
  INSTALL drivers/hid/hid-dummy.ko
  INSTALL drivers/scsi/scsi_wait_scan.ko
  DEPMOD  2.6.29-rc8-tip
[root@hpdv5 jaswinder-git]# /sbin/mkinitrd /boot/initrd-2.6-tip.img 2.6.29-rc8-tip
[root@hpdv5 linux-2.6-tip]#


By following above steps, I get rid of oops, and here is my lsmod:
[jaswinder@hpdv5]$ /sbin/lsmod 
Module                  Size  Used by
[jaswinder@hpdv5]$ 

--
JSR

