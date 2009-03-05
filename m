Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZCEJaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZCEJaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZCEJao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:30:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:48508 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZCEJan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:30:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cbwrSSxV7t31GXKuykCprApM1o05yTdv2sHRXRHr+B6mhxgMDSsa8CGYLZrnKmxepx
         bTMCwRL35+ZP1EKGBT0SfYixv8nmK2jpjK/YSjgLX1A3fOzIpQ+VyNdW3bZjx/l2HpzF
         dronc35s2DjrZD/xYYnSwEdgJGMQ8Aw3ztHlk=
Message-ID: <49AF9BBC.6090609@panasas.com>
Date: Thu, 05 Mar 2009 11:30:36 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: &&//|| typo ?
References: <gncm7q$gp8$1@ger.gmane.org>
In-Reply-To: <gncm7q$gp8$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 16, 2009, 23:35 +0200, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
> Hi,
> 
> inspired by the mail http://lkml.org/lkml/2009/2/15/159
> I did
> 
> grep -Ern '\!=.*\|\|.*\!=' linux-2.6.28.5
> 
> and found the following tests which are always true if the tested variable is
> not NaN:
> 
> linux-2.6.28.5/sound/pci/au88x0/au88x0_core.c:2792:	if ((bits != 8) || (bits != 16))
> 
> linux-2.6.28.5/sound/oss/ad1848.c:283:		if ( (devc->model != MD_1845) ||
> (devc->model != MD_1845_SSCAPE))
> linux-2.6.28.5/sound/oss/ad1848.c:2110:			if (devc->model != MD_1845 ||
> devc->model != MD_1845_SSCAPE)
> 
> linux-2.6.28.5/arch/x86/kvm/vmx.c:1794:	if ((ss.type != 3) || (ss.type != 7))
> linux-2.6.28.5/arch/x86/kvm/vmx.c:1837:	if ((tr.type != 3) || (tr.type != 11))
> /* TODO: Check if guest is in IA32e mode */
> 
> linux-2.6.28.5/net/sunrpc/auth_unix.c:122:	if (cred->uc_uid != acred->uid ||
> cred->uc_gid != acred->gid)

This is OK. The left leg compares uids and the right one - gids.

> 
> linux-2.6.28.5/net/sunrpc/svcauth_unix.c:747:	if (svc_getu32(argv) !=
> htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
> linux-2.6.28.5/net/sunrpc/svcauth_unix.c:833:	if (svc_getu32(argv) !=
> htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {

These two are fine since svc_getu32 will get the next u32
from the argv kvec every time it's being called.

Benny

> 
> linux-2.6.28.5/net/sunrpc/auth_gss/gss_krb5_seqnum.c:78:	if ((plain[4] !=
> plain[5]) || (plain[4] != plain[6])
> linux-2.6.28.5/net/sunrpc/auth_gss/gss_krb5_seqnum.c:79:				   || (plain[4] !=
> plain[7]))
> 
> linux-2.6.28.5/drivers/block/paride/pf.c:569:		if ((buf[k + offs] != 0x20) ||
> (buf[k + offs] != l))
> 
> already known:
> 
> linux-2.6.28.5/drivers/block/paride/pg.c:425:		if (c != ' ' || c != l)
> 
> linux-2.6.28.5/drivers/block/paride/pt.c:506:		if ((buf[k + offs] != 0x20) ||
> (buf[k + offs] != l))
> 
> linux-2.6.28.5/drivers/misc/sgi-gru/grukservices.c:612:	if (word0 != word1 ||
> word0 != MAGIC) {
> 
> linux-2.6.28.5/drivers/scsi/gvp11.c:283:	if (qq != q || qq != 0xff)	/* should be
> read only, all 1's */
> 
> linux-2.6.28.5/drivers/scsi/FlashPoint.c:6045:				if(bit_cnt != 0 || bit_cnt != 8)
> 

