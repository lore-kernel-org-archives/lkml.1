Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYAQJkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYAQJkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 04:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYAQJkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 04:40:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYAQJkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 04:40:22 -0500
Date: Thu, 17 Jan 2008 07:40:07 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: elendil@planet.nl, jesse.brandeburg@intel.com, slavon@bigtelecom.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
Message-ID: <20080117094007.GF321@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	David Miller <davem@davemloft.net>, elendil@planet.nl,
	jesse.brandeburg@intel.com, slavon@bigtelecom.ru,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <36D9DB17C6DE9E40B059440DB8D95F520432DA91@orsmsx418.amr.corp.intel.com> <20080116.232037.261622584.davem@davemloft.net> <200801170851.56029.elendil@planet.nl> <20080117.000002.37027317.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117.000002.37027317.davem@davemloft.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 17, 2008 at 12:00:02AM -0800, David Miller escreveu:
> From: Frans Pop <elendil@planet.nl>
> Date: Thu, 17 Jan 2008 08:51:55 +0100
> 
> > On Thursday 17 January 2008, David Miller wrote:
> > > From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
> > >
> > > > We spent Wednesday trying to reproduce (without the patch) these issues
> > > > without much luck, and have applied the patch cleanly and will continue
> > > > testing it.  Given the simplicity of the changes, and the community
> > > > testing, I'll give my ack and we will continue testing.
> > >
> > > You need a slow CPU, and you need to make sure you do actually
> > > trigger the TX limiting code there.
> > 
> > Hmmm. Is a dual core Pentium D 3.20GHz considered slow these days?
> 
> No of course :-)  I guess it therefore depends upon the load
> as well.

I saw it just once, yesterday:

[root@doppio ~]# uname -r
2.6.24-rc5
e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
  Tx Queue             <0>
  TDH                  <58>
  TDT                  <8f>
  next_to_use          <8f>
  next_to_clean        <55>
buffer_info[next_to_clean]
  time_stamp           <105e973a9>
  next_to_watch        <56>
  jiffies              <105e97992>
  next_to_watch.status <1>
[root@doppio ~]#

on a lenovo T60W, core2duo machine (2GHz), when using it to stress test
another machine, I was using netperf TCP_STREAM ranging from 1 to 8
streams + a ping -f using various packet sizes.

I'll update this machine today to 2.6.24-rc8-git + net-2.6 and try again
to reproduce.

I also applied David's patch while trying some RT experiments on
another, 8 way machine used as a server, but on this machine I didn't
experience the Tx Unit Hang message with or without the patch.

- Arnaldo
