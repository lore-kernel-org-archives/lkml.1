Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXIENrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXIENrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbXIENrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:47:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:32305 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbXIENrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=coLVqb7bFxxPE8NZL7160faeAUixOeqUb0rrKT5ki6jfmkiJ8ficrWJu0vXd8Gs5Rct05o928F8on6fITiTmbFv4u4fXzAGI2g+T7di5366RvJzzcHWJ2pHMEzYt1smbhrKEw+Irzb7fnzU2Um/fuL7/Mc20cfrve2sAfPcLy0Q=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: sam@ravnborg.org
Subject: [PATCH 1/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 14:47:00 +0100
User-Agent: KMail/1.9.1
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com>
In-Reply-To: <200709051443.21522.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_UNr3GjjFi//Zw97"
Message-Id: <200709051447.00774.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_UNr3GjjFi//Zw97
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 05 September 2007 14:43, Denys Vlasenko wrote:
> These patches fix section names and add
> CONFIG_DISCARD_UNUSED_SECTIONS. It is not enabled
> unconditionally because only newest binutils have
> ld --gc-sections which is stable enough for kernel use.
> IOW: this is an experimental feature for now.

Part 1: fix section names over entire source (all arches).

Patch is big and boring global s/.text.lock/.text_lock/
type thing.

You can regenerate it using attached
linux-2.6.23-rc4.0.fixname.sh
(e.g. if you need to rebase to later kernel).

--
vda


--Boundary-00=_UNr3GjjFi//Zw97
Content-Type: application/x-shellscript;
  name="linux-2.6.23-rc4.0.fixname.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.0.fixname.sh"

#!/bin/sh

grep -rl '\.data\.percpu\.' .    | xargs -n1 sed 's/\.data\.percpu\./.data_percpu_/g' -i
grep -rl '\.data\.percpu' .      | xargs -n1 sed 's/\.data\.percpu/.data_percpu/g' -i
grep -rl '\.data\.read_mostly' . | xargs -n1 sed 's/\.data\.read_mostly/.data_read_mostly/g' -i
grep -rl '\.data\.cacheline_aligned' . | xargs -n1 sed 's/\.data\.cacheline_aligned/.data_cacheline_aligned/g' -i
grep -rl '\.data\.init' .        | xargs -n1 sed 's/\.data\.init/.data_init/g' -i
grep -rl '\.data\.nosave' .      | xargs -n1 sed 's/\.data\.nosave/.data_nosave/g' -i
grep -rl '\.data\.page_aligned' .| xargs -n1 sed 's/\.data\.page_aligned/.data_page_aligned/g' -i
grep -rl '\.data\.lock_aligned' .| xargs -n1 sed 's/\.data\.lock_aligned/.data_lock_aligned/g' -i
grep -rl '\.data\.init\.refok' . | xargs -n1 sed 's/\.data\.init\.refok/\.data_init_refok/g' -i
grep -rl '\.data\.patch\.' .     | xargs -n1 sed 's/\.data\.patch\./\.data_patch_/g' -i
grep -rl '\.data\.patch' .       | xargs -n1 sed 's/\.data\.patch/\.data_patch/g' -i
grep -rl '\.data\.exit' .        | xargs -n1 sed 's/\.data\.exit/\.data_exit/g' -i
grep -rl '\.data\.idt' .         | xargs -n1 sed 's/\.data\.idt/\.data_idt/g' -i
grep -rl '\.data\.compressed' .  | xargs -n1 sed 's/\.data\.compressed/\.data_compressed/g' -i
grep -rl '\.data\.gate' .        | xargs -n1 sed 's/\.data\.gate/\.data_gate/g' -i

grep -rl '\.bss\.page_aligned' . | xargs -n1 sed 's/\.bss\.page_aligned/.bss_page_aligned/g' -i

grep -rl '\.text\.head' .        | xargs -n1 sed 's/\.text\.head/\.text_head/g' -i
grep -rl '\.text\.init\.refok' . | xargs -n1 sed 's/\.text\.init\.refok/\.text_init_refok/g' -i
grep -rl '\.text\.init' .        | xargs -n1 sed 's/\.text\.init/\.text_init/g' -i
grep -rl '\.text\.start' .       | xargs -n1 sed 's/\.text\.start/\.text_start/g' -i
grep -rl '\.text\.lock\.' .      | xargs -n1 sed 's/\.text\.lock\./\.text_lock_/g' -i
grep -rl '\.text\.lock' .        | xargs -n1 sed 's/\.text\.lock/\.text_lock/g' -i
grep -rl '\.text\.exit' .        | xargs -n1 sed 's/\.text\.exit/\.text_exit/g' -i
grep -rl '\.text\.do_' .         | xargs -n1 sed 's/\.text\.do_/\.text_do_/g' -i
grep -rl '\.text\.sys_' .        | xargs -n1 sed 's/\.text\.sys_/\.text_sys_/g' -i
grep -rl '\.text\.rtsigreturn' . | xargs -n1 sed 's/\.text\.rtsigreturn/\.text_rtsigreturn/g' -i
grep -rl '\.text\.sigreturn' .   | xargs -n1 sed 's/\.text\.sigreturn/\.text_sigreturn/g' -i
grep -rl '\.text\.vsyscall' .    | xargs -n1 sed 's/\.text\.vsyscall/\.text_vsyscall/g' -i
grep -rl '\.text\.compressed' .  | xargs -n1 sed 's/\.text\.compressed/\.text_compressed/g' -i
grep -rl '\.text\.ptr' .         | xargs -n1 sed 's/\.text\.ptr/\.text_ptr/g' -i
grep -rl '\.text\.ivt' .         | xargs -n1 sed 's/\.text\.ivt/\.text_ivt/g' -i

# Not changed by the above:
#
# cris: .text.__*
# powerpc: .data.rel*
# parisc:
#  .data.vmpages : {
#        *(.data.vm0.pmd)
#        *(.data.vm0.pgd)
#        *(.data.vm0.pte)
#        }
# frv: .bss.stack    : { *(.bss) }

--Boundary-00=_UNr3GjjFi//Zw97
Content-Type: application/x-bzip2;
  name="linux-2.6.23-rc4.1.fixname.patch.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.1.fixname.patch.bz2"

QlpoOTFBWSZTWdobsx4AJ/n/gH/+sAB/////f////r////9gSj9777rIOzaC++7MhK2vtXXNVpid
99au87t3u519Nu+c8+dvvnznOxnruZChQj3y77evQ60fX2vhW+lePgW7Pu+Ae3Vvt333b6Ue9u5q
Kvhk3he93Hb7w87bde7XN7ta+t69077p4bOWJKTaSg22exve0d12D7G6Vefbp7bdmq829t97NHhn
munm+DvnU6PT1kuzkffdxT3nr7749PN3citD1e8fe3zTY+imfZfY7b7t66H3y7cO4nfQdXuutHQ9
rNza1fLhJEE0AQAQ0GhqaBqU/ENJ6mk8UbU8p6nlGmnonqNHqeiPUPTQSmgQhCZBNKeE0NU0yfqm
9U2pkeoyaBoBoNAANBoaGgSaSIk0mKbQEyKeTBG1U/SnpjUaekm0nqH6U0wnqPUbRNDBNB6nqBJ6
qSUmKPTU9CMhpo0aZAGgAGgAAABoNAaABEiQkzSnkmTVT9moyg0Keo8o9T9T1NNT1P1MFPUyb0U0
8KekbFAz1IAESRAQBMmgJMmTJkmiJ+k2pMymQ9TZT1APUBoNAA000BPKBzEfdVRSAJ/lWFQiBBYQ
BUqzTWxSVJqUi3S3LBCo1FkAIiAHqB3BYHu6NJVfaMqY0V+0pYqfsZ/d/SX/Y/wf7q9OmCDMNZP2
ndDuTatBQbc1kH+kxyfuL1mn8UD8qvKkNhsKC1aB3uE8YyCxZdEyMgsFZYgt1GEJLqMISfdgQ4uW
Ld+rNFqECJdBI63v/1Gj/bQKn5dgnnimzhx0b6JRUKHL08A8Aw2wDMvT++zaC1CjvdxCCxXMoBmZ
bCwuJBkWR76oKs/+/3UPbvo4ekfQ4HUeohkME+QtG0lGKiCIIuUmhNFo2koxUQRBjgixUQRFNR0M
smFJmZmo6EzFCokznOppSMmJYyVt2pK6rkiKNz45yLMlMlIsXFLSyQhAIBQNG9DEMEQqGEMJhMHF
WDhiEiev7TIZD1FuhFgxD2/hNHxeH6gOCX46B2LwVyLXm89r1yr238fLMhpPX9fu9btMzEXWrLlf
lIVOnt9tnUjuHDDlLEFi0arFERQUU5hKXU2BrOghvg1MFWZKW2oWwRzMxtstK1qKRbaI1GmOIxMa
Falb165t27YpKmJ0PQzzsFqFQOoKgeqEPVCCrgZEmYiExs+lc3MxqS9bnLw3o8hGMJP75ZjCbE/k
IMYmIjt1JpM4vkE12h3KEDsyQmZYAxxa/6eTfehmTTG5fq0EDqo/yjV9lExHo/t11nbbZp8k0Ov8
f1/Tmvb0s6bdbaHz91KckwbJ9OP2Rlk5CuymgqUnhEPHzjB7/jWL3y7Zdnddsc/w3RxtWZOb/3QR
xOLru9bkdkCqfEeX47XrGR3soDSTwrOX85E/pGK39UQzat86gsvwbsILXZca9++wkeJ2jqjFRdZb
dvFIYUYMjfNQaQUGqCIkl1LySH5346jWCOmYnMEMUnQWycBO47p0u0O0Hwhw9MtputHJ/QmmPrlt
ZK9DmdTzzRCwIcLeBHWiIZqTQk+e1PUqk0imXEJ0QJm96qHozyDzj2DL3c3F8mejlyw+++Ko+yqz
GfsKD53EWNU7lgr+qUWo5U3BjXlXAvYKNGrfLWFrfsLsjgfZp0RjdezMrXWDfuf1x1Gioqyqc72q
hPVGmBt+sfkcpt1lObfRh+FSOvhzPIkPmtL249P1sbGDRhZsGCUZsUbihQ4Z3d4yXMbemDRoMXxd
ZnCy5MGMoZVD0Aw89qMx0mG7Cqz9jNOWvBOTPhVUilWGSuHPiqtO7eSxJaBqTMjkU1mzdOUM1QEY
3ZUWTteF3Nvi9zrWDaWkh+V9m88OhozJXF9KqMkS1NPKFVjR88/B3j2LGMKGjp7YZbOmASaViXav
+rg6v+CmPnh154Jsj/VgOE6ViWqMtT8JZ82Tv05afG2WzMO+HltR6db/p0V9Qoa4cS8k9OE/PdE/
Mw43oR7Ow+Pjgh3OO1jDskm87wYgyRsfs0Sr2a9PRSvIqjwJK5u13OQYPh40dFZfpi03bD2h/+94
0wkJS7pMCSPHk/Dvoa2h2xEE8Plzw1FiwbRSsK+3oFPxIGxEUVFhPgTjL0A8HypPOnsDmEDaMKhx
JMZkBfjEhd62kMFTGAwnn1IYXSalYbEZD93i4N9VkmRJli1UZVT186aevmhly0WQbgxrycF9okAT
1pbGbTJjMyNCaDk36rqbGectjlHgzAw+P9X2BmvhTox5nTdNISgSMu3tseY9N+9ZRJ+JDe5Br7aB
wtfN8fVAfjp17eYdfhOVWKxa4J1OPDwmWJgJrYTYo7Pew46MhU1yF01QagIIqgoZQ8sroLx626+/
hPoroV3jdEHgM4nfRsyhYXTuGHaR41kdwYvjTNOk7YdtLJkPX1YWUndmstqaYzDDH2vHrftLLP5T
lk+UtEYwO+lzTPNKJA4UOV8ZTzwcgNue3DPpfl+Lh5vvW9lvr44518mrI/P5czsKfdgXpS21iuXp
hcS2hplRYbtXTw46YfEwuUhPdB98Osb2p4c6Gr0bY88aCRLzSHsl44bqyyytKImd8ssvXzygzTAA
r9AEjIL0REbm1W6JkqRNSRqpS1tyUcjW1AsjCCSKgYgjiIieGAA30oU7li4wLwHZFCiDCCaxKUFf
P55IQpoopCyCCsRkiB/RvLMh+cMRgW+294DAbgVUncfjjlFfzQR+J9xS/KeY1+g/R3J2Dbctla5Z
VbaCKZzMnwhQwwgDp0yZSwGgQHK2A03mRhhXItNN/6N0TtKju8pE2higAPD90fJzHScSpVDicATj
Cdz3UWADxEg+wkQZIQJNyqHvsXlypKRGUKyqgxFpWkJSERxgl9NooD1ZOJAGAAHWFSpxdmXOdLmI
yTMHFkcRIoQSMkn8P9VhD3ff+DtD3d9h9iqq4ZmugDquIaj0+cNRz7nVrpavR82MoB8v09MT1Ugk
AUgEBYR65zO76an8HyA+jpPT16SIj4y0+cICUQf50V/d78r9p4fEl+uPpjyCrU3qu7ELQbB3dwTv
2kERY7mQSk58QRcAZtav1oGZbaaE/IHIgFYoEYyAsUBMmEOyAxSXCPd5b6dmh5tFzCsJdvP1zM1t
XYxRxNhvzpVBtFXxbNedJKmay0MHx1zFMapj0euVL6IZgnc18pPXJsqVE4R+Z83smqHN7OUK5HQL
yXP0kvVx5Mfp6Q/HlfAHjhTf2nuDOzMe13OhuLEWlNyTSKPGt6hoE4+u6dW8uIZxZXow6MIf2IyT
0OzoMpjSzp3RhGo1iaQVh3RhXCektQtG9szMuaQyylHb1w9LHLkLIoGzGunS3gbPKfKIA3yVNyKE
OUQqKDCADPL7lAe0ETZzUAW/NSpUVuAFN0KFRXMRm+PwBr6naQ/GeYvQTCz8HN8jsUVURE2Wb3du
xRVR45hJWJ5moyKINgOP+l0nYZqjF6QAh4WlNwAHSPV5sa10dBqIX1coe8hl3ZEsR2HPZtM9vSJA
aZswVUA8jGAlV28jveNew23cvS9DywBXoRNmRLIQWaZEVV7NrkIkQikke8KAeyKAeDt+jq4+aPvR
6OAoB1hfRGwANXUtpxXQmXTblQ2KSmrU6qqqqKlIqNDjnId191On45C4j6aLrnAQtrdoTJRTH3Tk
+AoZrEhoMM83dYXASGAwwwcHjCQt+o0I2PznyCMikkIEhy8PZtk+8IJ+yuH00RDrsNlfDf45VKtq
Vtg0YMEnDKK+U0XyW+a6TIhtDhmOULGHp2UHildMsm/RR0RgqOSqNBbDO5IYSQsWdkqeG7Viephb
aCcD03nidp3sFbI3Qd2DzsdTB70HQRjCEmTD8oTjVKXRab6yaZy4Q+XbCymtGUCIqDEq/cSaEwaQ
xpUIjLlCh5hhYcdA83A2kzSgzMiJf7D5Ao+YfiqHuin0bQTwU7/HBC6dh89Xg3oYSi1bE1wtt9NB
KTL4nA1ch15LHFm662rP3x8UIhVfQDQDKmkAD5M06uyT+9R7v6gQtkAnreyqNT24XQIyD0MRp4ls
D2HhfYjzHVsIFRY4sCwIOy3NyzkMwEjMAOzddbEfDa4Dvf8aOkjGkBpMOkJIfvM2ZRDIdHW8eD5D
qC/SPo+LNRF8kXr5bNdYh44l+8H8VyfJvJt348i4xjGFwfBSVtRvs7z+Xe2rp73IGR+w45y+lz2J
IQjxEULGB4zf53F/mC4cYez93NJ7aS6hs21ltpNTtSUIWGaC72jiac6M+nRUG1oAwXtbYiwgoeST
WRA/IsV1aTlZphjSNLbxlGv34aGxKjEPQaxy3QVXVX23ijp393lEJozDSU/O9Q+0G7JQ/4vW5R37
/644RzOOS57Cb4/bkfijKW79kaIJ7/um6MYpmx29ZOuf5Yb1az4D4gGZhq5Fl1jQyx0spCYZiPq0
kyETJKxybevq7CnnDU7LzPz0uMHcm7vJQjllI0+7xchXP5BzJCtqaGpirn72jx6iWyJVdnh5bd6V
NLGiJtWgeSsfG4oWkQfpKXz5mW4trobbLbiOYGK2YmYtUa5T7sjxOv0bax56O7l3RifwmO48DJif
JSff7FejD7YYju2dkBTGLdBHFCGCBfkc5hTuLaXXSwhGBzWXXypPM5OxyWhszPArf1Vyi01PhVC0
+D5jTHyYlkKaULcJAGsSANEzBj8KCyuNDz1IXeYVrO2moqh6NxhClpeXkaOkuu6Cukxxv9Q0o2WR
hCOUa7fGXGu47TpIJSa55PX+Fb5v3ca+R8UzYNtjn8aN8ITvimh024MfVfijWa7556p6o+Fr3eox
g3g0sP2mff8slnSq2U4hnGraUpu1xk36svh0+Ho82VPDJ4ZFGPEiQvQzQY3H1EVzU8xD37dVnZdQ
Zm2xpDBKRINLbI5EsnNpmaxuzcNX4Dx5Md7uwFWN4QWfe1soyqgk0HNOPj0wJhawyaw3U0yM0IN5
7TSvD8obJiDx4rGOmOVM2ymUZeRHKtuWYvTMx5RsHebubc2reS0of4X6udLSbUYhm72Zj4ZImTfw
huhFbc92611S5HtM8I+++yivU+2h+UDjqBQ0YHp58/g9Huk8e3r7JoSKIqdKX3fBYYAxtlVpqV7L
lzcmri1FRYqi0WijaKK6um4vqy8F8evG3dWokARgxgK80lYsWLFJCVDjMcBQathZQhAl1BXzUX+Z
pMFibTujyA1snBgcg5nEqqQswFGCDKouOPFNPi69O1Xp1mZtMq2Ih8xqfFDOLkU2k1VdakzAIIho
lCGhxhxmhjYhJb/Zkv1Fa9fsiHjYawLi7Tc4PKdA6dAQEP0niHvE84kRD8SXVqBkky02LbpTrm6l
WSTLTRSTFoJ+uwMQylKwKhaUqnTsaZ/N6ehzN7gHwhFiIiqKwRAUNFzRYRKWGhKh9P765kPxEOwI
MKYgcEZxxYEtpC1bIWrQtVVW2SyUULgSAuQJGgyodCB+fuSkePHdfu4JT1T56fVwGhFFmVtZAVGs
hFtbJQnGrOI63pddVdqWm1jW0WI/0Uks7ky36egfzCQjOtAhZaEllslVFIlpD8JkKSMygQstIFiQ
ZbJVRSJaQwyFkkcskKICIDESEAhAMDJzzfIvcU/sCi1kE2gHNCCwmsDjMwOUNn7f0a1CPQaThDOA
/X+2sgkkK6MV89kqMV/yZTK+Ivy+AjJrT+xCG+hxvxPNiJ+valb/3GnmXDijtap7e4o7sDmdgS39
KxfnWTPS/YvZ4wpV1e3poyrkQZm9j+tmbvIWl1Uq/zaAoArFBiftdp/Zs4Vj8mSarxw+sWZ/MrR9
JzHw2+Wb6Voj6rEE25njOdrtk2hvvO/76dY3yYijkhF/gvCajDckzz44Y/Cqw66Y68du7PlodsMa
wQUIJKLqMdptpp8EZUM38CHXTY6NASxFg8kjjvDs7SJICpRYnOqpeogOdeetcLsxpv96+G+lV9V3
x4baH1hP8Ysn9Gjp4gefn58X2SVq7upSrzOmn601iLJrCFyFzAsbeXD95O1cLW6IhuIBzYEguqwo
il3x6SpVAnyruPPFO/FJDTn43RVVDc8327Zl4ZlvUpvpKp62sWkYxZabw8L03o3bLGPSNsAaAhis
zYZZBWBs17f0FGBgidE689HZFC5cbIjIANhAWJcA8cEZFCQRP8RFOsXyi65K+pbWZx7+PwTp89dc
ztE9Siq+VxT4bq+Q/PzD8Xg33+vXr5b0y9rCqitTt46HagjNzc6aoZnKXljmsLKy23V089tmDs6/
F4nH0n6QrCwRQe8zCTIEdcuVRZLJjUgRskZRKS0ptGmaUr1ub1Z00V6blt1111QyTQ2hvGvjdM0x
jP3c13F1rKGbktxzLmsM2ZuZHLGpQtxzWUMuTYXOTWGbM3MjljU02J1yrmXrc5fdbRWRhlohBZGF
tOvle/46fe2BP5UkO8QkR2xQHSD0938lkPWOaggSARQ+goBQJFQD/GkBD3DyZKq+tFB9iAG552fc
Pue5Kd3XMfSfm4VqiKYQ9fkEKOmNKmhAQNmjy/Vzmr8SZr6eD5+whidvH3SzqQub9/c5+hLCcMTi
ZJLviZVKoklDAM2NRMr54EPq462/QapzyDUmRLXJSSXLl28kA4DfX3c/4uP4exn+E1j0+aeazeWx
m1OJznF0TFTNeKh3SHcWKd06gkWqw6esQJ8mDMiZGTRA5GrkTyVd5KhyJmgypRV6kjMw7w5keyne
zDvRWcFrLGm0E02nZNrGtDmjOSctmpgqcW+DWMUs5KxjOLgVWyyz4pFlkzNPT6V3Vi1Dzl8xM1UY
qHhXWE7heMzGBTp1Sea1pa1VLU5mbu3qLMZrEYi5sct7lPqXyo1cp4UvkqnlPNVMJ9VrWk8zNdDg
5h4nd5fm69rMDAe5AfxH4yz9xBVsUAmASgECihQD7wPQbLUuPzig/AFAIgge/b+zEy93XyvWLdOu
pXA9rDMewW3czOHBhZx/kgbg7B3AYPPycCBQFAIUPfwKDgc4cbhyyHE/0jy8ZCEsGh7Tu5woW8ev
NzFGEzCafkq4Zb402TuCx4+roxMSRwG8fDdtx/VvAyrsVPKRiEYwIwYRgRAijMpK+XTjSZLJxOci
30Pcd7RW9Y9luyscuabVdv1zpHchmE5VaUdoaQSANB3KKBoKdiCKbZXwxPprm/krnym6ew9Dljd5
dd60q9qFi+ZoiCqoqM67MwXdvdb1LQJkltw78h1zqBCTMkLZ3Oafflz5TSPkxbpfaBocdC61ADUI
bzAODjgOD7lYMLl7bcp+a1fjTGe/5N6XnYcoChw7V45z2BIb0mJJ06Fm4YawgUmcU3loNXSUXQWl
GNzDDIYokwCZCS2o21SFDGGQwhSlRtLLSlpZmCmAYQiwabja2rKrKkxFMGEGrpKLoKoplKMcJiiT
AJkJLajbbJLYShjDIYQpSo2llpS0szBTAMIMiSzGZJhJuZRMzjm0pTfG7CnFWd7i7RQDByg4kZDG
oW02RxidtsOVqqOO+TFPaLlk7oEVeJb0TnEkDMHDG/Digdc0xYgaM7jDQrEXe5s3NEkDx4P1/QeL
6furdusk67qoIc8ExVNxcRKgdDzC66vqjx7de7sPSxkpWfCx1nXXsKAXuLBkCSEgEiK9tU0xXefV
+NsgW4MOlrPBy3ncGAjodglkogVGMKjGEqvekxWodDzIxoeL24XDGXhhxKaZtog1DKGNnbzpqRZo
YoaZQ4EyTJJhihhMMxhgZiy2S3+suKi6lKsYoaZQwTJMkmGKGEwzGGBmLLZLdFxUXUpVOlq7ygOh
mHQd9xP5hUT++Z/qblAsVkGf6Cz2OIH5mx++wpNlCyMUNtiIxkkgF4VJI/oopJGPxPkegWPvv7Dw
5D1HDCQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVVwA9hA6ISegwOD8FC7w/z/Twttpaq+st1qz
7mUxLjrg4AOgHs7wzCT5u3R+AQk7VK8FK3nzY2Sp1avHqarxeIAAAAAAACT5cZHIFMTeRC5RB0nH
7C/LHuy22cYSZ3varnOcr7Gq9/y9sz47cTPKN1xU8cZvjd9bOuIfbjO6WCTr1259HT2OZNzI0Bvw
sVxzzrnvu2udQtlLwnnbVmtsxvvvJO3Q8huBmOog5AZO8kjgQbFguW77uOJnjkFDNRYZGgbt2skk
A+4hjwIMzNKLjCBDvNpRyIUQOAwd96UajUA2GAsDQB4HAodH83Hl2XUMJKoLq33sfZqvnCdqfpQq
Q1+M2WJM6/8jNfH+UfOfWdNL1Kqj6GsqTtDqoeKarl5o02g7iApxRUDuk9SoWLPUJQTGqDQCOdtH
V8fVl72YYvnSKAVoABt3TXdgUMdCihpyNwtrFiH+r6GpgCgFytDiX1BNQQw8quABY7/bVlj9f/Nj
6scIfzpA8r46eYZ2gR9mc4dMZsDhZaSCaR7Ptd5x7DJMeI44jpsYPZjy0z68ri3IziqEqUYsIGu8
JVszDG4SANIJYWjX2NyCpX8Jxx+E8mYq9SSlPuWqq4QtXktRF9JbohaqrQtVVVfgPr4NGhURehyT
MXLcLfLrpP3AAGbNirqEAyaZqanJaq0t3vZrXpJLbzwe/4kgB9f6g1D+cJ6iicoeKHnxNI2LigYi
gH5qtfCFQt6aVcxvItIRkN2Ocj6FcMNcpVXvMZL6IHIFALAOw/ZLzb02zMwBMpUGiPUS6oZgCiIV
E/IEgBavJbbeSeqGHXwHZiq9h6zvMkXDCJEoEqoxxNho3CXCpGMmCMBTAB6ENpAvYO+cjCfn3pd5
R3kGH6KCHIdpA8pIEgBjFYqsCsgoK05L6RtWMBm7NQxnPpD7B85YFVuZ9AAD4BfEOMYS4OsEOukE
o5gewvBMHOGTi8haqSEOk86pswYK94Td6LMvkM5iTd4cKxFAIWtxEw19h2Od2qvyx6h5SkQ47JHr
9e7d+Npu4m+/L4WHRY3sGYAhBQCIIaZQqpPfv8h9DuDkAHjwNdJOgO7lQQhDAabDCQAxGNLu0tD6
+JOSDrNOxWmlHWQW5HECWzeOajeb2gWEWiOPrGIQIxd3kmlXPQ7o5GTHidzrcPSTCSW4ZPQMwBMr
ydDEyqquUpbdnoPWc8Bxx0MMxVXMqq9NHuAtii8QbAcbxQwooZVFFyGHUXUsk7r4thyrnCtTV07h
b5M/NrwBmAHChTfvwMg56Fjr3de3m66+nrl8ZIFEGfwaWktagKUQHMuXLmFqUbmDcLi1PmOnTP4z
HDGPuyykkk7HCxLHzD4gnv9xh6Hgq+NoXBar3O1dK1o2w2q86oyYYsJISI+bZWoLIkiImHLIyN27
Q1MCFTv26N6MXtOwONqvaVLVVW221EVaZSEHmJfORjOMIPDpZCA6CuwSoOejh1tjmVeLWC9hbBEX
H5afVonefKclDN+HXeA9cL5TOJnrgpQplPicudi8mnwdrVHn7mGTmMe0DgN5e8knQMS6poC/2OOO
BVSVvFAJroCd5CCAAPnHhMeH0SMdjJZtty7Mir9NkSRZZCu57wKGO52QmBDWaYCALtwZndJNhJCA
lcXIico93b6X+D7j24VaM3y0xY9pLEYptr+XN5D2z1bUXcG0nw2+SCfvglRWemguCofFD47fSzIH
HuAA+3nvFGkQLgAUrb6+4UAioBOGlBsP0x+nitMJDHm3fryuMhO3B/Ti+vL8LoGolA48lBZpMNpK
66rG+kycR7Nv58gNr8FlnPeYHT/fYawZDsTHIiDeu01rlK7MHNZmZbGKJAv+T/x1Nc29rJ0QXIId
CwY9yBk8WFTTJCjBk2OZccf48umfpE7/VTXchZ0ofnqa39Pb/m/lDmAB/akIB+sCASCq9MaXtnSs
/D2+78U/D4UlVkfQ/D+oEAbNYIA+gQB/MFEDuB9cnp/7K/aKQX8H9CHxoH1REkFoL2KkEWI7AA5U
/vuBIVSWDn85DDAvw/7qDzpfjUTKyaVnefeZwtQxNZhi+xIFnAX+8/t1DpElZdVqsR/q7h/lhvX8
Q6tyGfhdSgCzLvWgSBKTvEGodXoaQ2inhc2lgN7Bi7ddiHRhv/nLXT2alIYwKCLXQNuidwbP+hiA
YB2xXfqQ1O4jlE04WjwC+mSgHcZFzIkAKP3lrHZQCG9zM968TbwgqloVom05dP8NkqMNTqbo7fBe
cBDybecvqFDYHMm9bXtQwgU2aUdFjmG82a5C9k2BwOA+YFykCC6w9Nii7jZs2BiCljYBXAA4F6O/
YBpFsFlXIzF/hy7BfVSi7BaV1KQcV2qLCug6xtzrA5llc4+IAQwVFqB4EwgVEvk9/RYqwegIaAFn
6r4ff+Bla55HeNu5UXmLvOdrK3QZHtIQjwqCkwcjHqWagX6p+w3vi8ZfWHaEEDf3xF5ij/iCCelM
j+0+fQ3Hz9htO+G+uQ2p0WGgdIP9Ok4bOtHXpV6uYcdpdHPbdMOslu6tqfhuVFyo+oyLgHrwOFQU
kVekPhGl5Q04WhhbS8oXMjcw4yrQya3q5icT+KLigDYjFKhEGRcSORLIABixYJbGEgXlprwLy2MB
iqslzAyALixBhAEyhY09AwUuZAmzDIuddMkhgeJwIqdyq7YpOx4E3BtUXWi/ckqDjoGRXTQPuC7e
rzBjskO5JRMQZPd3AcWSSEhVdLnjAwlwDZEDh73wseeJ9ZHsTqgc4DwHUuDzLvZk7kALmR3F/Heb
BgfAEIvB5Ewt9KMpY9MxMu1yjbxMgl6hRTW5Q3maHkEXgEzHBp+oUA59bXLVbItvDMyjhR6ZetYL
5IZ4AXDhdSHJDg7zo6FniUW0ddhQgbYhoETeR0IPv4PFVYTQeZlDn2BtA2BUWlv5jAaGWlltBrSz
wgjiB1hDU6BROhCZqiOMTsKBPaG5yxlkDrxSGG+kwHOINwmEzkgBIKyqbR5usQhKUzDiuoBkq7tZ
BM7VPChgL+RjslsSQFnr3KDcGLDi+R4ZybdR6ZDnehKVM76KvAUAmSPa4a0n06bzlDj09h47AqYE
U2yfHIp4YnPoXeRDvgHdDMyxLLHMxopVOp0VyTf7kKUiQh0AMTqX2iLPx1D5Tzr+QCvg9AHrwP1R
NIVAjR/f1NezledZLlJn96bhmwKm8yMmAUVG85XZrY6Ii+qUD8pwLw+E9p7O75v8Yfw0xB+J738P
s+jcYURYmC2xcA+LWvnIYPtX9V/xiBzwE9MQVf2DB9w+Eov5DOesvBKPnPIeW9vSQdexLxO1XkVE
9h6SqsA9ZwTMzIdzdBQosplwIdBp+PUQq9pT4MtBmIWkCqyr2WlEkVokaNcrDOTpI71nudPmPasj
LTrszFjAhYScv0E8KmABy2IZHRyrcf23wjouloSL1mLHZaxIKUaytC2ec0Hl47HrC4993732Gp88
qNsZDSUMHaVKgb6VNSYn7TYm5enyE7hfFp+AJhRHAIv4pxBM+1Drj5ow3L5YV7Pv4/N1qr0D8nZ/
giw/IdL9jVAWAKP2N0RSUCqQHG4RSWSn57/Yy5TLUV8BAttjNh1/h3oDZGLFA+1htA1NSyLIjP30
sFgmh0IBgYQKMkKyQoyQrAjZzFznA14koLApwfz+k1r5CqMleVONnK3K00i0mEZFkRKiDIhhIB0f
Ye0fr+3zGggBoJoPTqZ6uRv0CQPmA9Y+Y3YNkIokO6a2Sf55qNkUx9ze2JZbXAY6jiH3gGbwcUlN
ov9H0eQ6fPy8Yf6cOsMTxtFwvF6ga4uh2uchlRPs3/3Qh1dANSnN8tJJPjKh3YtDwILO7mHEDwZL
01tHEjy1f+6S8u4RmUaKirSyQBgM39miegfMzq8hOCwn2vTRCi9t4wo9iXNmaoFWMhXEU5Xy8Lc4
9ciHKFIoKigOswCeXw1fb6TLmniTmMkyRDHqyXDikLTZw3+czXBWIkvZsRSNkCjroRUINMzJ0ISp
7v26UK7SWW+Lp2b1387bEFRfhhXK4f+IagUa7CamffpgVAwMxhy6uile8yEcpNq5Uh9ChSOcN0PN
Rnl188eyqYSTAwzejdjdpC4rf7A89cQSAppxsauYQMRttJ3d0nyBzCd6AcJJPhZgqAxAYfSf5ID6
tRwigId+0kISEo5IQSIMDrVAChU5xXDUPs5O7JVXyMhNkUDAIFjp5ZekQJE9iCCu468XvwPOcxL5
NBcQU4ami6Pynb4wF8tslvGfRhP5Iioidz8QJ8Exh9spiCxIKlymgAZFM4UOzQ1GyRQPqFoOkxpl
f8w9nye2cebknrC+GDIIUyTEhsOuZ42UM0IAVDTXL20X1fKYZCEEhKIZ+sA/zeSpyBU9sBV1w2kC
qi5GplYthaKOh47/bgJueG0A2Pq8d00AHMiugXXWScjbfDfV6ApviiDtNhN6qR/yAts20GM4+ytS
QL0VCG8B+2EnOAJUEFQ2AAeE6uGa3zkTWKN4xpkGjxXP7qNcf2SSE5iAFnjqeIBxkkIAML8w8FNY
CnAY0YDG18h7P13MBEOiHCMQv4hzJD7aAZEBKQwaABjAjeFxy8lN4zDCFMPKGTKt3EcAJeI66kLU
KUwHtfjbl6J35JIc54LUkRLQWIYaFAfK3ie+guROAIBB+2SZgAcaQSfQNIcHiB8Yk7iIer4Dw2tG
qgSFSqp2SRso8r4/Me+RhGHYKAfAcwKActKA1t9/EsYFEJ5mB2EOdJA6SMZCFmshs2EzWVh4LHi8
nv15nd5VcUwNg47JTjxYgMVEb4ajsOn1guqCYqcUCRd+Z0DLHUHcFoYjFSAiMAdhxnr/HQ6OSJwg
KOpmDdd+FCY1iOwIS7KIQIJSMSplpUrKp7Sq5uOu83KlV3BCSSGYPOfd1SuMNveVyhdwYQuAbKtd
95FbyUaq5XIUqtYKNCwX9ugcZhulOwDgcu24be1qJJIwRMwkIANMJCsWQgCwob8x3a6x4TlKUoMZ
97dJp5prAmwQRgjICwBZhViQlIat0wqMETJmZGuZWVLJUoDrNaA0JpqULUNGYGLUGIoC1speby3N
smWEWk2ZTZSW7TcQUWjWNYouV5PK6sgyCkco3RYodRWF2kE6xiWwRgRCZBJIqBUo43aKWmvfh9Jt
TMtHGGXxKEbVe0q7vjZJwBstdXziQk6MUGmKi9gmR1WAOhBEZEUDRoNndueJxOgnOwslAjEqbBxK
4n3GkkSQgeVBzgkgoQihOP7cc2NY75mcxmo2a7sx1DAYzzLgwy4VVSUNIaPujyPy09iO/myghJeQ
BYpKwrRtH3i1t71lZzhzkhTaMNLxj48GeYyIzxNfNNistG8oxUNn8kNR3GN8JgF4KhYKYEQwibhQ
CUbaQdSA8eUaUOGGuzWY41kc3555ZOugM2Z454VbCHHyfCDnZAs8Is2nBC3ptob+yjizGLbCY5l1
zeR82VO788bi4vigNoHMGtd92XPLBMPgi+ZIZFpCLsjHce6QJ4bpEc0lx1WhA/ADwdNQh4hDqZdn
AfsDEDNGaOSx3YGYuqY3W/Zx9lCI4EbFF5kiyIahkuOII8BgUTkAcLN+fObjv9SWqrw3GKZmAG00
2lZStJDJZiZoZJARSQGMIEA3iWLgUJrYyduLZ4wzz32vE7tbqUVJbUGqVKrK2qRVOUNZr31If9S5
ueIPvTfiFnatxNjkF8CP5grfoNrhvgL+ySKIsIazXkFetDsE2EASJJCSGYN/lYeJW+JbvFPjiBl6
dRcldS9phdRcoyIEiSAAbModbcjniAWTMRiG/Dsv2kA4m41z7RNF79yBZfE4llAbKtyCG2kCjefL
3m8NV341IqKfPdnEIWcNJdA5IlIoRM40AdYJRxIz04tEiYVvSFwngF5oevTuPKKu4qgJxUd9/1+K
VwGPN2QknnSdxt4K4GKvvMfbvBPYCg4sWZ+na8duufVu4BzX1Xwg7kYXL3nmiXCd1CJ2kRUxAsBe
zcIUpkqqTkHqibzh4YGPqfbdgpZmObCGjOSbHUHe0KboT1ou+sHKWKaTCEyGR7ucdm1BtvMdQTkz
ImIUte9oJXmWjMBY0x+yewSvWakkkIRhIJgYi/qkioZwaWCCtn65u7yAG0B+ZEO9gdD8vwRtAufY
yCA7haHwDmr3ytW+1pAiuejFoCPHwArwEwrER7rFouCizyPSDkMwDQOySbuYiPosdoeCGArgB0gh
axcyDg4ZgXaR7DY8RflvMVN0knDmMA/Kf7w2Bw1hugnBgB3UEjUYyBYoBocJ3aZmfAegshteH28a
mwwQu6W5YnAMCgHFUHac0074Rz4cdU0APdHUQhYBQKDEysiaJafAwEHj1LSEgqtAQEWCcALiWDRi
JyHXIhxuDSZgsML4D9IXGx+SdTNwD6yBIyCwbaKCMChDR2ggnaWVVVERCsrAMyR4NteUio0Wr+pz
UR3Gx1jtIW3dNpg70JRiRkh5QwDwMHEwAXH77nQJOOQh0+3S80nAeJBIQrobA+lwMEiBDD8nBMwk
WR1314ggEAgVbS/sh4/XFdMpr28JIxo5Q0N27LaoYQPn7huWF2wSjvFDmanAMcEGyIISMGIImVIm
ti/q7X2bqfMMJnod93Sxee/sUHkAfOhNQ7xOPee3DoJ5AjRxc0AN5FWEQkwkMwNsOdNwSLXj3F+t
77zvf3rzwcVjL99TqHcebzd6+ANVLG2WqIIKvkpWMRGDA8pGErA1SpIon7vtMANAalxm01crtrc6
5OWpqgAFZCKjEWQZDQE2SBuU9utiuiQpvZJxdmZmIEhmzgj69QBwKajS4Xl50HARFaTICitYeAP8
Os+ngCIlKB2IySLBEeZFKjBSVKAYLCKAFeY8g8Q0fEeHYozDwCijgvl/nk5HpCRedBUgw2AZ99CU
evErgZHcAbXwKPd1HCAGVVPdJewwjV5y4iMMWu3Ky7nK6VYxCIohGCbQ3huLI4GY8sS6axe1sZuN
snQ8rGgnbXQCbF+qJ/WV1KOYeh66FBVaQhEnsSUEJET/awpO0t81LHlkBgsSSoLAiiUjKqni9HE0
qUYFtvO3XJiQKS2DaTVuq5o5ZCGyN/eJiwSJBZo5u3Z7JCyF4R56XuVBIfzfdcHKF3VE1DYJo2DF
Z3Hfx3Q+z5qfIABqdOhrCdIWcnlbpDVofGamGpWk0NKZlhKnLD4zAIQo6roC1MAZFg6uIa6vC6Q6
gdaw3Fb0agKwzP5CDUwJJlFysUp5+pianU4hfGGWOJt7kDh+7mqgFy1yM+hViCg3roxHmwFAKAA9
gfoE+QJyHPHSncd1BgrtCsCshDzQDjk/AQ8BdIbzof1mJVpIQkIwkORGq+CrgSSF43YWg1jsaNRs
7M8D8vHORyVWeJMzHXx8lbQWpRfxwXp0vjKl7CJ5ZHsDgPLh3by+Le2PkRVKwkrCSROAUYhSSRgl
JiEgeIp2MqLHE/HvKzL213FI0RO0wh7txgHD45ZwkkISQPs7c0TdxpCohpA27v8OidGxVMZsiEbI
WHXi9xk020g2FDWuwADEmBAzJ2IDYzMJRGHFosqB0T+iZoewOUA0H0YkBhhCwIBsgBZWXzvEr62C
eiY79hWtQlreVcnK7ytuTW1xtUYsbRanoaIOqy5gxO8zYpJ+qgAcO6TuJALvRwe666awK7QdFmrY
QXNU53NBjKWSGP7JDkPPhNoKCOzVehUwprJEzDQdnFQ+gRZsNf4I3YMFszDM+zZYJmo/AE5geUX6
Q3Yf8YZEnA0Y2AA3hOCGCgagVMZt9wCQ+8zgZwXbJwKZDX3pWYBcjDgsyBBwQCQBHgKBIqsiqOq7
VVTIcfo/fSFx0WBIsYySSEhoxD68jUUCwvxWIIDAiRgOEESzNDcl43HnNn0HkPfEyPW5vUALnqRj
BIsFKOEGr/TPNjjwA4caI+AIdA5LRgGxRi7agyYU992aKIG7hsskqaSBuCjMiIiYK4O3I0faB941
uoC1FP3kbw4n+QpMYEL0V37FuWLEPzQXQvQ46OIQMVo0N/tSe4jgC4BGAwAdp9ofQEzlIKzTRAbx
wQ73oLAvYt84Baen+4zCsYBb9a0/hgn6cE0BgrZTxVBM4f4wAKqdqAqAjzIL3RIRRX2uZ/OYHn3C
8+oGug5onJefNF5HUWQfLu3baMw/TDbDzq1hvA2DuXWD6Bn+EvvSQBYSPQIYVrV0vrGLrAAKuQNi
oHfcIRIAx/1yb+W8vga4OCd5j3Db67LIYTVLtG+9zvNkNyJj2Qw92ybz3XHhNFTxy/EEgShvk5Kl
7cJOJ/VxwCA4orHmX6MkKcIU9Ht7xD6w5S+0GKJEBkmzYGkUCZTAu3f28NmbPUyCGCY5fGxSpZAz
ghbXOg1OqPSSLDf4CDlov6ocLgndqGYQE2iFBf7d5cJO45znBpoGmgDyLZrddaZNwogbI3XvICUJ
JJJFGy4OrstgTFRnGTvx7OBmDBzoNUOg+0NhqzQR2D0C2n36haDA+4Ma85tOepR5Bb0O3E3U9DHZ
dlGgZKo+2AtzYbQPJE1vDCQNSeQeBcrYRO2ZTQeBpt97pqp7zY7RSl4cGGJJdMlSBOJJvHRZnUli
gqGLQ2+fb+4H6PUPrh3gOa6aEFCQM95+Q2eho1gYc58QjsOeK6lNDoCgEAvjQijmBYKm/GFuToll
uIFyt1golSltcFwPlk7AGHpnvggwGLGMkjGQhAgUCntnAvhwOWgWOG223meTXpdyu+7OeO0AhEia
4rz6BTCFjI56hq5hjzniWEaf/x2OCe7+WUQguWY67g6lQCt4IBYVZaYDoUwJ1juvil2L696GYX0w
CgCBXikCMYRhaqFuFKqlid2woNED8kCE8F8ztQHHO2HYJq4VoidkSHv/DF48WxgFo9zMgxEbsZFD
YVRNtiSWV5IG03G8A0cMCqaANQTELndwd2Tt8RuOyc8wyizJMVFHxPPV91+uc9uSIcTeabfGwosF
rZ+iZuezXia0/11nbNfDYIVs/rOL4reGrA4HEEHVsSI4U5fhm22tgZtjSdk7kOURLWqxazRxrIjF
DnPATG6mWOoC9hhMAIkhY7cvDDkgSIpIXwIJ0OxAHK8imKOR6m+oaTbU+DUukvAwIwIPZuyR84bR
HpYpFIj1qQqEip6aFhxRqm5SItOvMYwEp4lByMMDkHQsYm/CgOpANKw1gwZIkTDlg0X2bO+xtOq0
6S5KpqVTqTXXQ9Jd6nnYzMU35gKtggIGSG22CzY4+8Bc0CYwYtYUewWAwMXwFVmJFpnWwloOo3RZ
tnPalDAQgjQddOLooq7sHdAgcJ0RlkMZGf2beA0aWUdUJh9XDUAIzhF4xA2zEbi1F+uevipgK5UJ
4DoDeZDkQqGUM1WSSAillnEZdtn7Bgp1q5wgDYZWrfKUxrWDGb4mbeTbeXEwqknSsGyaTcAJ1+Ag
kMEgTBT6bj7B6l5ecohn59PAlpQdVzT6HlXiGwR1C0FgVFVQUjE1BK2FlHHYdmFAeiaQPTNl9pZO
Pkn2RlmUNm8FeNVtjgj5SMaFgUbqOJRg0Rvs97m5tON70OTsmuuHhodVwjeWbMVw0JxH3G2bQ3uH
dgoEHgso2TdxY4wmQgvnEIy5MMQmgIRA3LjxxjAIwd3M6ZoWsoRALdwd6IpZC1TR0JJLGLdBshaK
EBjZAKVgWIVTYn1qDkGojMM1mCkmHGoybDcoaWaXCmPldRcLCzMoWzGVlqxyjN/PeIGwKVBd5AWw
cUFROnVgPAfwIgnEvX41Qk0hAu4Q87AUBfXkoxRhIGMACRVKuuTqmh0gq3LAcpJLH1MB6QWEwKSB
gAgOqG1Wo78BsbBv9Q6jZDzGu9JdxXFlO4wN9IcPvJnVBJJwIpRrcmjtphhcrk0BucMhsUTQlEkh
GMIDqHwTYm+ccz9cFD64tt0pxg7CRNSikSKnldHu13Rc9171lKqs+OOWWmJ5CiRWCpqQMOtMiBex
SotonUaPYGwOm9FzIIneRajidhggkIEdO48t9sEwnZp0zGpAL7QQChXagbeJ1icawwrYdeg9Dr11
IBBgIBoYBmQhENQoRwHqcjYEA6KBzXgCX+MVH7AgvJiMoSvfAX98UcOBOnoBLfUPNA6qr0+79ooB
j8DgbLZbKg3RPzAA27q0X1F+fa2RzixLDCB6SHcJARFzIO8B8O86wU7BGQOXKqMyu/srxHIe6yVC
SKGLkymfJSUmYMXBJlAX/JRbMHdjE5znLDm3e6ErtJmbT85nrIWEoDfYEA0QueSIiROYB5jtgce3
he4XvfzD3cDmWAogQhD+1D/3XqQO6BUEZATi9Y0+R76szzeEq5kUBh2gAeHbDbKShyfCiiJsBOhD
KKoiodOhwfdRZadngHkL0T2/yf0rgT6OwookA4vhRYSCbw94XOHAMoIfnICQi3DoCj20UAhAEPrE
PAPIgBCFIXJiUn8c7hIrWAb8UMcFXoQBUMBieoh3+g4RYBpkiN/cbIe98V0PA107cSIVBuoWxANA
2X8H5szMBQPwqwlIEYAsPd2B3fV1sD1g0D5EVRj+xkP62BK2q9VtXZWuLFW4tuKuTSFdvlc6rJoa
v/Zq4tmy2KTbRM0MsBRYpFIEftzMZBJ7fy23PYOiIP0fwpf/xdyRThQkNobsx4A=

--Boundary-00=_UNr3GjjFi//Zw97--
