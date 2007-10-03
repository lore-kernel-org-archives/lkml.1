Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbXJCS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbXJCS3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXJCS3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:29:40 -0400
Received: from pimtabh1.ms.com ([199.89.64.101]:52642 "EHLO pimtabh1.ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbXJCS3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:29:38 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 14:29:38 EDT
x-mimeole: Produced By Microsoft MimeOLE V6.00.3790.2663
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C805EA.50969A07"
Subject: strange bug with ip multicasting.
Date: Wed, 3 Oct 2007 14:22:11 -0400
Message-ID: <72349780AFF0F849921FF8FFF8075A5007BBD2A5@NYWEXMB25.msad.ms.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Importance: normal
Thread-Topic: strange bug with ip multicasting.
Thread-Index: AcgF5ujhP1hB4OvWTPiD7kx80Hkt4wAAxvxA
From: "Wu, Shao \(IT\)" <Shao.Wu@morganstanley.com>
To: <linux-kernel@vger.kernel.org>
Cc: <swu001@gmail.com>
X-OriginalArrivalTime: 03 Oct 2007 18:22:11.0381 (UTC) FILETIME=[50A92E50:01C805EA]
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.15/RELEASE, bases: 03102007 #400879, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C805EA.50969A07
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Summary: a random hanging bug when receiving multicast datagrams on
2.6.x kernels.
Keywards: hang, networking, kernel, multicast, recv, multicast loopback,
poll hang, select hang
Kernel version: 2.6.x
=20
Full description of the problem:
-----------------------------------------------
 * This simple program demonstrates a bug in Linux kernel 2.6.x releases
(and
 * possibly 2.4 kernels also). I have tested this code on several 2.6
kernels
 * (RHEL 4.4, 4.5, 5.0 releases) all suffering the same bug. On Sun
Solaris 10,
 * however, it always behave correctly.
 *
 * This bug also affects select/poll's behavior as demonstrated in
CASE2.
 *
 * How to reproduce the bug...
 *
 *    Please make sure the multicast group address and the port number
are not
 *    currently in use on your test system. I use group address
239.255.1.1 and
 *    port number 12345 here.  Here are commands you can use to verify:
 *        netstat -gn
 *        netstat -an | grep 12345
 *    If you don't see port 12345 and group address 239.255.1.1 listed,
that is
 *    good.
 *
 * Test scenarios:
 * 1. Run one copy of this program, if you see it's running and
receiving its
 *    own messages, control-C out of it (because that is how it should
behave).
 *    And try again. If you try that a few times, you will see that this
program
 *    will hang on recv() function!  That is an incorrect behavior. This
program
 *    should always receive its own messages.
 *
 * 2. Follow scenario #1 until you get it hanging, open another window,
and run
 *    a second copy of this program. You will see both copies start
running and
 *    can receive each other's messages. That's a correct behavior --
the first
 *    datagram from the second copy takes the first copy of the process
out of
 *    hanging state.

Test program source file is attached. If you can't find the attached C++
source file, please send email to my personal email account at
swu001@gmail.com and I'll send the testing code from there.
--------------------------------------------------------

NOTICE: If received in error, please destroy and notify sender. Sender =
does not intend to waive confidentiality or privilege. Use of this email =
is prohibited when received in error.

------_=_NextPart_001_01C805EA.50969A07
Content-Type: application/octet-stream;
	name="simplemcast.cc"
Content-Transfer-Encoding: base64
Content-Description: simplemcast.cc
Content-Disposition: attachment;
	filename="simplemcast.cc"

Ci8qCiAqIEF1dGhvcjogU2hhbyBBIFd1LiAgc3d1MDAxQGdtYWlsLmNvbQogKiBSZWxlYXNlIHVu
ZGVyIEdQTCBsaWNlbnNlLgogKgogKiBUaGlzIHNpbXBsZSBwcm9ncmFtIGRlbW9uc3RyYXRlcyBh
IGJ1ZyBpbiBMaW51eCBrZXJuZWwgMi42LnggcmVsZWFzZXMgKGFuZAogKiBwb3NzaWJseSAyLjQg
a2VybmVscyBhbHNvKS4gSSBoYXZlIHRlc3RlZCB0aGlzIGNvZGUgb24gc2V2ZXJhbCAyLjYga2Vy
bmVscwogKiAoUkhFTCA0LjQsIDQuNSwgNS4wIHJlbGVhc2VzKSBhbGwgc3VmZmVycmluZyB0aGUg
c2FtZSBidWcuIE9uIFN1biBTb2xhcmlzIDEwLAogKiBob3dldmVyLCBpdCBhbHdheXMgYmVoYXZl
IGNvcnJlY3RseS4KICogCiAqIFRoaXMgYnVnIGFsc28gYWZmZWN0cyBzZWxlY3QvcG9sbCdzIGJl
aGF2aW9yIGFzIGRlbW9uc3RyYXRlZCBpbiBDQVNFMi4KICoKICogSG93IHRvIHJlcHJvZHVjZSB0
aGUgYnVnLi4uICAKICoKICogICAgUGxlYXNlIG1ha2Ugc3VyZSB0aGUgbXVsdGljYXN0IGdyb3Vw
IGFkZHJlc3MgYW5kIHRoZSBwb3J0IG51bWJlciBhcmUgbm90CiAqICAgIGN1cnJlbnRseSBpbiB1
c2Ugb24geW91ciB0ZXN0IHN5c3RlbS4gSSB1c2UgZ3JvdXAgYWRkcmVzcyAyMzkuMjU1LjEuMSBh
bmQKICogICAgcG9ydCBudW1iZXIgMTIzNDUgaGVyZS4gIEhlcmUgYXJlIGNvbW1hbmRzIHlvdSBj
YW4gdXNlIHRvIHZlcmlmeToKICogICAgICAgIG5ldHN0YXQgLWduCiAqICAgICAgICBuZXRzdGF0
IC1hbiB8IGdyZXAgMTIzNDUKICogICAgSWYgeW91IGRvbid0IHNlZSBwb3J0IDEyMzQ1IGFuZCBn
cm91cCBhZGRyZXNzIDIzOS4yNTUuMS4xIGxpc3RlZCwgdGhhdCBpcwogKiAgICBnb29kLgogKgog
KiBUZXN0IHNjZW5hcmlvczoKICogMS4gUnVuIG9uZSBjb3B5IG9mIHRoaXMgcHJvZ3JhbSwgaWYg
eW91IHNlZSBpdCdzIHJ1bm5pbmcgYW5kIHJlY2VpdmluZyBpdHMKICogICAgb3duIG1lc3NhZ2Vz
LCBjb250cm9sLUMgb3V0IG9mIGl0IChiZWNhdXNlIHRoYXQgaXMgaG93IGl0IHNob3VsZCBiZWhh
dmUpLgogKiAgICBBbmQgdHJ5IGFnYWluLiBJZiB5b3UgdHJ5IHRoYXQgYSBmZXcgdGltZXMsIHlv
dSB3aWxsIHNlZSB0aGF0IHRoaXMgcHJvZ3JhbQogKiAgICB3aWxsIGhhbmcgb24gcmVjdigpIGZ1
bmN0aW9uISAgVGhhdCBpcyBhbiBpbmNvcnJlY3QgYmVoYXZpb3IuIFRoaXMgcHJvZ3JhbQogKiAg
ICBzaG91bGQgYWx3YXlzIHJlY2VpdmUgaXRzIG93biBtZXNzYWdlcy4KICoKICogMi4gRm9sbG93
IHNjZW5hcmlvICMxIHVudGlsIHlvdSBnZXQgaXQgaGFuZ2luZywgb3BlbiBhbm90aGVyIHdpbmRv
dywgYW5kIHJ1bgogKiAgICBhIHNlY29uZCBjb3B5IG9mIHRoaXMgcHJvZ3JhbS4gWW91IHdpbGwg
c2VlIGJvdGggY29waWVzIHN0YXJ0IHJ1bm5pbmcgYW5kCiAqICAgIGNhbiByZWNlaXZlIGVhY2gg
b3RoZXIncyBtZXNzYWdlcy4gVGhhdCdzIGEgY29ycmVjdCBiZWhhdmlvciAtLSB0aGUgZmlyc3QK
ICogICAgZGF0YWdyYW0gZnJvbSB0aGUgc2Vjb25kIGNvcHkgdGFrZXMgdGhlIGZpcnN0IGNvcHkg
b2YgdGhlIHByb2Nlc3Mgb3V0IG9mCiAqICAgIGhhbmdpbmcgc3RhdGUuCiAqCiAqIFRvIENvbXBp
bGUgb24gTGludXg6CiAqCWcrKyAtZyAtbyAgdGVzdCBzaW1wbGVtY2FzdC5jYwogKiBUbyBjb21w
aWxlIG9uIFN1biBTb2xhcmlzIDEwOgogKglDQyAtZyAtbyB0ZXN0IHNpbXBsZW1jYXN0LmNjIC1s
c29ja2V0IC1sbnNsIAogKgogKiBUbyBydW4gdGhlIHRlc3QgcHJvZ3JhbToKICoJLi90ZXN0IC1w
b3J0IDEyMzQ1IC1ncnAgMjM5LjI1NS4xLjEKICovCgojaW5jbHVkZSA8c3lzL3NvY2tldC5oPgoj
aW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPG5ldGRiLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4K
I2luY2x1ZGUgPGVycm5vLmg+CgojaWZkZWYJQ0FTRTIKI2luY2x1ZGUgPHN5cy9wb2xsLmg+CiNl
bmRpZgkvKiBDQVNFMiAqLwoKI2luY2x1ZGUgPGlvc3RyZWFtPgojaW5jbHVkZSA8c3RkZXhjZXB0
PgoKdXNpbmcgbmFtZXNwYWNlIHN0ZDsKCgppbnQgCm1zb2NrKGNvbnN0IHN0cnVjdCBzb2NrYWRk
ciAqc2FfKQp7IAoJY29uc3QgaW50CQlvbmUgPSAxOyAKCWNvbnN0IGludAkJc29jayA9IHNvY2tl
dChBRl9JTkVULCBTT0NLX0RHUkFNLCAwKTsKCglzZXRzb2Nrb3B0KHNvY2ssIFNPTF9TT0NLRVQs
IFNPX1JFVVNFQUREUiwgJm9uZSwgc2l6ZW9mKG9uZSkpOwoJYmluZChzb2NrLCBzYV8sIHNpemVv
Zigqc2FfKSk7CgoJdV9jaGFyCQkJdmFsID0gKHVfY2hhcikyMDsKCWNvbnN0IHNvY2tsZW5fdAkJ
bGVuID0gc2l6ZW9mKHZhbCk7CglzdHJ1Y3QgZ3JvdXBfcmVxCXJlcTsKCglpZiAoc2V0c29ja29w
dChzb2NrLCBJUFBST1RPX0lQLCBJUF9NVUxUSUNBU1RfVFRMLCAmdmFsLCBsZW4pIDwgMCkKCQl0
aHJvdyBydW50aW1lX2Vycm9yKHN0cmluZygic2V0c29ja29wdCBUVEwgZmFpbGVkOiAiKSArIHN0
cmVycm9yKGVycm5vKSk7IAoJdmFsID0gMTsKCWlmIChzZXRzb2Nrb3B0KHNvY2ssIElQUFJPVE9f
SVAsIElQX01VTFRJQ0FTVF9MT09QLCAmdmFsLCBsZW4pIDwgMCkKCQl0aHJvdyBydW50aW1lX2Vy
cm9yKHN0cmluZygic2V0c29ja29wdCBMT09QIGZhaWxlZDogIikgKyBzdHJlcnJvcihlcnJubykp
OwoJbWVtc2V0KCZyZXEsIDAsIHNpemVvZihyZXEpKTsKCXJlcS5ncl9pbnRlcmZhY2UgPSAwOwoJ
bWVtY3B5KCZyZXEuZ3JfZ3JvdXAsIHNhXywgc2l6ZW9mKCpzYV8pKTsKCWlmIChzZXRzb2Nrb3B0
KHNvY2ssIElQUFJPVE9fSVAsIE1DQVNUX0pPSU5fR1JPVVAsICZyZXEsIHNpemVvZihyZXEpKSA8
IDApCgkJdGhyb3cgcnVudGltZV9lcnJvcihzdHJpbmcoInNldHNvY2tvcHQgSk9JTl9HUk9VUCBm
YWlsZWQ6ICIpICsgc3RyZXJyb3IoZXJybm8pKTsKCXJldHVybiBzb2NrOwp9CgoKdm9pZApsb29r
dXAoc3RydWN0IHNvY2thZGRyICZzYV8sIGNvbnN0IGNoYXIgKmdycF8sIGNvbnN0IGNoYXIgKnBv
cnRfKQp7IAoJc3RydWN0IGFkZHJpbmZvICpyZXM7IAoJc3RydWN0IGFkZHJpbmZvIGhpbnRzOwoK
CW1lbXNldCgmaGludHMsIDAsIHNpemVvZihoaW50cykpOyAKCWhpbnRzLmFpX2ZhbWlseSA9IEFG
X1VOU1BFQzsgCgloaW50cy5haV9zb2NrdHlwZSA9IFNPQ0tfREdSQU07IAoKCWNvbnN0IGludCAg
ICAgcmMgPSBnZXRhZGRyaW5mbyhncnBfLCBwb3J0XywgJmhpbnRzLCAmcmVzKTsKCglpZiAocmMg
IT0gMCkgeyAKCQl0aHJvdyBydW50aW1lX2Vycm9yKHN0cmluZygiRVJST1I6IENhbid0IHJlc29s
dmUgYWRkcmVzczogIikgKyBncnBfICsgIiAiICsgcG9ydF8pOwoJfQoKCWlmIChyZXMtPmFpX2Fk
ZHJsZW4gPiBzaXplb2Yoc2FfKSkKCQl0aHJvdyBydW50aW1lX2Vycm9yKCJzb2NrYWRkciB0b28g
bGFyZ2UhIik7CgltZW1jcHkoJnNhXywgcmVzLT5haV9hZGRyLCByZXMtPmFpX2FkZHJsZW4pOyAK
CWZyZWVhZGRyaW5mbyhyZXMpOyAKfQoKCnZvaWQKcnVudGVzdChjb25zdCBjaGFyICpncnBfLCBj
b25zdCBjaGFyICpwb3J0XykKeyAKCWNvbnN0IGludAlidWZsZW4gPSAxMDI0OwoJY2hhcgkJcmN2
YnVmW2J1Zmxlbl0sIHNuZGJ1ZltidWZsZW5dOyAKCXN0cnVjdCBzb2NrYWRkcglzYTsKCWNvbnN0
IHBpZF90CXBpZCA9IGdldHBpZCgpOwoKCXNwcmludGYoc25kYnVmLCAidGhpcyBpcyBhIHRlc3Qg
ZnJvbSAlZC4iLCBwaWQpOyAKCWxvb2t1cChzYSwgZ3JwXywgcG9ydF8pOwoKCWNvbnN0IGludAlk
YXRhbGVuID0gc3RybGVuKHNuZGJ1ZikgKyAxOwoJY29uc3QgaW50CXNvY2sgPSBtc29jaygmc2Ep
OwoKI2lmZGVmCUNBU0UyCglzdHJ1Y3QgcG9sbGZkCXBzOwoKCXBzLmZkID0gc29jazsKCXBzLmV2
ZW50cyA9IFBPTExSRE5PUk07CiNlbmRpZgkvKiBDQVNFMiAqLwoJZm9yIChpbnQgaT0wOyBpIDwg
MjA7ICsraSkgeyAKCQljb25zdCBpbnQJeCA9IHNlbmR0byhzb2NrLCBzbmRidWYsIGRhdGFsZW4s
IDAsICZzYSwgc2l6ZW9mKHNhKSk7CgoJCWlmICh4IDwgMCkgCgkJCXRocm93IHJ1bnRpbWVfZXJy
b3Ioc3RyaW5nKCJzZW5kdG8gZmFpbGVkOiAiKSArIHN0cmVycm9yKGVycm5vKSk7CgoJCS8qIAoJ
CSAqIElmIG11bHRpcGxlIGNvcGllcyBvZiB0aGlzIHByb2dyYW0gYXJlIHJ1bm5pbmcsIHdlJ2xs
IG5vdCAKCQkgKiBiZSBhYmxlIHRvIHJlY2VpdmUgYWxsIHRlc3QgbWVzc2FnZXMuLi4uIGJ1dCB0
aGF0J3Mgbm90IG91ciAKCQkgKiB0ZXN0IHNjZW5hcmlvLiAgCgkJICovIAojaWZkZWYJQ0FTRTIK
CQkvLyB1c2UgaW5maW5pdGUgdGltZW91dCAtIHdhbnQgdG8gdGVzdCB0aGUgaGFuZ2luZyBidWcs
IHJlbWVtYmVyPwoJCWlmIChwb2xsKCZwcywgMSwgLTEpID09IDEpIHsKCQkJaWYgKHJlY3Yoc29j
aywgcmN2YnVmLCBidWZsZW4sIDApID4gMCkgewoJCQkJY291dCA8PCBwaWQgPDwgIiBSQ1Y6ICIg
PDwgcmN2YnVmIDw8IGVuZGw7CgkJCX0KCQl9CiNlbHNlCS8qIENBU0UyICovCgkJaWYgKHJlY3Yo
c29jaywgcmN2YnVmLCBidWZsZW4sIDApID4gMCkgeyAKCQkJY291dCA8PCBwaWQgPDwgIiBSQ1Y6
ICIgPDwgcmN2YnVmIDw8IGVuZGw7IAoJCX0gCiNlbmRpZgkvKiBDQVNFMiAqLwoJCXNsZWVwKDEp
OyAKCX0gCn0KCgp2b2lkCnVzYWdlKGNvbnN0IGNoYXIgKnBuYW1lXykKewoJY2VyciA8PCAidXNh
Z2U6ICIgPDwgcG5hbWVfIDw8ICIgLXBvcnQgPHBvcnQ+IC1ncnAgPGdycD4iIDw8IGVuZGw7Cgll
eGl0KC0xKTsKfQoKCmludAptYWluKGludCBhcmdjLCBjb25zdCBjaGFyICphcmd2W10pCnsKCWlm
IChhcmdjIDwgNSkKCQl1c2FnZShhcmd2WzBdKTsKCgljb25zdCBjaGFyCSpwb3J0ID0gMDsKCWNv
bnN0IGNoYXIJKmdycCA9IDA7CgoJZm9yIChpbnQgaT0xOyBpIDwgYXJnYzsgaSsrKSB7CgkJaWYg
KHN0cmNtcCgiLXBvcnQiLCBhcmd2W2ldKSA9PSAwKSB7CgkJCXBvcnQgPSBhcmd2WysraV07CgkJ
fSBlbHNlIGlmIChzdHJjbXAoIi1ncnAiLCBhcmd2W2ldKSA9PSAwKSB7CgkJCWdycCA9IGFyZ3Zb
KytpXTsKCQl9Cgl9CglpZiAoIXBvcnQgfHwgIWdycCkKCQl1c2FnZShhcmd2WzBdKTsKCXRyeSB7
CgkJcnVudGVzdChncnAsIHBvcnQpOwoJfSBjYXRjaCAoY29uc3QgcnVudGltZV9lcnJvciAmZV8p
IHsKCQljZXJyIDw8ICJFUlJPUjogIiA8PCBlXy53aGF0KCkgPDwgZW5kbDsKCX0KCXJldHVybiAw
Owp9Cgo=

------_=_NextPart_001_01C805EA.50969A07--
