Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbYFBKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbYFBKB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757960AbYFBKAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:00:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:17513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908AbYFBKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=fpJSAdy17iSueSEa8wTPo9Ro7qL1St6c02A3toMwPYi7SzYPO5QfCWoLjJP6HwNF+C
         DMHCvjfoAn9ecEOzriY5lfS97q6wTnIWhN1XNWjT4FrhoquO1kKEjruI/I2aBes6RjpF
         x/K4EIvtzcyu6GJaOc0MVxqD3E5LO+mbpu5fY=
Message-ID: <900048340806020300pf0db974k8318162a442968a2@mail.gmail.com>
Date: Mon, 2 Jun 2008 12:00:19 +0200
From: "Jiri Hladky" <hladky.jiri@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Bug in arch/i386/lib/delay.c file, delay_loop function
Cc: linux-kernel@vger.kernel.org, "Martin Mares" <mj@ucw.cz>
In-Reply-To: <mj+md-20080601.170340.5225.albireo@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1640_31759455.1212400819200"
References: <900048340805300815u57af94b0i3971b22a9d154d1f@mail.gmail.com>
	 <mj+md-20080601.170340.5225.albireo@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_1640_31759455.1212400819200
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Ingo, hi Martin!

As Martin correctly pointed out, my code will fail when loops=0. So I
have added a fix for this.

The patch file is attached:

diff -up arch/x86/lib/delay_32.c-orig arch/x86/lib/delay_32.c > delay_32.c_patch

I'm attaching also both kernel source codes (delay_32.c-orig and
delay_32.c) for reference.

Thanks
Jiri

On Sun, Jun 1, 2008 at 7:05 PM, Martin Mares <mj@ucw.cz> wrote:
> Hi!
>
>> when trying to understand how Bogomips are implemented I have found
>> bug in arch/i386/lib/delay.c file, delay_loop function
> [...]
>
>> The function fails for loops > 2^31+1. It because SF is set when dec
>> returns numbers > 2^31
>>
>> The fix is to use jnz instruction instead of jns (and add one decl
>> instruction to the end to have exactly the same number of loops as in
>> original version):
>
> It is a long time since I have hacked that file, but you should definitely
> make sure that the function is never called with a zero argument. In such
> case, the original version made just a single pass, but your version
> makes 2^32 of them.
>
>                                Have a nice fortnight
> --
> Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
> Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
> Homo homini lupus, frater fratri lupior, bohemus bohemo lupissimus.
>

------=_Part_1640_31759455.1212400819200
Content-Type: application/octet-stream; name=delay_32.c_patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgyw4etz0
Content-Disposition: attachment; filename=delay_32.c_patch

