Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYFBPBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYFBPBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYFBPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:01:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYFBPBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:01:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Mon, 2 Jun 2008 17:01:16 +0200
User-Agent: KMail/1.9.9
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
References: <200805311737.58991.arnd@arndb.de> <200806021613.15088.arnd@arndb.de> <8353.1212417209@jrobl>
In-Reply-To: <8353.1212417209@jrobl>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021701.17076.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19J3D2QnsMjAXXj6TYJIrmFQvkxBqihW73x1o1
 JL5pB3OZydhHtgyE0MZPo/kaUmP9RsmHVoEg9lMOLoOe/BqCKE
 PknLnGncmU29YVB8S3u9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008, hooanon05@yahoo.co.jp wrote:
> Aure rename returns EXDEV when the target is a dir and it has child
> entr(y|ies) on lower branhc(es). And mv(1) handles this case.
> My Engilsh might be miunderstood. Do you think link(2) should return an
> error when the target exists on lower writable branch?

Any writes should always just go to the top level. If the source file
for link() exists on the top level, link should succeed even if a target
exists on a lower level (given that the user has permissions to
unlink that file), but should return EXDEV if the source comes from
a lower level.

	Arnd <><
