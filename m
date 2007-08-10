Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbXHJJwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbXHJJwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbXHJJwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:52:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:44926 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759299AbXHJJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qxQ3B87qcpQ+Bosv/oZLuztgq0QLJ07intqabT+YMXBFE9E7cOtYnBBPkgutVbKrv5MLg4yKnXQEglaIYkREu0BZNT25r8JiC48ZltvdAXD+Kl8p6qNBj+sZ0pXEx70Kivo3eECDdgPmkmFfQ2BQ51COYZsUIZZA+8RdAECrrHU=
Message-ID: <a8e1da0708100252g5597da63j9cb665ade26f7654@mail.gmail.com>
Date: Fri, 10 Aug 2007 17:52:04 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc2-mm2
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <a8e1da0708100137t48c5c673vf0c98fb5f0cd058b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	 <a8e1da0708100118r779068i64ffdc11e452be9b@mail.gmail.com>
	 <20070810013210.1b2f121c.akpm@linux-foundation.org>
	 <a8e1da0708100137t48c5c673vf0c98fb5f0cd058b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/10/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> >On 8/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 10 Aug 2007 16:18:38 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> >
> > > Hi,
> > > 2.6.23-rc2-mm2:
> > > config with CONFIG_NF_CONNTRACK_AMANDA=y
> > > boot  oops:
> > >
> > > hand copyed :
> > > the EIP: helper_hash
> > >
> > > backtrace:
> > > do_basic_setup
> > > ...
> > > nf_conntrack_amanda_init
> > > error_code
> > > do_vivide_error
> > > ...
> > >
> >
> > cc netdev
> >
> > please send config
> >
> > presumably nf_ct_helper_hsize is zero
> >
> > I'd have thought that the same bug would be present in mainline - there's
> > nothing in git-net.patch.
> >
> > (hunts around, discovers that there's a net-2.6.24 tree now.  Bah)
> >
> MY config file for test:
>-----cut---
Hi,
config the CONFIG_NF_CONNTRACK_AMANDA=m, reboot , still oops, but this
time the point is nf_conntrack_ftp_init, (I doubt the
nf_conntrack_core is not initialized.)

boot with vga_ask and select 80x60, copyed more infomations:
---------pre oops:-----------
sysctl table check failed: /net/netfilter/nf_conntrack_generic_timeout
.3.19.13 Missing strategy
...
nf_conntrack_14_proto_sctp4 protocol register failed
...
---------oops:----------------
divide error: 0000 [#1] SMP
EIP: 0060: [<c088477b>] EFLAGS 00010246
Process swapper
...
nf_conntrack_ftp_init
...

Code: <...>
EIP <...> helper_hash +0x1b/0x24

Regards
dave