LS0tIGFyY2gveDg2L2xpYi9kZWxheV8zMi5jLW9yaWcJMjAwOC0wNS0zMSAyMzo0NDozNC4wMDAw
MDAwMDAgKzAyMDAKKysrIGFyY2gveDg2L2xpYi9kZWxheV8zMi5jCTIwMDgtMDYtMDIgMTE6NTU6
NTAuMDAwMDAwMDAwICswMjAwCkBAIC0zLDYgKzMsNyBAQAogICoKICAqCUNvcHlyaWdodCAoQykg
MTk5MyBMaW51cyBUb3J2YWxkcwogICoJQ29weXJpZ2h0IChDKSAxOTk3IE1hcnRpbiBNYXJlcyA8
bWpAYXRyZXkua2FybGluLm1mZi5jdW5pLmN6PgorICoJQ29weXJpZ2h0IChDKSAyMDA4IEppcmkg
SGxhZGt5IDxobGFka3kgX2RvdF8gamlyaSBfYXRfIGdtYWlsIF9kb3RfIGNvbT4KICAqCiAgKglU
aGUgX19kZWxheSBmdW5jdGlvbiBtdXN0IF9OT1RfIGJlIGlubGluZWQgYXMgaXRzIGV4ZWN1dGlv
biB0aW1lCiAgKglkZXBlbmRzIHdpbGRseSBvbiBhbGlnbm1lbnQgb24gbWFueSB4ODYgcHJvY2Vz
c29ycy4gVGhlIGFkZGl0aW9uYWwKQEAgLTI4LDE2ICsyOSwzMiBAQAogLyogc2ltcGxlIGxvb3Ag
YmFzZWQgZGVsYXk6ICovCiBzdGF0aWMgdm9pZCBkZWxheV9sb29wKHVuc2lnbmVkIGxvbmcgbG9v
cHMpCiB7Ci0JaW50IGQwOwotCi0JX19hc21fXyBfX3ZvbGF0aWxlX18oCi0JCSJcdGptcCAxZlxu
IgotCQkiLmFsaWduIDE2XG4iCi0JCSIxOlx0am1wIDJmXG4iCi0JCSIuYWxpZ24gMTZcbiIKLQkJ
IjI6XHRkZWNsICUwXG5cdGpucyAyYiIKLQkJOiI9JmEiIChkMCkKLQkJOiIwIiAobG9vcHMpKTsK
Ky8qCisgKiBUcmFuc2xhdGVzIHRvCisjQVBQCisJdGVzdCAlZWF4LCVlYXgKKwlqeiAzZgorCWpt
cCAxZgorLmFsaWduIDE2CisxOiAgICAgIGptcCAyZgorLmFsaWduIDE2CisyOiAgICAgIGRlY2wg
JWVheAorICAgICAgICBqbnogMmIKKzM6CQkJZGVjbCAlZWF4CisjTk9fQVBQCisqLworX19hc21f
XyBfX3ZvbGF0aWxlX18oCisgICAgICAgInRlc3QgJTAsJTBcbiIKKyAgICAgICAiXHRqeiAzZlxu
IgorICAgICAgICJcdGptcCAxZlxuIgorICAgICAgICIuYWxpZ24gMTZcbiIKKyAgICAgICAiMTpc
dGptcCAyZlxuIgorICAgICAgICIuYWxpZ24gMTZcbiIKKyAgICAgICAiMjpcdGRlY2wgJTBcblx0
am56IDJiXG4iCisgICAgICAgIjM6XHRkZWNsICUwIgorICAgICAgIDovKndlIGRvbid0IG5lZWQg
b3V0cHV0ICovCisgICAgICAgOiJhIiAobG9vcHMpKTsKK30KIH0KIAogLyogVFNDIGJhc2VkIGRl
bGF5OiAqLwo=
------=_Part_1640_31759455.1212400819200
Content-Type: application/x-bzip2;
 name=linux-2.6.25.4-delay_32.c_patch.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgyw4niu1
Content-Disposition: attachment;
 filename=linux-2.6.25.4-delay_32.c_patch.tar.bz2

