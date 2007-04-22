Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXDVN3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXDVN3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXDVN3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:29:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbXDVN3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:29:09 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Wrong free clusters count on FAT32
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Sun, 22 Apr 2007 15:28:50 +0200
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it> <8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hfc7X-00010D-09@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18tJ4MC/QDHi9kI+4rHkgmp11+VP8p/sumfOXw
 q+56ObMENzutqiIcKa+mt2DCAnQxT2xkqQP9YxUW1rrpKoOXx6
 LCLDWctj9yyDwMJs5angQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

>>  * Juergen Beisert <juergen127@kreuzholzen.de> dixit:

>>> So the last free sector count is also stored. When mounting this
>>> filesystem you don't need to walk through the whole FAT to calculate
>>> the available space, you can use this "cached" value instead. And this
>>> cached value seems not to be updated in your portable device.
>>
>>     It doesn't, certainly, but Windows doesn't care. Moreover, the
>> device doesn't seem to recalculate the value on every run (unless it
>> does it lightning fast!), so maybe the number is stored elsewhere (the
>> count can be stored in many places as far as I've read, but I don't know
>> the details).

AFAIR it's stored twice on FAT32, once in a backup sector and once in the
superblock or extended superblock (don't remember, I think it was the
extended ~). It's not stored on FAT{12,16}.

>>     A mount option to force walking the FAT and getting the real info
>> could be interesting. That way, it will be only done for certain devices
>> (small disks, for example).
> 
> Yes. It seems that Windows does not update the ->free_clusters correctly.
> Probably, I think the option is good for now. What do you think about
> an attached patch?

Windows _does_ care*, it will pretend the disk to be full. Therefore the
stored value *SHOULD* be updated. (I think your patch does this.)

Recalculating the free space is a nice idea, and modern hardware might be
fast enough to recalculate the value on mount by default. (I didn't try this
for years.) Maybe the default should depend on arch?


About this patch: (news:8cwz8-2fE-13@gated-at.bofh.it)

- usefree is a bad name (I'd suggest recalc_free instead), and your
  description is too cryptic to be understood by a non-linux FAT expert.
- You forgot to update Documentation/
-- 
Never forget: 2 + 2 = 5 for extremely large values of 2. 

Friﬂ, Spammer: NyjnoQ@0S0gJr.7eggert.dyndns.org uh@e.7eggert.dyndns.org
 VnmVge7Vj@3tlxued.7eggert.dyndns.org RggsNsl@al.7eggert.dyndns.org
