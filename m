Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbZKDVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbZKDVGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbZKDVGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:06:51 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:61198 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347AbZKDVGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:06:50 -0500
From: Frans Pop <elendil@planet.nl>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] kbuild: let make O=dir rpm-pkg fail
Date: Wed, 4 Nov 2009 22:06:53 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <1257315285-6782-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1257315285-6782-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911042206.54801.elendil@planet.nl>
X-OriginalArrivalTime: 04 Nov 2009 21:06:55.0214 (UTC) FILETIME=[BD11A8E0:01CA5D92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Akinobu Mita wrote:
> make rpm-pkg with setting KBUILD_OUTPUT is not possible and
> it will print the good message since the commit
> db9038c89d129383a9db2afcb72b504fe54f6edf
>
> $ KBUILD_OUTPUT=dir make rpm-pkg
> ...
> Building source + binary RPM is not possible outside the
> kernel source tree. Don't set KBUILD_OUTPUT, or use the
> binrpm-pkg target instead.
> ...
>
> make O=dir should have the same effect of KBUILD_OUTPUT, but
> it won't print that message.
>
> This fixes it by exporting KBUILD_OUTPUT if O= is set so that
> the rpm-pkg target in scripts/package/Makefile can find it.

Looks good to me. I suspect this will also fix the open question that I had 
when I submitted the patch you refer to:
<quote>
One open issue is that the following commands should IIUC be identical,
but the second one does not work:
- KBUILD_OUTPUT=../builds/amd64 make -j4 binrpm-pkg
- make -j4 O=../builds/amd64 binrpm-pkg

AFAICT the root Makefile is supposed to set KBUILD_OUTPUT based on O=, but
that is not visible when the lines within the binrpm-pkg target are 
executed.
My make foo was not strong enough to debug this.
</quote>

I also suspect that the use of O= is currently equally broken for the 
deb-pkg target (I know setting KBUILD_OUTPUT does work) and that this 
patch will fix that as well.

Cheers,
FJP
