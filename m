Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbYLYR4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbYLYR4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 12:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYLYRz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 12:55:57 -0500
Received: from utl-lnx3.nwu.ac.za ([143.160.36.166]:48048 "EHLO
	utl-lnx3.nwu.ac.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYLYRz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 12:55:56 -0500
Message-Id: <4953E53C.3D93.006F.0@nwu.ac.za>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 25 Dec 2008 19:55:40 +0200
From: "Martin Schlemmer" <Martin.Schlemmer@nwu.ac.za>
To: "Willy Tarreau" <w@1wt.eu>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Initramfs from existing vmlinuz
References: <49518245.3D93.006F.0@nwu.ac.za> <20081223233410.GC6800@1wt.eu>
 <49523B37.3D93.006F.0@nwu.ac.za>
In-Reply-To: <49523B37.3D93.006F.0@nwu.ac.za>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartB79FA00C.1__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartB79FA00C.1__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>>> On 2008/12/24 at 01:37 PM, "Martin Schlemmer" <Martin.Schlemmer@nwu.ac.=
za>
wrote:
>>>> On 2008/12/24 at 01:34 AM, Willy Tarreau <w@1wt.eu> wrote:
>> On Wed, Dec 24, 2008 at 12:28:53AM +0200, Martin Schlemmer wrote:
=20
Hi
=20
>>> I had a bit of an accident, and wondered if somebody already had to =
try to=20
>> extract the initramfs image from an existing vmlinuz?
>>>=20
>>>  I did try google, but either my search terms was not right, or =
nobody=20
>> really touched on the subject before, because all the results mostly =
dealt=20
>> with an external image.
>>>=20
>>> Any advice will be appreciated.
>>=20
>> yes, it happens to me from time to time.
>> You first have to extract and uncompress the ELF image from vmlinuz. =
For
>> this, look for the gzip signature 1F 8B 08 in your vmlinuz, and feed =
all
>> data starting from this point to zcat. Either you do the same on the
>> resulting file -and you may find several compressed images- or you =
simply
>> pass it through "objdump -h". It will show you a .init.ramfs section. =
Use
>> the fourth field as the file offset, and dump from that position. =
You'll
>> find your initramfs, likely starting with 1F 8B 08 since it's supposed
>> to be compressed with gzip.
>>=20
>> You need an hex editor, dd, zcat and objdump for this. It's not much
>> complicated once you have the tools, but it might require a few =
attempts
>> before finding the right image (I tend to find config.gz before =
initramfs).
>>=20
>=20
> Appreciated, I should be able to go from here now - just getting the =
starting=20
> point is sometimes the main issue.
>=20

Simple Perl script to do above in case anybody might find it useful in the =
future.


M



--=__PartB79FA00C.1__=
Content-Type: application/octet-stream; name="extract_initramfs.pl"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="extract_initramfs.pl"

IyEvdXNyL2Jpbi9wZXJsCiMKIyBleHRyYWN0X2luaXRyYW1mcy5wbDogZXh0cmFjdHMgdGhlIGlu
aXRyYW1mcyBvdXQgb2YgYSBwYWNrZWQga2VybmVsIGltYWdlCiMKIyBDb3B5cmlnaHQgKEMpIE1h
cnRpbiBTY2hsZW1tZXIgPGF6YXJhaEBub3NmZXJhdHUuemEub3JnPgojCiMgUmVsZWFzZWQgdW5k
ZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR1BMCiMKCnVzZSBzdHJpY3Q7CnVzZSB3YXJuaW5nczsK
CnVzZSBDd2Q7CnVzZSBFbmNvZGU7CnVzZSBJTzo6RmlsZTsKdXNlIElPOjpQaXBlOwp1c2UgSU86
OlVuY29tcHJlc3M6Okd1bnppcCBxdyAoZ3VuemlwICRHdW56aXBFcnJvcik7CgppZiAoISBkZWZp
bmVkICgkQVJHVlswXSkgJiYgISBkZWZpbmVkICgkQVJHVlsxXSkpIHsKCXByaW50ICJ1c2FnZTog
JDAgVk1MSU5VWiBbVk1MSU5VWF0gW0lOSVRSQU1GU19JTUFHRV1cbiI7CglleGl0ICgxKTsKfQoK
aWYgKCEgLWYgJEFSR1ZbMF0pIHsKCXByaW50ICIkQVJHVlswXSBkb2VzIG5vdCBleGlzdHNcbiI7
CglleGl0ICgxKTsKfQoKbXkgKCRpbnB1dCwkdm1fb3V0cHV0LCRybV9vdXRwdXQpID0gQEFSR1Y7
Cgokdm1fb3V0cHV0ID0gY3dkIC4gJy92bWxpbnV4JywKCWlmICghIGRlZmluZWQgKCR2bV9vdXRw
dXQpIHx8ICR2bV9vdXRwdXQgZXEgJycpOwokcm1fb3V0cHV0ID0gY3dkIC4gJy9pbml0cmFtZnMu
Y3Bpby5neicsCglpZiAoISBkZWZpbmVkICgkcm1fb3V0cHV0KSB8fCAkcm1fb3V0cHV0IGVxICcn
KTsKCmV2YWwgewoJbXkgJGZoID0gSU86OkZpbGUtPm5ldzsKCgkkZmgtPm9wZW4gKCRBUkdWWzBd
KSBvciBkaWUgKCQhKTsKCSRmaC0+YmlubW9kZTsKCglteSAkZGF0YTsKCW15ICRjb3VudCA9IDA7
CgoJZG8gewoJCSRkYXRhID0gJyc7CgoJCSRmaC0+c2VlayAoJGNvdW50KyssIDApIG9yIGRpZSAo
JCEpOwoJCSRmaC0+cmVhZCAoJGRhdGEsIDMpIG9yIGRpZSAoJCEpOwoKCX0gdW50aWwgKCRkYXRh
ID1+IC9eXHh7MUZ9XHh7OEJ9XHh7MDh9JC8gfHwgJGZoLT5lb2YpOwoKCWlmICgkZGF0YSAhfiAv
Xlx4ezFGfVx4ezhCfVx4ezA4fSQvIHx8ICRmaC0+ZW9mKSB7CgkJcHJpbnQgU1RERVJSICJDb3Vs
ZCBub3QgZmluZCBHWklQIG1hcmtlciFcbiI7CgkJZXhpdCAoMSk7Cgl9CgoJJGZoLT5zZWVrICgt
LSRjb3VudCwgMCkgb3IgZGllICgkISk7CgoJJGRhdGEgPSAnJzsKCgl3aGlsZSAoISAkZmgtPmVv
ZikgewoJCW15ICRidWZmZXI7CgoJCSRmaC0+cmVhZCAoJGJ1ZmZlciwgMjA0OCkgb3IgZGllICgk
ISk7CgkJJGRhdGEgLj0gJGJ1ZmZlcjsKCX0KCSRmaC0+Y2xvc2U7CgoJbXkgJGltYWdlOwoKCWd1
bnppcCBcJGRhdGEgPT4gXCRpbWFnZSwKICAgICAgICBvciBkaWUgKCJHdW56aXAgZmFpbGVkOiAk
R3VuemlwRXJyb3JcbiIpOwoKCSRmaC0+b3BlbiAoJHZtX291dHB1dCwgJz4nKSBvciBkaWUgKCQh
KTsKCSRmaC0+YmlubW9kZTsKCSRmaC0+d3JpdGUgKCRpbWFnZSkgb3IgZGllICgkISk7CgkkZmgt
PmNsb3NlOwoKCW15ICRoYXZlX3JhbWZzID0gMDsKCW15ICRwaXBlID0gSU86OlBpcGUtPm5ldyBv
ciBkaWUgKCQhKTsKCgkkcGlwZS0+cmVhZGVyICgnb2JqZHVtcCcsICctaCcsICR2bV9vdXRwdXQp
IG9yIGRpZSAoJCEpOwoKCXdoaWxlIChteSAkbGluZSA9ICRwaXBlLT5nZXRsaW5lKSB7CgkJaWYg
KCRsaW5lID1+IC9eXHMrXGQrXHMrKFxTKylccysoXFMrKVxzK1xTK1xzK1xTK1xzKyhcUyspXHMr
LykgewoJCQlteSAoJHNlY3Rpb24sJHNpemUsJG9mZnNldCkgPSAoJDEsJDIsJDMpOwoKCQkJbmV4
dCBpZiAoJHNlY3Rpb24gbmUgJy5pbml0LnJhbWZzJyk7CgoJCQkkZmgtPm9wZW4gKCRybV9vdXRw
dXQsICc+Jykgb3IgZGllICgkISk7CgkJCSRmaC0+d3JpdGUgKCRpbWFnZSwgaGV4ICgkc2l6ZSks
IGhleCAoJG9mZnNldCkpIG9yIGRpZSAoJCEpOwoJCQkkZmgtPmNsb3NlOwoKCQkJJGhhdmVfcmFt
ZnMgPSAxOwoKCQkJbGFzdDsKCQl9Cgl9CgoJJHBpcGUtPmNsb3NlOwoKCWRpZSAoJ05vIFwnLmlu
aXQucmFtZnNcJyBzZWN0aW9uIGZvdW5kIScpIGlmICghICRoYXZlX3JhbWZzKTsKfTsKaWYgKCRA
KSB7CglwcmludGYgU1RERVJSICIkQFxuIjsKCWV4aXQgKDEpOwp9CgpleGl0ICgwKTsK

--=__PartB79FA00C.1__=--
