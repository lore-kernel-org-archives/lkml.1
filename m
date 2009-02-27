Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbZB0SQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbZB0SQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZB0SQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:16:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:10312 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZB0SQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:16:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,277,1233561600"; 
   d="scan'208";a="390337510"
Subject: Re: [PATCH] net headers: export dcbnl.h
From: Chris Leech <christopher.leech@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "sam@ravnborg.org" <sam@ravnborg.org>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090227.024635.51509388.davem@davemloft.net>
References: <20090227004635.10247.60814.stgit@localhost.localdomain>
	 <20090227055506.GA7020@uranus.ravnborg.org>
	 <20090227.024635.51509388.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 10:16:01 -0800
Message-Id: <1235758561.4774.25.camel@cleech-mobl1>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 02:46 -0800, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri, 27 Feb 2009 06:55:06 +0100
> 
> > On Thu, Feb 26, 2009 at 04:46:35PM -0800, Chris Leech wrote:
> > > The DCB netlink interface is required for building the userspace tools
> > > available at e1000.sourceforge.net
> > 
> > Hmmm, is that file ready for export....
> > 
> > >From dcbnl.h:
> > #ifndef __LINUX_DCBNL_H__
> > #define __LINUX_DCBNL_H__
> > 
> > #define DCB_PROTO_VERSION 1
> > 
> > struct dcbmsg {
> >         unsigned char      dcb_family;
> >         __u8               cmd;
> >         __u16              dcb_pad;
> > };
> > 
> > 1) It uses __u8/__u16 so it would be nice it is included <linux/types.h>
> > so these are actually defined.

OK, I'll send again with a patch to add <linux/types.h>

> > 2) Why does it use "unsigned char" for one member and __u8 for another.
> > It looks inconsistent.

My guess is that the first member was made to be unsigned char to match
struct rtgenmsg, but other rtnetlink users define family as __u8
(fib_rule_hdr, ndmsg, ndtmsg) so it should be OK to change it.

> > We export headers that are much worse but we better raise the bar a little.
> 
> Agreed, we should sort out these issues before exporting.

