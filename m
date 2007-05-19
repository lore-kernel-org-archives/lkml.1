Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbXESX5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbXESX5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbXESX5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:57:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170AbXESX5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:57:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Petr Vandrovec <petr@vandrovec.name>
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
Date: Sun, 20 May 2007 01:55:25 +0200
User-Agent: KMail/1.9.6
Cc: dan@dennedy.org, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070507021447.GA22197@vana.vc.cvut.cz>
In-Reply-To: <20070507021447.GA22197@vana.vc.cvut.cz>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705200155.26825.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/G+rheBDxGVnAgQ5hNDSTwg+UVVIFk2ziVnJH
 5Zj9v//AU69X5sy/nCCjD3z8qYiwUY9bipE2KV3JSsXAD1oJEg
 f4/pk45ku8E/BsS5Q7QtQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2007, Petr Vandrovec wrote:
> +struct raw1394_cycle_timer32 {
> +        __u32 cycle_timer;
> +        __u64 local_time;
> +} __attribute__((packed));

Note that this data structure only needs conversion on x86_64 and ia64, but
not on powerpc and other 64 bit architectures that align __u64 also in
32 bit mode.

I would suggest you introduce a new __compat_u64 type as

typedef __u64 __compat_u64 __attribute__((aligned(4)));

in include/asm-{x86_64,ia64}/compat.h and as

typdef __u64 __compat_u64;

in the other architectures. Other people have hit the same problem
before and found varying workarounds, but I think we should just
do it correctly now.

	Arnd <><
