Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbZAUSPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbZAUSPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbZAUSPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:15:31 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:57900 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172AbZAUSP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:15:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=uUdqFQqc/+Md9QwnMsyHudLtvR0DN+TBdygWSSeCddLBBitaQ2Bgv0vzye6nusPhPj
         FGi9lRW/rQgVM2CxKfVupVe817TcdDg7uix9ZsxKYNv6DVGhBTAiIY2BIGE2veqOfqPL
         ZOYJao8rEKRj0AYJcCNSaMmQ5Nma+3TGrzszY=
MIME-Version: 1.0
In-Reply-To: <20090121170423.GJ31253@mit.edu>
References: <576cb9750901210619u3d2abfdclb818f0946f7bc663@mail.gmail.com>
	 <20090121145513.GH31253@mit.edu>
	 <576cb9750901210718u32aa98ecy87e7298a0f3444f@mail.gmail.com>
	 <20090121170423.GJ31253@mit.edu>
Date: Wed, 21 Jan 2009 19:15:26 +0100
Message-ID: <576cb9750901211015g3c8813e6md7c0cdd88b9dada1@mail.gmail.com>
Subject: Re: ext4 no space left
From: Victor Pelt <victor.pelt@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Victor Pelt <victor.pelt@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00504502a30ce5a2c30461022331
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502a30ce5a2c30461022331
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

