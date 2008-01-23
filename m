Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYAWBz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYAWBz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 20:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYAWBzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 20:55:22 -0500
Received: from ozlabs.org ([203.10.76.45]:51198 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbYAWBzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 20:55:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] kernel/params.c: fix the module name length in param_sysfs_builtin
Date: Wed, 23 Jan 2008 12:54:26 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Denis Cheng <crquan@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
References: <1200906505-28859-1-git-send-email-crquan@gmail.com> <200801212216.11784.rusty@rustcorp.com.au> <Pine.LNX.4.64.0801230011300.9183@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801230011300.9183@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231254.26918.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008 10:13:37 Jan Engelhardt wrote:
> On Jan 21 2008 22:16, Rusty Russell wrote:
> >On Monday 21 January 2008 20:08:25 Denis Cheng wrote:
> >> the original code use KOBJ_NAME_LEN for built-in module name length,
> >> that's defined to 20 in linux/kobject.h, but this is not enough
> >> appearntly, many module names are longer than this;
> >>  #define KOBJ_NAME_LEN                   20
> >
> >Thanks, applied.  I was surprisedto learn that we have a 35-char source
> >filename in the kernel.
> >
> >And congratulations to nf_conntrack_l3proto_ipv4_compat.c!
>
> But nf..dada_compat.c gets linked into nf_conntrack_ipv4.ko,
> and that is what is used in /sys/module - and it fits the 20.
> Any place where nf_conntrack_l3proto_ipv4_compat would still be used?

Of course, but my point was that we already have a 35 char filename in the 
kernel, and lots of > 22 chars, so increasing it is not unreasonable.

FYI make allmodconfig here gives me the following of 21 chars or longer:

dvb-usb-af9005-remote
dvb-usb-dibusb-common
nf_conntrack_netbios_ns
nf_conntrack_proto_udplite
nf_conntrack_proto_sctp
nf_conntrack_proto_gre

Cheers,
Rusty.
