Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937Ab0AMQV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0AMQV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827Ab0AMQV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:21:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0AMQVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:21:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=5H8OiWXX8hcA:10 a=Ma5QV-PdUIL6CJJqWDcA:9 a=RC3ojplC6lQh9ijfuTMA:7 a=GyVCG7FdUSaAMW_g5WRCVB7dBQkA:4
X-Cloudmark-Score: 0
X-Originating-IP: 173.168.120.229
Message-ID: <4B4DF321.4040304@tampabay.rr.com>
Date: Wed, 13 Jan 2010 11:21:53 -0500
From: Paul Ward <pinkpan@tampabay.rr.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel bug during compile 2.6.32.3
References: <4B4DF117.2090001@tampabay.rr.com>
In-Reply-To: <4B4DF117.2090001@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Ward wrote:
> I have started with a 2.6.24 kernel and applied patches to 2.6.32.3. I 
> keep getting this message when I do initrd. It will even do it on each 
> version (after patching). I try the next highest patch and get the 
> same.  It does appear to be bad code during a compile, but I don't 
> know what to do with it.
> ======================================
> thebigone:/usr/src/xandros-source-2.6.32#* fakeroot make-kpkg --initrd 
> kernel_image*
> exec make -f /usr/share/kernel-package/ruleset/minimal.mk debian 
> INITRD=YES
> ====== making target minimal_debian [new prereqs: ]======
> This is kernel package version .
> test -d debian || mkdir debian
> test ! -e stamp-building || rm -f stamp-building
> test -f debian/control || sed         -e 's/=V/2.6.31/g'        \
>                 -e 's/=D/2.6.31-10.00.Custom/g'         -e 
> 's/=A/i386/g'  \
>                 -e 's/=SA//g'   -e 's/=L/ /g' \
>                 -e 's/=I//g'                                    \
>                 -e 's/=CV/2.6/g'                       \
>                 -e 's/=M/Unknown Kernel Package Maintainer 
> <unknown@unconfigured.in.etc.kernel-pkg.conf>/g'                        \
>                 -e 's/=ST/linux/g'      -e 's/=B/i386/g'    \
>                          /usr/share/kernel-package/Control > 
> debian/control
> test -f debian/changelog ||  sed -e 's/=V/2.6.31/g'             \
>             -e 's/=D/2.6.31-10.00.Custom/g'        -e 
> 's/=A/i386/g'       \
>             -e 's/=ST/linux/g'     -e 's/=B/i386/g'         \
>             -e 's/=M/Unknown Kernel Package Maintainer 
> <unknown@unconfigured.in.etc.kernel-pkg.conf>/g'                             
> \
>              /usr/share/kernel-package/changelog > debian/changelog
> install -p -m 755 /usr/share/kernel-package/rules debian/rules
> for file in ChangeLog  Control  Control.bin86 config templates.in 
> rules; do                                      \
>             cp -f  /usr/share/kernel-package/$file 
> ./debian/;                               \
>         done
> for dir  in Config docs examples ruleset scripts pkg po;  
> do                                      \
>           cp -af /usr/share/kernel-package/$dir  
> ./debian/;                                 \
>         done
> test -d ./debian/stamps || mkdir debian/stamps
> exec debian/rules  INITRD=YES  kernel_image
> ====== making .config because of Makefile ======
>
> test -f .config || test ! -f .config.save || \
>                             cp -pf .config.save .config
> test -f .config || test ! -f .config || \
>                             cp -pf .config .config
> test -f .config || test ! -f ./debian/config || \
>                             cp -pf ./debian/config  .config
> test -f .config || (echo "*** Need a config file .config" && false)
>
> ====== making target CONFIG-common [new prereqs: testdir]======
>
> ====== making target debian/stamp-conf [new prereqs: ]======
> # work around idiocy in recent kernel versions
> test ! -e scripts/package/builddeb || \
>             mv -f scripts/package/builddeb 
> scripts/package/builddeb.kpkg-dist
> test ! -e scripts/package/Makefile || \
>             (mv -f scripts/package/Makefile 
> scripts/package/Makefile.kpkg-dist && \
>                (echo "# Dummy file "; echo "help:") >  
> scripts/package/Makefile)
> test -d debian || mkdir ./debian
> test ! -e stamp-building || rm -f stamp-building
> test ! -f ./debian || test -f stamp-debian || test -f debian/official || \
>                (rm -rf ./debian && mkdir ./debian)
> test -f stamp-debian  ||                                           \
>           ( test -f debian/official && test -f debian/control) 
> ||          \
>            sed -e 's/=V/2.6.31/g'         -e 
> 's/=D/2.6.31-10.00.Custom/g'        \
>                -e 's/=A/i386/g'   -e 's/=SA//g'  \
>                 -e 's/=L/lilo (>= 19.1) | grub, /g' -e 
> 's/=I/initramfs-tools (>= 0.53) | yaird (>= 0.0.11) | 
> linux-initramfs-tool, /g'     \
>                 -e 's/=CV/2.6/g'                      \
>                 -e 's/=M/Unknown Kernel Package Maintainer 
> <unknown@unconfigured.in.etc.kernel-pkg.conf>/g'                       \
>                 -e 's/=ST/linux/g'      -e 's/=B/i386/g'   \
>                          /usr/share/kernel-package/Control> debian/control
> test -f stamp-debian  ||    test -f debian/official ||                \
>            sed -e 's/=V/2.6.31/g' -e 
> 's/=D/2.6.31-10.00.Custom/g'                   \
>             -e 's/=A/i386/g' -e 's/=M/Unknown Kernel Package 
> Maintainer <unknown@unconfigured.in.etc.kernel-pkg.conf>/g' \
>             -e 's/=ST/linux/g'     -e 's/=B/i386/g'           \
>                 /usr/share/kernel-package/changelog > debian/changelog
> test  -f debian/rules || install -p -m 755 
> /usr/share/kernel-package/rules debian/rules
> test  -f stamp-debian || test -f debian/official ||                     \
>            for file in ChangeLog  Control  Control.bin86 config 
> templates.in rules; do                                      \
>                cp -f  /usr/share/kernel-package/$file 
> ./debian/;                               \
>            done
> test  -f stamp-debian || test -f debian/official ||                     \
>            for dir  in Config docs examples ruleset scripts pkg po;  
> do                                      \
>              cp -af /usr/share/kernel-package/$dir  
> ./debian/;                                 \
>            done
> echo done >  stamp-debian
> echo done >  debian/stamp-conf
> ====== making target CONFIG-common [new prereqs: stamp-conf]======
> This is kernel package version 10.067.
> ====== making target stamp-arch-conf [new prereqs: CONFIG-common]======
>
> ====== making target CONFIG-arch [new prereqs: stamp-arch-conf]======
> ====== making target conf.vars [new prereqs: Makefile .config]======
>
> _/*lib/Kconfig:76:error: found recursive dependency: LIBCRC32C -> 
> CRYPTO_CRC32C -> LIBCRC32C
> make[3]: *** [silentoldconfig] Error 1
> make[2]: *** [silentoldconfig] Error 2*/_
> ====== making target CONFIG-arch [new prereqs: .config conf.vars]======
> This is kernel package version 10.067.
> ====== making target CONFIG/linux-headers-2.6.31 [new prereqs: 
> CONFIG-arch]=====
> -- 

-- 
