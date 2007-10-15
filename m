Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXJOHfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXJOHfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXJOHe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:34:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:63241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbXJOHe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:34:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
       Guido Guenther <agx@sigxcpu.org>, Kevin Corry <kevcorry@us.ibm.com>,
       stable@kernel.org
Subject: Re: [2.6.24 PATCH 02/25] dm io:ctl use constant struct size
Date: Mon, 15 Oct 2007 09:34:09 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <20071012170509.GM24157@agk.fab.redhat.com> <200710130016.29937.arnd@arndb.de> <20071015012621.GD10006@agk.fab.redhat.com>
In-Reply-To: <20071015012621.GD10006@agk.fab.redhat.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710150934.09842.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+BsTMZViqlbdo0aOt0xOIWQEX23g/ysWqG0sZ
 2PVWQpSferO3ew3r0GuMS/5iIxqGoI3Gfz+s5DrnWan3O4psUZ
 8Hkrs+YUQeuOe1adxMdGw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007, Alasdair G Kergon wrote:
> The underlying ABI is not changing, I hope - the trailing padding in the
> struct should not affect the processing of the data by dm, and I see no
> reason to continue maintaining the fiction that the 32-bit and 64-bit
> ioctls are in some way incompatible with each other when they aren't
> AFAIK.

It's a corner case of some sort, as DM uses ioctl numbers differently
from most subsystems by splitting to code from the size argument
during processing. Your change is certainly not an _incompatible_
change to the ABI, but 32 bit binaries compiled against the new
headers will use different ioctl numbers from those built against
older headers.

This may break other code that expects a specific number, even
if your handler does not care. The old compat code handles both
variants (no variable size arguments), but /usr/bin/strace may have
encoded only one set of numbers AFAICT.

> And yes, a follow-up patch can clean up our use of the compatibility
> mechanism, going a little bit further than the patch you attached, I
> hope.

Ok, sounds good. I don't think it's the kind of patch that should go
into stable backports though.

	Arnd <><
