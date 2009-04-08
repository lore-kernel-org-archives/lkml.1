Return-Path: <linux-kernel-owner+w=401wt.eu-S1763094AbZDHTfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094AbZDHTfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbZDHTf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:35:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4395 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbZDHTf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vNTcq02t1mJPA7TdXhyrHqMVWSs8H4FihgSJtYrcrS3VGUr2et1BQ1FmKiKrxkQdle
         LGwomrjJfq8Mrf/ivntLOoOx3ajgXfJl026LAgAG6jD7yl338txhM9tz3zhuOSItHU0S
         GXM+Z0V/xxRmyUD3CYEsG7dDAywt01QrNJX9o=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 21:35:23 +0200
Message-ID: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com>
Subject: [2.6.30-rc1] device-mapper: table: 254:0: crypt: Error allocating 
	crypto tfm
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, herbert@gondor.apana.org.au,
       davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.30.1

I try mount encrypted partition:
root@zlom:/home/maciek# cryptsetup create secret /dev/sda6
Enter passphrase:
Command failed: device-mapper: reload ioctl failed: Zły argument

"Zły argument"="Bad argument"

Dmesg shows:
[  193.421463] device-mapper: table: 254:0: crypt: Error allocating crypto tfm
[  193.421471] device-mapper: ioctl: error adding target to table
[  193.465318] device-mapper: ioctl: device doesn't appear to be in
the dev hash table

BUT, I try again:
root@zlom:/home/maciek# cryptsetup create secret /dev/sda6
Enter passphrase:
root@zlom:/home/maciek# mount /mnt/sec/
root@zlom:/home/maciek# df -h | grep sec
/dev/mapper/secret     89G   42G   43G  50% /mnt/sec

Then it works.

root@zlom:/home/maciek# cat /proc/crypto
name         : cbc(aes)
driver       : cbc(aes-asm)
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : givcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : cbc(aes)
driver       : cbc(aes-asm)
module       : cbc
priority     : 200
refcnt       : 2
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : aes
driver       : aes-asm
module       : aes_i586
priority     : 200
refcnt       : 2
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-generic
module       : aes_generic
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : rng
seedsize     : 0

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16
descsize     : 88

Any else information is needed?

Config:
http://unixy.pl/maciek/download/kernel/2.6.30-rc1/pc/config-2.6.30-rc1.txt

dmesg:
http://unixy.pl/maciek/download/kernel/2.6.30-rc1/pc/dmesg.txt
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
