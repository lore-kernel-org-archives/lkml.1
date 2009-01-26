Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZAZUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZAZUgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZAZUgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:36:08 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:39539 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZAZUgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:36:05 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Jan 2009 12:36:04 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unexpected cascaded epoll behavior - my mistake or kernel bug
In-Reply-To: <alpine.DEB.1.10.0901261152160.26576@alien.or.mcafeemobile.com>
Message-ID: <alpine.DEB.1.10.0901261235000.26576@alien.or.mcafeemobile.com>
References: <200901230109.55706.pisa@cmp.felk.cvut.cz> <alpine.DEB.1.10.0901241355120.9071@alien.or.mcafeemobile.com> <200901260228.54098.pisa@cmp.felk.cvut.cz> <alpine.DEB.1.10.0901261152160.26576@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-1023696000-1233002164=:26576"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-1023696000-1233002164=:26576
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Mon, 26 Jan 2009, Davide Libenzi wrote:

> On Mon, 26 Jan 2009, Pavel Pisa wrote:
> 
> > Hello Davide,
> > 
> > thanks for fast reply and effort.
> > 
> > I have tested your patch with patched and unpatched 2.6.28.2 kernel.
> > The outputs are attached. The patched kernel passes all your tests.
> > 
> > But I have bad news. My library code does not fall into busy loop
> > after your patching but my FIFO tests do not work even in
> > single level epoll scenario. The strace output is attached as well.
> > I try to do more testing tomorrow. I have returned from weekend trip
> > at the evening today and I have not much time for deeper analysis.
> > 
> > But it looks like write level sensitive events are not triggering
> > for epoll at all. The pipe is not fill by any character and specified
> > timeout is triggered with next message as fail results.
> >   @ pipe #X evptrig wr timeout
> >   @ pipe #X evptrig rd timeout
> >  
> > If you want to test the code on your box, download library
> > 
> > http://cmp.felk.cvut.cz/~pisa/ulan/ul_evpoll-090123.tar.gz
> > 
> > The simple "make" in the top directory should work.
> 
> It'd be really great if you could spare me having to dig into few 
> thousands lines of userspace library code, and you could isolate a little 
> bit better what is the expected result, and the error result.

Never mind, I looked myself and I'm able to replicate it with the simple 
attached test program. Looking into it ...



- Davide


--1795850513-1023696000-1233002164=:26576
Content-Type: TEXT/x-csrc; name=epoll_pipe_pingpong.c
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=epoll_pipe_pingpong.c

