Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZHYX6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZHYX6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZHYX6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:58:52 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:24509 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZHYX6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=vJKJ4mH8My+V91N+W9d0CDzYZzzB90xEI8SZpHbD6Yp8A4jKYl8QuP7pE7qo0zwjMQ
         un8WC2qahGdgcQ1iVdK+7gC4gEQnLFbz2xdHaA9UDPqdy57y3oXRixCTl2DaloZjQKyb
         UbsfmBozGody5g7I9jlX8/Mo039IDMHEaFMkQ=
Date: Tue, 25 Aug 2009 19:58:52 -0400
From: Celejar <celejar@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: 541835@bugs.debian.org
Subject: crypto configuration / dependencies broken
Message-Id: <20090825195852.1dfacb6c.celejar@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having a pretty bizarre problem with my kernel crypto
configuration.  I need support for a bog standard LUKS (aes /
cbc-essiv:sha256) / cryptsetup installation, but even after I enable
virtually everything in the crypto section of the kernel configs, cbc
fails to load.  All the relevant modules are exist (dm-mod, dm-crypt,
crypto_blkcipher, crypto_algapi, crypto_hash, aes_generic,
sha256_generic), but even after modprobing / insmoding
everything, /proc/crypto shows that aes and sha is there, but not cbc.

The problem has been reproduced (using my kernel config) by Jonas
Meurer, the Debian cryptsetup maintainer, so it's not just me ;).
We've tried numerous different kernel versions in the .30 / .31 range.

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=541835

Does this mean that something else somewhere in the kernel needs to be
configured but isn't, and the necessary dependency isn't properly
declared?

My config is at:
http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=45;filename=config-2.6.31-rc6-lizzie-00042-gb2add73;att=1;bug=541835

[I'm not subscribed to lkml; please cc me on responses]

Celejar
-- 
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

