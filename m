Return-Path: <linux-kernel-owner+w=401wt.eu-S1764796AbXKPKNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764796AbXKPKNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbXKPKNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:13:08 -0500
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:44885 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342AbXKPKNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:13:06 -0500
Date: Fri, 16 Nov 2007 12:14:46 +0100
From: Andreas Herrmann <aherrman@arcor.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Kconfig: ARCH=x86
Message-ID: <20071116111446.GA16968@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just some minor remarks wrt the commit message for
daa93fab824f2b8c35bd11670c7fab2f32b2de5f - 'x86: enable "make
ARCH=x86"'. (Based on my observations when testing the stuff on 64bit
and 32bit hosts with Linus' tree v2.6.24-rc2-640-g8c08634.)

For randconfig we have now the following behaviour.  (The table shows
whether the resulting configuration is for 32 or 64-bit.)

# make randconfig [ARCH=...] [K64BIT=]

option \ host arch      | 32bit         | 64bit
=====================================================
./.                     | 32bit         | 64bit
ARCH=x86                | 32bit/64bit   | 32bit/64bit
ARCH=x86 K64BIT=n       | 32bit         | 32bit
ARCH=x86 K64BIT=y       | 64bit         | 64bit
ARCH=x86_64             | 64bit         | 64bit
ARCH=x86_64 K64BIT=n    | 32bit         | 32bit
ARCH=x86_64 K64BIT=y    | 64bit         | 64bit

Basically this means if you are addicted to randconfig (like I am) and
want to compile-test the entire range of possible 32-bit _and_ 64-bit
configurations you have to use "ARCH=x86" on te commmand line.

For menuconfig (config, oldconfig, silentoldconfig) we have the
following default selections, depending on whether there exists an old
.config file or not.  Especially this means that the default for
CONFIG_64BIT does not depend on any command line option like "ARCH=x86
K64BIT=y".

option \ host arch      | 32bit         | 64bit
=================================================
                        | (w/o any .config file)
all relevant options    | 32bit         | 64bit
-------------------------------------------------
                        | (with old 32-bit .config)
all relevant options    | 32bit         | 32bit
------------------------+---------------+--------
                        | (with old 64-bit .config)
all relevant options    | 64bit         | 64bit

I don't know whether the above is the desired behaviour. But that's
what I have observed on my machines. And now that I know how it works
I can live with it ;-)

BTW, is the x86 kernel build documented somewhere?
At a first glance I didn't find anything suitable under Documentation/.
Maybe some explanation (like the above) should be added there.


Regards,

Andreas

