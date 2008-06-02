Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYFBOO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYFBOO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbYFBOOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:14:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbYFBOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:14:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Mon, 2 Jun 2008 16:13:14 +0200
User-Agent: KMail/1.9.9
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
References: <200805311737.58991.arnd@arndb.de> <200806021315.41211.arnd@arndb.de> <6880.1212411400@jrobl>
In-Reply-To: <6880.1212411400@jrobl>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021613.15088.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19xziiX5w/ipRtMiYL3ecK9pah4fV12OlvRcWD
 Yyht4j+xsp6X25n8O4+SbXLh4tRENu845i/iBUXaEuCwfcTDq6
 3fx0FJyHWIW8GuHx4TCqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008, hooanon05@yahoo.co.jp wrote:
> I don't want you to call aufs users crazy who are using such policies.
> By the way, how do you think link(2) or rename(2)? When the source file
> exists on the lower writable branch, do you think copy-up is the best
> way? Or do you think all lower branches should be readonly?
> There is an exception in aufs's branch-select policy. That is
> link/rename case. When the source file exists on a writable branch, aufs
> tries link/rename it on that branch in every policy. Do you think it
> best to do it on the top branch only?

Yes, I tend to consider the union case identical to the cross-mount
move or link, so I'd expect the kernel to return errno=EXDEV and user
space to handle this by doing the appropriate copy/unlink as it does
for other cases already.

	Arnd <><