QlpoOTFBWSZTWbREDi4ACe7/hd6wAQBf////f/fedP//3/oAAQIAAAhgCg+AAACgZAAAAAAAAMpR
oaEwAmmAAAIZMEwAAAAAAyqn6p4mkx6UfpNCYjEwmRpo0MEwmEGCGABGhwNBpkNNGhhAyGhgjQ0y
aNAMgxAAGhwNBpkNNGhhAyGhgjQ0yaNAMgxAAGhwNBpkNNGhhAyGhgjQ0yaNAMgxAAGgVJEECYgA
TQJ5TU8jInogbRMJijR6mynlPU/TKZHQnJhyvAPT4wwGXAlJQgAEIXEAkCDChxUBCQTJimWqWNWT
urKruVVWrG8mdRVFI6JKkJZYipSUP3NjuVVVVU8q1iqdShSTl5bDtiYY0LqLypL91rqtRgpRSlWp
dSZ81d87ad0qf5YKUypYsosqPu9uDBofq+jNixkfvMmRoUTBWmTXjbVs8Ff4+LXdgtYwfiwdjFjL
vhfe69Ozk3cj892xyKUpKUmHJhbik49VsMt+m+fe0uXjfhrvrNm63V0Y6W9ejU1c+zNio2WKShrC
7irBSUqd+TlgZeuSxE8Bd3lVVVVVVVSlKk+M2H6KFO+7yw6nMcqj4HnWODWVstLUVRSjzvEWmFN3
sWbL1ZY5jJ3Njqfo9x5TpNTpmLkOoyuTYnsTEs9H6tymKUfM1GTrHMomcu1Ho2dbI9b5Xpmpomib
5PPNks6p4WuUso/M2PG1mU1xm8Hl1tUyPq55TwOCYtJkpdReHOpRg0Rsm56Ghi8j5Fp6WiYtUhhN
kn0NziTc0M3mZt00sossxU7Zgs0N8zePmZNTKZtbUspNDcuqKe8xnG2zJ4F3A1HvvPS0lVJVFvWX
qq7m18b5CnoectdUotdUvdVLPSs1zxVVJHlzTmUVSqPCfi8bheFMW10vApd2OlZH3C7jXRpXcTJy
sT3GrBXfVZOtRidM7Ko3Ka1JmcI9jvtbc9Te2tIp0XblNjUyfqzMkyWwK8z1OIT96lFJRSooqfCW
Hg8FkeQpqUpkwDGpVXVMFVVUurScDyOh/j8w/oTBH2PM9WGATJQGrkQQ7JehkHRUs15KZPyS3G9/
QXJ8c+KcDY8azsXU4nkdq863jnwcP0PER0nW45yXiz9y1nwP0aI/VwthezZFGClFLponi60HU+0p
yFnewfFUSdipJNTzSUt9vR6ve+XbqaZT1LE1mySxj5epfOSmUWkw4JL2oscThOFMlzS4ndcwkzk1
Q04c2WEmOB/HO+MrAaVrJwdeWs2sU18StGWktWJlJYl13eWgYSgiopDDZK6ztKeJIDoApfJnll1y
KYQtzCOA3SALa0dsCaFPnigoBkEeAcJ5YDgCC4S0WuNC7LsFomAAvyr7ZNNpM9Wswz0ZWy9DOOS0
x2yWTHHKq1y2uqpGnTzzzssWuqlimdN7wwvmmSYLrPInWOM25cGVmZY8IxUa1Kp6FnvrrVI3MlpN
3NInYp/JTqKU7j3flVYLdxoyeF+s+btqvyHrj+IzOsU0D83/zFg1/is//FR7RqWS7ZOB+I+d/0OC
K3qntH5GLiah7Y1o2SXntGMuNL1jcPY+p8ClPlt3Uuva9LrHxJ4ij5yzcb59KWT4ScTfPYyHcfUU
5PH8lozU8a0spZRSlKNaUof1fetJ6FG5iU3D6yowPhZD7FnpZsk3rM1FKaCx5ZPWczE1OdwNKp/z
I5TCftJvfOTKT0tzOa5PpMaqeaf3lS09xPwHIlynS6BrcLXJR8c2sHGMEg9R9cU1p9jvrSfclFMX
KqHSWeRYsMXUn3yb9tSUmDJtYpSLJypmRi5BtbWYxjXMV5aU4EVN6ktFSGKhZ6lFmZpN7SqeMjen
49tVoaz32iM1LrJZZSx2GpKjfJobFPmYyLTNoU65tkcMxZMS8ynMnM8EwaSOp0KTwnup1TKOdqXZ
PG2NDNGlm/uKa0XH2z/DRLpUh1MU1rLmaYPaogwTifK7ZxzMyll1KUapMJxN8lF3AwM2Tll59nhV
9fdVXbnimGFVja1rWxaJTeNMma7iki6w7yyyDfJO0il3C+FKXd5Z55PK5XKOQ4Jqd6TBok8EHCpz
vC6n1NaNJNkhU5G+djZIYypjP5NJuUkvHQ8T3XpZSm4/CZyGqR/lwtrQ4nS5y0vNs5lmxqPeUnsU
uU0p2TTI55uYI76yyXNsnyKdDrO1IPO0zOU92eZMFzqjGDwTnj/XB+Uwr3CaWbenQkdMe8sUqegs
WWWc7Ejnm1yjlUmh3KnHMZSNEptnG75N7SYznT+DVOQ2E8plNofskUuXlzQwkukao5VHKYxhGiQ1
GcS6kzZy8LsZmycpTasszkNDMaE0xSReZnYnI2ydieJ3SR0OAahmqWMpCmAsjtVCd82zqUg+kczo
PS8y09+ZM1Np2uI1tzJOImcpUc5ZZzrOkWmSy87HcUuwmUSYpynQuOqSmlKKTe4HWxk2JTU+h7qc
LFjKNc6zY+QYz0cZpk2FmTdJUylTXDmn7NbiNTmaZqmTbMWuaGTTMNJSRqlMWY5lJZqNZTUlScRe
QqUukyczok4JGcyGa0nnWoxOkYLTFwtRSxwqmlsUwZrtq7NSxk0DBQUPcSjtc7al5FTc3v4FLuOc
kbpumtJil2mYTSOVOE3niIwJxMXY7XijA2zqcapJuOowc8uwU/aTVP9SbmpolNEhtOWcbiazvJUU
4GRoTJi6G9aS45pNKif0MJ0phMl2o/q+aTmU1Kblp0xwyxJqlRDjFzoOSbDkklVtUFuC13hQn+xd
yRThQkLREDi4
------=_Part_1640_31759455.1212400819200--
