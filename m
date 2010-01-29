Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941Ab0A2Xvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0A2Xvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537Ab0A2Xvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:51:44 -0500
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:50545 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab0A2Xvn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:51:43 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 18:51:43 EST
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: 2.6.32: padlock_sha1 and hmac broken?
Date: Sat, 30 Jan 2010 00:44:15 +0100
User-Agent: KMail/1.9.9
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001300044.15769.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I upgraded some machines with VIA processors from (vanilla) 2.6.31 to 
2.6.32.7.

If I build the kernel 2.6.32.7 with CONFIG_CRYPTO_DEV_PADLOCK_SHA=y and 
padlock supports sha, hmac(sha1) is missing and IPSEC with hmac(sha1) no 
longer is possible.

If padlock does not support sha hmac(sha1) works.

If I build the kernel CONFIG_CRYPTO_DEV_PADLOCK_SHA=n hmac(sha1) works on all 
padlocks (using sha1_generic).

**** Here is the /proc/cpuinfo and /proc/crypto for the case 
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y, padlock supports sha

===================================================================
processor	: 0
vendor_id	: CentaurHauls
cpu family	: 6
model		: 13
model name	: VIA C7 Processor 1000MHz
stepping	: 0
cpu MHz		: 1000.021
cache size	: 128 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge cmov pat clflush 
acpi mmx fxsr sse sse2 tm nx pni est tm2 xtpr rng rng_en ace ace_en ace2 
ace2_en phe phe_en pmm pmm_en
bogomips	: 2000.37
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 32 bits virtual
power management:

===========

name         : rfc3686(ctr(aes))
driver       : rfc3686(ctr(aes-padlock))
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 20
max keysize  : 36
ivsize       : 8
geniv        : seqiv