upgrading to 2.6.29-rc2-git1 did allow me to use most of the space but
i still can't quite use all of it. maybe this is to be expected.
(note: i'm just trying testing now, everything i used to have on my
old partition fits. i'm just trying to understand what exactly is
'full'. it seems the file system is 'holding something back'

i included a dumo of df, df -i and tune2fs -l /dev/hda2
(and partition that has ext4 is the / partition or /dev/hda2)

victor


On Wed, Jan 21, 2009 at 6:04 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Jan 21, 2009 at 04:18:35PM +0100, Victor Pelt wrote:
>> i set the number mounted counter to 31, which forced fsck to run on
>> the next reboot. I rebooted, fsck didn't show any erros, but i still
>> got the no space left error when i tried to copy files to the
>> partition.
>
> OK, if a reboot didn't help, I'll bet I know what happened.  E2fsprogs
> changed the default default inode ratio, which means that number of
> inodes being created is half what it was previously.  If you do a "df
> -i", you'll probably see that you have exhausted the number of inodes
> in the filesystem.
>
> The default inode ratio controlled by /etc/mke2fs.conf, and is
> currently 16k.  That is, it assumes the average size of files on the
> filesystem is at least 16k.  (It previously was 8k.)  For large
> filesystems, this is not a problem; I'm guessing that you have a small
> root filesystem, and probably are using a hard-coded /dev partition,
> so the large number of (zero-length) device files is throwing off the
> average.  If you recreate the filesystem with mke2fs -I 8192, it
> should allow you to copy over all of your files in the root
> filesystem.
>
> Finally, note that we made this change for all ext2/3/4 filesystems,
> so this is not unique to ext4; it's just that you reformatted your
> root filesystem for the first time since upgrading to a newer
> e2fsprogs with the changed default, and you ran into this problem.  If
> there are enough people who are using small root filesystems, maybe
> we'll need to have some adjusted hueristics.  Right now we have
> "floppy" for filesystems less than 3 megs, "small" for filesystems
> less than 512 megs, and every thing else is default.  Maybe we need to
> have a "medium" for filesystems smaller than 10 gigs, perhaps, and use
> a default inode ratio of 8192 for medium-sized filesystems....
>
>                                                - Ted
>

--00504502a30ce5a2c30461022331
Content-Type: application/octet-stream; name=dump
Content-Disposition: attachment; filename=dump
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fq8b8ig10

ZGYKCkZpbGVzeXN0ZW0gICAgICAgICAgIDFLLWJsb2NrcyAgICAgIFVzZWQgQXZhaWxhYmxlIFVz
ZSUgTW91bnRlZCBvbgpyb290ZnMgICAgICAgICAgICAgICAgIDUwNDQxODggICA0NzI1MDA4ICAg
ICA2Mjk0NCAgOTklIC8KL2Rldi9yb290ICAgICAgICAgICAgICA1MDQ0MTg4ICAgNDcyNTAwOCAg
ICAgNjI5NDQgIDk5JSAvCnJjLXN2Y2RpciAgICAgICAgICAgICAgICAgMTAyNCAgICAgICAxMjAg
ICAgICAgOTA0ICAxMiUgL2xpYi9yYy9pbml0LmQKdWRldiAgICAgICAgICAgICAgICAgICAgIDEw
MjQwICAgICAgICA2OCAgICAgMTAxNzIgICAxJSAvZGV2CmNhY2hlZGlyICAgICAgICAgICAgICAg
ICAgNDA5NiAgICAgICAgIDQgICAgICA0MDkyICAgMSUgL2xpYi9zcGxhc2gvY2FjaGUKbm9uZSAg
ICAgICAgICAgICAgICAgICAgNzc2ODA0ICAgICAgICAgMCAgICA3NzY4MDQgICAwJSAvZGV2L3No
bQovZGV2L2hkYTMgICAgICAgICAgICAgMjQ0MTYwMDggIDIyNTQ2MDQwICAgMTg2OTk2OCAgOTMl
IC9vcHQKL2Rldi9oZGE2ICAgICAgICAgICAgIDExNTYwNzY0ICAgOTk3MDIwOCAgIDEwMDMzMDAg
IDkxJSAvaG9tZQp0bXBmcyAgICAgICAgICAgICAgICAgICA3NzY4MDQgICAgICAgICAwICAgIDc3
NjgwNCAgIDAlIC90bXAKdG1wZnMgICAgICAgICAgICAgICAgICAxMzMxMjAwICAgICAgICAgMCAg
IDEzMzEyMDAgICAwJSAvdmFyL3RtcAp0bXBmcyAgICAgICAgICAgICAgICAgICA3NzY4MDQgICAg
ICAgICAwICAgIDc3NjgwNCAgIDAlIC91c3IvcG9ydGFnZS9kaXN0ZmlsZXMKCmRmIC1pCgpGaWxl
c3lzdGVtICAgICAgICAgICAgSW5vZGVzICAgSVVzZWQgICBJRnJlZSBJVXNlJSBNb3VudGVkIG9u
CnJvb3RmcyAgICAgICAgICAgICAgICAzMjA2NDAgIDI2MTk3OCAgIDU4NjYyICAgODIlIC8KL2Rl
di9yb290ICAgICAgICAgICAgIDMyMDY0MCAgMjYxOTc4ICAgNTg2NjIgICA4MiUgLwpyYy1zdmNk
aXIgICAgICAgICAgICAgMTk0MjAxICAgICAgOTQgIDE5NDEwNyAgICAxJSAvbGliL3JjL2luaXQu
ZAp1ZGV2ICAgICAgICAgICAgICAgICAgMTk0MjAxICAgIDE0MjcgIDE5Mjc3NCAgICAxJSAvZGV2
CmNhY2hlZGlyICAgICAgICAgICAgICAxOTQyMDEgICAgICAgMiAgMTk0MTk5ICAgIDElIC9saWIv
c3BsYXNoL2NhY2hlCm5vbmUgICAgICAgICAgICAgICAgICAxOTQyMDEgICAgICAgMSAgMTk0MjAw
ICAgIDElIC9kZXYvc2htCi9kZXYvaGRhMyAgICAgICAgICAgIDIwNjY1NzYgICA1NDE2MSAyMDEy
NDE1ICAgIDMlIC9vcHQKL2Rldi9oZGE2ICAgICAgICAgICAgMTQ2ODgwMCAgNTU5MDg4ICA5MDk3
MTIgICAzOSUgL2hvbWUKdG1wZnMgICAgICAgICAgICAgICAgIDE5NDIwMSAgICAgICA0ICAxOTQx
OTcgICAgMSUgL3RtcAp0bXBmcyAgICAgICAgICAgICAgICAgMTk0MjAxICAgICAgIDEgIDE5NDIw
MCAgICAxJSAvdmFyL3RtcAp0bXBmcyAgICAgICAgICAgICAgICAgMTk0MjAxICAgICAgIDEgIDE5
NDIwMCAgICAxJSAvdXNyL3BvcnRhZ2UvZGlzdGZpbGVzCgp0dW5lMmZzIC1sIC9kZXYvaGRhMgoK
dHVuZTJmcyAxLjQxLjMgKDEyLU9jdC0yMDA4KQpGaWxlc3lzdGVtIHZvbHVtZSBuYW1lOiAgIDxu
b25lPgpMYXN0IG1vdW50ZWQgb246ICAgICAgICAgIDxub3QgYXZhaWxhYmxlPgpGaWxlc3lzdGVt
IFVVSUQ6ICAgICAgICAgIGJkOGRhNTc3LTdiNTgtNDViYy05Yzk0LTgyNTRmNzE4ZTU1YQpGaWxl
c3lzdGVtIG1hZ2ljIG51bWJlcjogIDB4RUY1MwpGaWxlc3lzdGVtIHJldmlzaW9uICM6ICAgIDEg
KGR5bmFtaWMpCkZpbGVzeXN0ZW0gZmVhdHVyZXM6ICAgICAgaGFzX2pvdXJuYWwgZXh0X2F0dHIg
cmVzaXplX2lub2RlIGRpcl9pbmRleCBmaWxldHlwZSBuZWVkc19yZWNvdmVyeSBleHRlbnQgZmxl
eF9iZyBzcGFyc2Vfc3VwZXIgbGFyZ2VfZmlsZSBodWdlX2ZpbGUgdW5pbml0X2JnIGRpcl9ubGlu
ayBleHRyYV9pc2l6ZQpGaWxlc3lzdGVtIGZsYWdzOiAgICAgICAgIHNpZ25lZF9kaXJlY3Rvcnlf
aGFzaCAKRGVmYXVsdCBtb3VudCBvcHRpb25zOiAgICAobm9uZSkKRmlsZXN5c3RlbSBzdGF0ZTog
ICAgICAgICBjbGVhbgpFcnJvcnMgYmVoYXZpb3I6ICAgICAgICAgIENvbnRpbnVlCkZpbGVzeXN0
ZW0gT1MgdHlwZTogICAgICAgTGludXgKSW5vZGUgY291bnQ6ICAgICAgICAgICAgICAzMjA2NDAK
QmxvY2sgY291bnQ6ICAgICAgICAgICAgICAxMjgxMTgzClJlc2VydmVkIGJsb2NrIGNvdW50OiAg
ICAgNjQwNTkKRnJlZSBibG9ja3M6ICAgICAgICAgICAgICA3OTc5NQpGcmVlIGlub2RlczogICAg
ICAgICAgICAgIDU4NjYyCkZpcnN0IGJsb2NrOiAgICAgICAgICAgICAgMApCbG9jayBzaXplOiAg
ICAgICAgICAgICAgIDQwOTYKRnJhZ21lbnQgc2l6ZTogICAgICAgICAgICA0MDk2ClJlc2VydmVk
IEdEVCBibG9ja3M6ICAgICAgMzEyCkJsb2NrcyBwZXIgZ3JvdXA6ICAgICAgICAgMzI3NjgKRnJh
Z21lbnRzIHBlciBncm91cDogICAgICAzMjc2OApJbm9kZXMgcGVyIGdyb3VwOiAgICAgICAgIDgw
MTYKSW5vZGUgYmxvY2tzIHBlciBncm91cDogICA1MDEKRmxleCBibG9jayBncm91cCBzaXplOiAg
ICAxNgpGaWxlc3lzdGVtIGNyZWF0ZWQ6ICAgICAgIFR1ZSBKYW4gMjAgMTU6Mjk6NTggMjAwOQpM
YXN0IG1vdW50IHRpbWU6ICAgICAgICAgIFdlZCBKYW4gMjEgMTk6MzU6NDUgMjAwOQpMYXN0IHdy
aXRlIHRpbWU6ICAgICAgICAgIFdlZCBKYW4gMjEgMTk6MzU6NDUgMjAwOQpNb3VudCBjb3VudDog
ICAgICAgICAgICAgIDEwCk1heGltdW0gbW91bnQgY291bnQ6ICAgICAgMzAKTGFzdCBjaGVja2Vk
OiAgICAgICAgICAgICBXZWQgSmFuIDIxIDAwOjQ5OjUwIDIwMDkKQ2hlY2sgaW50ZXJ2YWw6ICAg
ICAgICAgICAxNTU1MjAwMCAoNiBtb250aHMpCk5leHQgY2hlY2sgYWZ0ZXI6ICAgICAgICAgTW9u
IEp1bCAyMCAwMTo0OTo1MCAyMDA5ClJlc2VydmVkIGJsb2NrcyB1aWQ6ICAgICAgMCAodXNlciBy
b290KQpSZXNlcnZlZCBibG9ja3MgZ2lkOiAgICAgIDAgKGdyb3VwIHJvb3QpCkZpcnN0IGlub2Rl
OiAgICAgICAgICAgICAgMTEKSW5vZGUgc2l6ZToJICAgICAgICAgIDI1NgpSZXF1aXJlZCBleHRy
YSBpc2l6ZTogICAgIDI4CkRlc2lyZWQgZXh0cmEgaXNpemU6ICAgICAgMjgKSm91cm5hbCBpbm9k
ZTogICAgICAgICAgICA4CkRlZmF1bHQgZGlyZWN0b3J5IGhhc2g6ICAgaGFsZl9tZDQKRGlyZWN0
b3J5IEhhc2ggU2VlZDogICAgICAwNGRmOThmYS01ODUxLTRmMjQtYjIzMi1jOGI0NzM4YWVmMGYK
Sm91cm5hbCBiYWNrdXA6ICAgICAgICAgICBpbm9kZSBibG9ja3MK
--00504502a30ce5a2c30461022331--