LyoNCiAqICBlcG9sbF9waXBlX3Bpbmdwb25nIGJ5IERhdmlkZSBMaWJlbnpp
IChBbm90aGVyIGVwb2xsIGFuZCBwaXBlcyB0ZXN0KQ0KICogIENvcHlyaWdo
dCAoQykgMjAwOSAgRGF2aWRlIExpYmVuemkNCiAqDQogKiAgVGhpcyBwcm9n
cmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0
IGFuZC9vciBtb2RpZnkNCiAqICBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhl
IEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQ0K
ICogIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJz
aW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yDQogKiAgKGF0IHlvdXIgb3B0aW9u
KSBhbnkgbGF0ZXIgdmVyc2lvbi4NCiAqDQogKiAgVGhpcyBwcm9ncmFtIGlz
IGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2Vm
dWwsDQogKiAgYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2
ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YNCiAqICBNRVJDSEFOVEFCSUxJ
VFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUg
dGhlDQogKiAgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUg
ZGV0YWlscy4NCiAqDQogKiAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEg
Y29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UNCiAqICBh
bG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUg
RnJlZSBTb2Z0d2FyZQ0KICogIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBs
ZSBQbGFjZSwgU3VpdGUgMzMwLCBCb3N0b24sIE1BICAwMjExMS0xMzA3ICBV
U0ENCiAqDQogKiAgRGF2aWRlIExpYmVuemkgPGRhdmlkZWxAeG1haWxzZXJ2
ZXIub3JnPg0KICoNCiAqLw0KDQojaW5jbHVkZSA8c3lzL3R5cGVzLmg+DQoj
aW5jbHVkZSA8dW5pc3RkLmg+DQojaW5jbHVkZSA8c3RkaW8uaD4NCiNpbmNs
dWRlIDxzdGRsaWIuaD4NCiNpbmNsdWRlIDxzdHJpbmcuaD4NCiNpbmNsdWRl
IDxlcnJuby5oPg0KI2luY2x1ZGUgPGZjbnRsLmg+DQojaW5jbHVkZSA8c2ln
bmFsLmg+DQojaW5jbHVkZSA8bGltaXRzLmg+DQojaW5jbHVkZSA8cG9sbC5o
Pg0KI2luY2x1ZGUgPHN5cy9lcG9sbC5oPg0KI2luY2x1ZGUgPHN5cy93YWl0
Lmg+DQoNCiNkZWZpbmUgRVBXQUlUX1RJTUVPCSgxICogMTAwMCkNCg0Kc3Rh
dGljIGludCB4ZXBvbGxfY3JlYXRlKGludCBuKSB7DQoJaW50IGVwZmQ7DQoN
CglpZiAoKGVwZmQgPSBlcG9sbF9jcmVhdGUobikpID09IC0xKSB7DQoJCXBl
cnJvcigiZXBvbGxfY3JlYXRlIik7DQoJCWV4aXQoMik7DQoJfQ0KDQoJcmV0
dXJuIGVwZmQ7DQp9DQoNCnN0YXRpYyB2b2lkIHhlcG9sbF9jdGwoaW50IGVw
ZmQsIGludCBjbWQsIGludCBmZCwgc3RydWN0IGVwb2xsX2V2ZW50ICpldnQp
IHsNCglpZiAoZXBvbGxfY3RsKGVwZmQsIGNtZCwgZmQsIGV2dCkgPCAwKSB7
DQoJCXBlcnJvcigiZXBvbGxfY3RsIik7DQoJCWV4aXQoMyk7DQoJfQ0KfQ0K
DQpzdGF0aWMgdm9pZCB4cGlwZShpbnQgKmZkcykgew0KCWlmIChwaXBlKGZk
cykpIHsNCgkJcGVycm9yKCJwaXBlIik7DQoJCWV4aXQoNCk7DQoJfQ0KfQ0K
DQpzdGF0aWMgaW50IHJ1bl90ZXN0KHZvaWQpIHsNCglpbnQgbiwgZXBmZCwg
bG9vcHM7DQoJaW50IHBmZHNbMl07DQoJY2hhciByZGJbMl07DQoJc3RydWN0
IGVwb2xsX2V2ZW50IGV2dCwgZXZ0c1s4XTsNCg0KCWVwZmQgPSB4ZXBvbGxf
Y3JlYXRlKDEpOw0KDQoJeHBpcGUocGZkcyk7DQoNCglmY250bChwZmRzWzBd
LCBGX1NFVEZMLCBmY250bChwZmRzWzBdLCBGX0dFVEZMLCAwKSB8IE9fTk9O
QkxPQ0spOw0KDQoJbWVtc2V0KCZldnQsIDAsIHNpemVvZihldnQpKTsNCg0K
CWV2dC5kYXRhLmZkID0gcGZkc1swXTsNCglldnQuZXZlbnRzID0gRVBPTExJ
TjsNCgl4ZXBvbGxfY3RsKGVwZmQsIEVQT0xMX0NUTF9BREQsIHBmZHNbMF0s
ICZldnQpOw0KDQoJZXZ0LmRhdGEuZmQgPSBwZmRzWzFdOw0KCWV2dC5ldmVu
dHMgPSBFUE9MTE9VVDsNCgl4ZXBvbGxfY3RsKGVwZmQsIEVQT0xMX0NUTF9B
REQsIHBmZHNbMV0sICZldnQpOw0KDQoJZm9yIChsb29wcyA9IDEwMDsgbG9v
cHMgPiAwOyBsb29wcy0tKSB7DQoJCW4gPSBlcG9sbF93YWl0KGVwZmQsIGV2
dHMsIDgsIEVQV0FJVF9USU1FTyk7DQoJCWlmIChuIDw9IDApIHsNCgkJCWZw
cmludGYoc3RkZXJyLCAiQWllZSEhIFdoeSBubyBldmVudHM/IVxuIik7DQoJ
CQlicmVhazsNCgkJfQ0KCQlmb3IgKDsgbiA+IDA7IG4tLSkgew0KCQkJc3Ry
dWN0IGVwb2xsX2V2ZW50ICpwZXZ0ID0gJmV2dHNbbiAtIDFdOw0KDQoJCQlp
ZiAocGV2dC0+ZGF0YS5mZCA9PSBwZmRzWzFdICYmDQoJCQkgICAgcGV2dC0+
ZXZlbnRzICYgRVBPTExPVVQpIHsNCgkJCQlmcHJpbnRmKHN0ZG91dCwgIldy
aXRlIHNpZGUsIHN0cm9uZyBzaWRlIVxuIik7DQoJCQkJd3JpdGUocGZkc1sx
XSwgInciLCAxKTsNCgkJCX0gZWxzZSBpZiAocGV2dC0+ZGF0YS5mZCA9PSBw
ZmRzWzBdICYmDQoJCQkJICAgcGV2dC0+ZXZlbnRzICYgRVBPTExJTikgew0K
CQkJCWZwcmludGYoc3Rkb3V0LCAiUmVhZCBzaWRlLCBzdHJvbmcgc2lkZSFc
biIpOw0KCQkJCXdoaWxlIChyZWFkKHBmZHNbMF0sIHJkYiwgc2l6ZW9mKHJk
YikpID4gMCk7DQoJCQl9DQoJCX0NCgl9DQoNCglyZXR1cm4gMDsNCn0NCg0K
aW50IG1haW4oaW50IGFjLCBjaGFyICoqYXYpIHsNCglyZXR1cm4gcnVuX3Rl
c3QoKTsNCn0NCg0K

--1795850513-1023696000-1233002164=:26576--