name         : ctr(aes)
driver       : ctr(aes-padlock)
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : cbc(twofish)
driver       : cbc(twofish-asm)
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(camellia)
driver       : cbc(camellia-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(serpent)
driver       : cbc(serpent-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 0
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(blowfish)
driver       : cbc(blowfish-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 4
max keysize  : 56
ivsize       : 8
geniv        : <default>

name         : cbc(cast5)
driver       : cbc(cast5-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 5
max keysize  : 16
ivsize       : 8
geniv        : <default>

name         : cbc(des3_ede)
driver       : cbc(des3_ede-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 8
geniv        : <default>

name         : cbc(des)
driver       : cbc(des-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : xcbc(aes)
driver       : xcbc(aes-padlock)
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 16
digestsize   : 16

name         : hmac(rmd160)
driver       : hmac(rmd160-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : hmac(md5)
driver       : hmac(md5-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : sha256
driver       : sha256-padlock
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : sha1
driver       : sha1-padlock
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : cbc(aes)
driver       : cbc-aes-padlock
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ecb(aes)
driver       : ecb-aes-padlock
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : aes
driver       : aes-padlock
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : ghash
driver       : ghash-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 16
digestsize   : 16

name         : stdrng
driver       : ansi_cprng
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : rng
seedsize     : 48

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : rng
seedsize     : 0

name         : lzo
driver       : lzo-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

name         : michael_mic
driver       : michael_mic-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 8
digestsize   : 8

name         : zlib
driver       : zlib-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : pcomp

name         : deflate
driver       : deflate-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : salsa20
driver       : salsa20-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 8
geniv        : <default>

name         : seed
driver       : seed-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 16

name         : anubis
driver       : anubis-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 40

name         : khazad
driver       : khazad-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : xeta
driver       : xeta-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : xtea
driver       : xtea-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : tea
driver       : tea-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : arc4
driver       : arc4-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 1
max keysize  : 256

name         : cast6
driver       : cast6-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : cast5
driver       : cast5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 5
max keysize  : 16

name         : camellia
driver       : camellia-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : tnepres
driver       : tnepres-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 0
max keysize  : 32

name         : serpent
driver       : serpent-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 0
max keysize  : 32

name         : twofish
driver       : twofish-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : blowfish
driver       : blowfish-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 4
max keysize  : 56

name         : fcrypt
driver       : fcrypt-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : des3_ede
driver       : des3_ede-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 24
max keysize  : 24

name         : des
driver       : des-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : tgr128
driver       : tgr128-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : tgr160
driver       : tgr160-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : tgr192
driver       : tgr192-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 24

name         : wp256
driver       : wp256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : wp384
driver       : wp384-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 48

name         : wp512
driver       : wp512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 64

name         : sha512
driver       : sha512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 64

name         : sha384
driver       : sha384-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 48

name         : sha256
driver       : sha256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : sha224
driver       : sha224-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 28

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : rmd320
driver       : rmd320-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 40

name         : rmd256
driver       : rmd256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : rmd160
driver       : rmd160-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : rmd128
driver       : rmd128-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : md4
driver       : md4-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : compress_null
driver       : compress_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : digest_null
driver       : digest_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 0

name         : ecb(cipher_null)
driver       : ecb-cipher_null
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 0
max keysize  : 0
ivsize       : 0
geniv        : <default>

name         : cipher_null
driver       : cipher_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 0
max keysize  : 0

name         : salsa20
driver       : salsa20-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 8
geniv        : <default>

name         : twofish
driver       : twofish-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

===================================================================

**** Here is the /proc/crypto for the case CONFIG_CRYPTO_DEV_PADLOCK_SHA=n, 
padlock supports sha

name         : authenc(hmac(sha1),cbc(aes))
driver       : authenc(hmac(sha1-generic),cbc-aes-padlock)
module       : kernel
priority     : 4000
refcnt       : 89
selftest     : passed
type         : aead
async        : yes
blocksize    : 16
ivsize       : 16
maxauthsize  : 20
geniv        : <built-in>

name         : cbc(aes)
driver       : cbc-aes-padlock
module       : kernel
priority     : 400
refcnt       : 89
selftest     : passed
type         : givcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : rfc3686(ctr(aes))
driver       : rfc3686(ctr(aes-padlock))
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 20
max keysize  : 36
ivsize       : 8
geniv        : seqiv

name         : ctr(aes)
driver       : ctr(aes-padlock)
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : cbc(twofish)
driver       : cbc(twofish-asm)
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(camellia)
driver       : cbc(camellia-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(serpent)
driver       : cbc(serpent-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 0
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(blowfish)
driver       : cbc(blowfish-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 4
max keysize  : 56
ivsize       : 8
geniv        : <default>

name         : cbc(cast5)
driver       : cbc(cast5-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 5
max keysize  : 16
ivsize       : 8
geniv        : <default>

name         : cbc(des3_ede)
driver       : cbc(des3_ede-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 8
geniv        : <default>

name         : cbc(des)
driver       : cbc(des-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : xcbc(aes)
driver       : xcbc(aes-padlock)
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 16
digestsize   : 16

name         : hmac(rmd160)
driver       : hmac(rmd160-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : hmac(sha256)
driver       : hmac(sha256-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : hmac(sha1)
driver       : hmac(sha1-generic)
module       : kernel
priority     : 0
refcnt       : 177
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : hmac(md5)
driver       : hmac(md5-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : cbc(aes)
driver       : cbc-aes-padlock
module       : kernel
priority     : 400
refcnt       : 89
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ecb(aes)
driver       : ecb-aes-padlock
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : aes
driver       : aes-padlock
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : ghash
driver       : ghash-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 16
digestsize   : 16

name         : stdrng
driver       : ansi_cprng
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : rng
seedsize     : 48

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : rng
seedsize     : 0

name         : lzo
driver       : lzo-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

name         : michael_mic
driver       : michael_mic-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 8
digestsize   : 8

name         : zlib
driver       : zlib-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : pcomp

name         : deflate
driver       : deflate-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : salsa20
driver       : salsa20-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 8
geniv        : <default>

name         : seed
driver       : seed-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 16

name         : anubis
driver       : anubis-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 40

name         : khazad
driver       : khazad-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : xeta
driver       : xeta-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : xtea
driver       : xtea-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : tea
driver       : tea-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : arc4
driver       : arc4-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 1
max keysize  : 256

name         : cast6
driver       : cast6-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : cast5
driver       : cast5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 5
max keysize  : 16

name         : camellia
driver       : camellia-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : tnepres
driver       : tnepres-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 0
max keysize  : 32

name         : serpent
driver       : serpent-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 0
max keysize  : 32

name         : twofish
driver       : twofish-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : blowfish
driver       : blowfish-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 4
max keysize  : 56

name         : fcrypt
driver       : fcrypt-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : des3_ede
driver       : des3_ede-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 24
max keysize  : 24

name         : des
driver       : des-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : tgr128
driver       : tgr128-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : tgr160
driver       : tgr160-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : tgr192
driver       : tgr192-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 24

name         : wp256
driver       : wp256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : wp384
driver       : wp384-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 48

name         : wp512
driver       : wp512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 64

name         : sha512
driver       : sha512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 64

name         : sha384
driver       : sha384-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 48

name         : sha256
driver       : sha256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : sha224
driver       : sha224-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 28

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 89
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : rmd320
driver       : rmd320-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 40

name         : rmd256
driver       : rmd256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : rmd160
driver       : rmd160-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : rmd128
driver       : rmd128-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : md4
driver       : md4-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : compress_null
driver       : compress_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : digest_null
driver       : digest_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 0

name         : ecb(cipher_null)
driver       : ecb-cipher_null
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 0
max keysize  : 0
ivsize       : 0
geniv        : <default>

name         : cipher_null
driver       : cipher_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 0
max keysize  : 0

name         : salsa20
driver       : salsa20-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 8
geniv        : <default>

name         : twofish
driver       : twofish-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

===================================================================


**** Here is the /proc/cpuinfo and /proc/crypto for the case 
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y, padlock does not support sha

===================================================================
processor	: 0
vendor_id	: CentaurHauls
cpu family	: 6
model		: 9
model name	: VIA Nehemiah
stepping	: 8
cpu MHz		: 1002.228
cache size	: 64 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr cx8 sep mtrr pge cmov pat mmx fxsr sse rng 
rng_en ace ace_en
bogomips	: 2005.97
clflush size	: 32
cache_alignment	: 32
address sizes	: 32 bits physical, 32 bits virtual
power management:

===================================================================

name         : authenc(hmac(sha1),cbc(aes))
driver       : authenc(hmac(sha1-generic),cbc-aes-padlock)
module       : kernel
priority     : 4000
refcnt       : 231
selftest     : passed
type         : aead
async        : yes
blocksize    : 16
ivsize       : 16
maxauthsize  : 20
geniv        : <built-in>

name         : cbc(aes)
driver       : cbc-aes-padlock
module       : kernel
priority     : 400
refcnt       : 231
selftest     : passed
type         : givcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : rfc3686(ctr(aes))
driver       : rfc3686(ctr(aes-padlock))
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 20
max keysize  : 36
ivsize       : 8
geniv        : seqiv

name         : ctr(aes)
driver       : ctr(aes-padlock)
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : cbc(twofish)
driver       : cbc(twofish-asm)
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(camellia)
driver       : cbc(camellia-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(serpent)
driver       : cbc(serpent-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 0
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(blowfish)
driver       : cbc(blowfish-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 4
max keysize  : 56
ivsize       : 8
geniv        : <default>

name         : cbc(cast5)
driver       : cbc(cast5-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 5
max keysize  : 16
ivsize       : 8
geniv        : <default>

name         : cbc(des3_ede)
driver       : cbc(des3_ede-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 8
geniv        : <default>

name         : cbc(des)
driver       : cbc(des-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : xcbc(aes)
driver       : xcbc(aes-padlock)
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 16
digestsize   : 16

name         : hmac(rmd160)
driver       : hmac(rmd160-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : hmac(sha256)
driver       : hmac(sha256-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : hmac(sha1)
driver       : hmac(sha1-generic)
module       : kernel
priority     : 0
refcnt       : 461
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : hmac(md5)
driver       : hmac(md5-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : cbc(aes)
driver       : cbc-aes-padlock
module       : kernel
priority     : 400
refcnt       : 231
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ecb(aes)
driver       : ecb-aes-padlock
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : aes
driver       : aes-padlock
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : ghash
driver       : ghash-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 16
digestsize   : 16

name         : stdrng
driver       : ansi_cprng
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : rng
seedsize     : 48

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : rng
seedsize     : 0

name         : lzo
driver       : lzo-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

name         : michael_mic
driver       : michael_mic-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 8
digestsize   : 8

name         : zlib
driver       : zlib-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : pcomp

name         : deflate
driver       : deflate-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : salsa20
driver       : salsa20-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 8
geniv        : <default>

name         : seed
driver       : seed-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 16

name         : anubis
driver       : anubis-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 40

name         : khazad
driver       : khazad-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : xeta
driver       : xeta-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : xtea
driver       : xtea-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : tea
driver       : tea-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16

name         : arc4
driver       : arc4-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 1
max keysize  : 256

name         : cast6
driver       : cast6-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : cast5
driver       : cast5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 5
max keysize  : 16

name         : camellia
driver       : camellia-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : tnepres
driver       : tnepres-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 0
max keysize  : 32

name         : serpent
driver       : serpent-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 0
max keysize  : 32

name         : twofish
driver       : twofish-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : blowfish
driver       : blowfish-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 4
max keysize  : 56

name         : fcrypt
driver       : fcrypt-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : des3_ede
driver       : des3_ede-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 24
max keysize  : 24

name         : des
driver       : des-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : tgr128
driver       : tgr128-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : tgr160
driver       : tgr160-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : tgr192
driver       : tgr192-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 24

name         : wp256
driver       : wp256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : wp384
driver       : wp384-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 48

name         : wp512
driver       : wp512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 64

name         : sha512
driver       : sha512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 64

name         : sha384
driver       : sha384-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 48

name         : sha256
driver       : sha256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : sha224
driver       : sha224-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 28

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 231
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : rmd320
driver       : rmd320-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 40

name         : rmd256
driver       : rmd256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : rmd160
driver       : rmd160-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : rmd128
driver       : rmd128-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : md4
driver       : md4-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : compress_null
driver       : compress_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : digest_null
driver       : digest_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 0

name         : ecb(cipher_null)
driver       : ecb-cipher_null
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 0
max keysize  : 0
ivsize       : 0
geniv        : <default>

name         : cipher_null
driver       : cipher_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 0
max keysize  : 0

name         : salsa20
driver       : salsa20-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 8
geniv        : <default>

name         : twofish
driver       : twofish-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

============================

Regards
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
