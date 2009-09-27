Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbZI0I3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbZI0I3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZI0I3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:29:50 -0400
Received: from [195.41.46.236] ([195.41.46.236]:35695 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZI0I3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:29:49 -0400
Date: Sun, 27 Sep 2009 10:29:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,resend] kbuild: fix the binrpm-pkg target to work with
	KBUILD_OUTPUT set
Message-ID: <20090927082929.GA10156@merkur.ravnborg.org>
References: <200908252215.40950.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908252215.40950.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 10:15:39PM +0200, Frans Pop wrote:
> The binrpm-pkg target (binary RPM only) fails when called with
> KBUILD_OUTPUT set. This patch makes it work.
> 
> For the rpm-pkg target (source + binary RPM), building with
> KBUILD_OUTPUT set is not possible and also not needed as the
> actual build is done in a temporary directory anyway, so check
> that KBUILD_OUTPUT is not set in that case to avoid later errors.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>

Applied.

> ---
> 
> I ran into this while trying if I could build an RPM kernel package on
> my Debian notebook :-)
> 
> The patch has been tested by doing three builds:
> - make -j4 rpm-pkg
> - make -j4 binrpm-pkg
> - KBUILD_OUTPUT=../builds/amd64 make -j4 binrpm-pkg
> 
> For all three the contents of the resulting binary RPM package was 
> identical
> (and looked correct); the source RPM package from the first build looked 
> sane.
> 
> A 'KBUILD_OUTPUT=../builds/amd64 make -j4 rpm-pkg' fails as intended.
> 
> One open issue is that the following commands should IIUC be identical,
> but the second one does not work:
> - KBUILD_OUTPUT=../builds/amd64 make -j4 binrpm-pkg
> - make -j4 O=../builds/amd64 binrpm-pkg
> 
> AFAICT the root Makefile is supposed to set KBUILD_OUTPUT based on O=, but
> that is not visible when the lines within the binrpm-pkg target are 
> executed.
> My make foo was not strong enough to debug this. Sam, do you know?

I did not look into this - there is too much other stuff pending.

	Sam
