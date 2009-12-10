Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbZLJXzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbZLJXzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757937AbZLJXzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:55:13 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:36516 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbZLJXzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:55:12 -0500
Message-ID: <4B218A60.9020302@gmail.com>
Date: Fri, 11 Dec 2009 00:55:12 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: phoronix test,  openssl bad performance
References: <4B213ADD.6010200@gmail.com> <877hsumqpj.fsf@basil.nowhere.org> <4B2187F7.10301@gmail.com>
In-Reply-To: <4B2187F7.10301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 11 Dec 2009 00:55:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/12/2009 00:44, Xose Vazquez Perez a écrit :
> On 12/10/2009 11:03 PM, Andi Kleen wrote:
> 
>> You should probably report that to Fedora through their bugzilla, 
>> it's unlikely to be a linux kernel problem.
> 
> I got *same* results with Fedora kernel as with a _clean_ 2.6.32-kernel.org
> Not a Fedora-kernel problem!

Not a kernel problem anyway, this is a 100% user land workload

Only conclusion is that openssl was not correctly compiled on linux distros,
while/or better compiled on solaris (or its a 64 bit solaris, or test results wrong)


32bit kernel

first build :

time openssl speed rsa4096 -multi 2
...

OpenSSL 0.9.7a Feb 19 2003
built on: Fri Jan 12 09:26:34 EST 2007
options:bn(64,32) md2(int) rc4(idx,int) des(ptr,risc1,16,long) aes(partial) blowfish(idx)
compiler: gcc -fPIC -DZLIB -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -DKRB5_MIT -DOPENSSL_NO_IDEA -DOPENSSL_NO_MDC2 -DOPENSSL_NO_RC5 -DOPENSSL_NO_EC -I/usr/kerberos/include -DL_ENDIAN -DTERMIO -Wall -O2 -g -pipe -m32 -march=i686 -mtune=pentium4 -Wa,--noexecstack -DSHA1_ASM -DMD5_ASM -DRMD160_ASM
available timing options: TIMES TIMEB HZ=100 [sysconf value]
timing function used:
                  sign    verify    sign/s verify/s
rsa 4096 bits 0.041368s 0.000614s     24.2   1628.0


perf report :

# Samples: 1141271
#
# Overhead  Command             Shared Object  Symbol
# ........  .......  ........................  ......
#
    66.53%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_mul_add_words
     9.08%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_sqr_comba8
     7.55%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_add_words
     5.55%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_sub_words
     2.21%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_from_montgomery
     2.19%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_mul_comba8
     1.91%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_sqr_recursive
     1.14%  openssl  /lib/libcrypto.so.0.9.7a  [.] OPENSSL_cleanse
     0.83%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_usub
     0.59%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_copy
     0.38%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_mul_recursive
     0.29%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_cmp_words
     0.25%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_mod_exp_mont_consttime
     0.20%  openssl  /lib/libcrypto.so.0.9.7a  [.] 0x00000000044cb6
     0.12%  openssl  /lib/libcrypto.so.0.9.7a  [.] 0x0000000002b496
     0.11%  openssl  /lib/libcrypto.so.0.9.7a  [.] bn_mul_words
     0.07%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_bin2bn
     0.06%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_CTX_start
     0.06%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_mod_mul_montgomery
     0.06%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_sqr
     0.05%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_CTX_get
     0.04%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_CTX_end
     0.04%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_bn2bin
     0.04%     perf  [kernel]                  [k] __copy_from_user_ll_nozero
     0.03%  openssl  [kernel]                  [k] _spin_lock
     0.03%  openssl  /lib/tls/libc-2.3.4.so    [.] _int_malloc
     0.03%  openssl  [kernel]                  [k] ktime_get
     0.02%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_ucmp
     0.02%  openssl  [kernel]                  [k] update_wall_time
     0.02%  openssl  /lib/libcrypto.so.0.9.7a  [.] BN_mul


Other build (probably uses SSE2) :

OpenSSL 0.9.8k 25 Mar 2009
built on: Thu Oct 29 10:41:08 CET 2009
options:bn(64,32) md2(int) rc4(idx,int) des(ptr,risc1,16,long) aes(partial) idea(int) blowfish(idx)
compiler: gcc -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -DL_ENDIAN -DTERMIO -O3 -fomit-frame-pointer -Wall -DOPENSSL_BN_ASM_PART_WORDS -DOPENSSL_IA32_SSE2 -DSHA1_ASM -DMD5_ASM -DRMD160_ASM -DAES_ASM
available timing options: TIMES TIMEB HZ=100 [sysconf value]
timing function used:
                  sign    verify    sign/s verify/s
rsa 4096 bits 0.028285s 0.000380s     35.4   2631.6


Then, same hardware/machine with 64 bits kernel/openssl :

OpenSSL 0.9.8k 25 Mar 2009
built on: Thu Dec 10 22:02:14 CET 2009
options:bn(64,64) md2(int) rc4(1x,char) des(idx,cisc,16,int) aes(partial) idea(int) blowfish(ptr2)
compiler: gcc -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -m64 -DL_ENDIAN -DTERMIO -O3 -Wall -DMD32_REG_T=int -DOPENSSL_BN_ASM_MONT -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DMD5_ASM -DAES_ASM
available timing options: TIMES TIMEB HZ=100 [sysconf value]
timing function used:
                  sign    verify    sign/s verify/s
rsa 4096 bits 0.017143s 0.000272s     58.3   3673.1
