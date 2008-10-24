Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYJXP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYJXP3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYJXP3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:29:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:45831 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYJXP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:references:x-google-sender-auth;
        b=ggJddCmZAEZO/a41TtzKs1I5pQfVMoFKfd845znkk4wZ4w34WA31RoGhKdGvZXu+Ml
         aI/m5z15y2nqKqMl1srU7vSwr56Hm9MoDUhvcaxS7nTdAABFEoP8J6+rJLA+iJ5hRj+R
         lAkBQ2Fyrs9NspjGN0aZloGpteYafVTc59uxk=
Message-ID: <37219a840810240829jab70eder1e9172e2a1cfcbdd@mail.gmail.com>
Date: Fri, 24 Oct 2008 11:29:36 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mike Isely" <isely@pobox.com>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2 [USB REGRESSION] (USB -> D_STATE)]
Cc: "Justin Piszcz" <jpiszcz@lucidpixels.com>, "Greg KH" <greg@kroah.com>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Oliver Neukum" <oliver@neukum.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB list" <linux-usb@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810240043000.5947@cnc.isely.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8494_9836254.1224862176401"
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
	 <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net>
	 <20081020172914.GA9624@kroah.com>
	 <Pine.LNX.4.64.0810231114320.1475@cnc.isely.net>
	 <20081023191543.GA10017@kroah.com>
	 <Pine.LNX.4.64.0810231451080.1475@cnc.isely.net>
	 <37219a840810231504r6a1d7c1eu5b2b05a6258a3597@mail.gmail.com>
	 <alpine.DEB.1.10.0810231810480.16804@p34.internal.lan>
	 <Pine.LNX.4.64.0810240043000.5947@cnc.isely.net>
X-Google-Sender-Auth: 97b8c75063da9eca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8494_9836254.1224862176401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Oct 24, 2008 at 1:43 AM, Mike Isely <isely@isely.net> wrote:
> On Thu, 23 Oct 2008, Justin Piszcz wrote:
>
>>
>>
>> On Thu, 23 Oct 2008, Michael Krufky wrote:
>>
>> > On Thu, Oct 23, 2008 at 3:54 PM, Mike Isely <isely@isely.net> wrote:
>> > > On Thu, 23 Oct 2008, Greg KH wrote:
>> > >
>> > > > On Thu, Oct 23, 2008 at 11:27:11AM -0500, Mike Isely wrote:
>> > > > > On Mon, 20 Oct 2008, Greg KH wrote:
>> > > > >
>> > >
>> > >   [...]
>> > >
>> > > > > >
>> > > > > > Will this patch be sent to the -stable group, to fix this regression
>> > > > > > in
>> > > > > > 2.6.27?  Or should they take Alan's fix instead?
>> > > > > >
>> > > > >
>> > > > > Greg:
>>
>> [ .. ]
>>
>> > The changeset in Linus tree is: c82732a42896364296599b0f73f01c5e3fd781ae
>> >
>> > Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
>> >
>> > Please wait on test results from Mike Isely or I confirming that
>> > digital mode still works properly before queuing this one.
>> >
>> > Thanks,
>> >
>> > Mike Krufky
>> >
>>
>> I only tested analog here for the 1950 FYI.
>>
>> Justin.
>
> Analog and digital HVR-1950 operation are unaffected by the reset fix
> here.  This is safe.
>
>  -Mike
>
> --
>
> Mike Isely
> isely @ pobox (dot) com
> PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
>

I concur.  This patch is fine for -stable.  (I tested digital myself
last night / this morning and its fine)

Greg -- any chance you can slip this in to 2.6.27.4 ?  The driver is
entirely broken otherwise.

cherry-picked changeset attached...

Thanks,

Mike Krufky

------=_Part_8494_9836254.1224862176401
Content-Type: text/x-diff; name=0001-V4L-pvrusb2-Fix-deadlock-problem.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmoz95ku0
Content-Disposition: attachment;
 filename=0001-V4L-pvrusb2-Fix-deadlock-problem.patch

RnJvbSBhYzM2ZDJkZTBlMjE4N2YzMjJjZTA4NTYxOGMzZGRjMjk1NGEwYzJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWtlIElzZWx5IDxpc2VseUBwb2JveC5jb20+CkRhdGU6IFN1
biwgMTkgT2N0IDIwMDggMTY6MjY6MDUgLTAzMDAKU3ViamVjdDogW1BBVENIXSBWNEw6IHB2cnVz
YjI6IEZpeCBkZWFkbG9jayBwcm9ibGVtCgpGaXggZGVhZGxvY2sgcHJvYmxlbSBpbiAyLjYuMjcg
Y2F1c2VkIGJ5IG5ldyBVU0IgY29yZSBiZWhhdmlvciBpbgpyZXNwb25zZSB0byBhIFVTQiBkZXZp
Y2UgcmVzZXQgcmVxdWVzdC4gIFdpdGggb2xkZXIga2VybmVscywgdGhlIFVTQgpkZXZpY2UgcmVz
ZXQgd2FzICJpbiBsaW5lIjsgdGhlIHJlc2V0IHNpbXBseSB0b29rIHBsYWNlIGFuZCB0aGUgZHJp
dmVyCnJldGFpbmVkIGl0cyBhc3NvY2lhdGlvbiB3aXRoIHRoZSBoYXJkd2FyZS4gIEhvd2V2ZXIg
bm93IHRoaXMgcmVzZXQKdHJpZ2dlcnMgYSBkaXNjb25uZWN0LCBhbmQgd29yc2Ugc3RpbGwgdGhl
IGRpc2Nvbm5lY3QgY2FsbGJhY2sgaGFwcGVucwppbiB0aGUgY29udGV4dCBvZiB0aGUgY2FsbGVy
IHdobyBhc2tlZCBmb3IgdGhlIGRldmljZSByZXNldC4gIFRoaXMKcmVzdWx0cyBpbiBhbiBhdHRl
bXB0IGJ5IHRoZSBwdnJ1c2IyIGRyaXZlciB0byByZWN1cnNpdmVseSB0YWtlIGEKbXV0ZXggaXQg
YWxyZWFkeSBoYXMsIHdoaWNoIGRlYWRsb2NrcyB0aGUgZHJpdmVyJ3Mgd29ya2VyIHRocmVhZC4K
KEV2ZW4gaWYgdGhlIGRpc2Nvbm5lY3QgY2FsbGJhY2sgd2VyZSB0byBoYXBwZW4gb24gYSBkaWZm
ZXJlbnQgdGhyZWFkCndlJ2Qgc3RpbGwgaGF2ZSBwcm9ibGVtcyBob3dldmVyIC0gYmVjYXVzZSB3
aGlsZSB0aGUgZHJpdmVyIHNob3VsZApzdXJ2aXZlIGFuZCBjb3JyZWN0bHkgZGlzY29ubmVjdCAv
IHJlY29ubmVjdCwgaXQgd2lsbCB0aGVuIHRyaWdnZXIKYW5vdGhlciBkZXZpY2UgcmVzZXQgZHVy
aW5nIHRoZSByZXBlYXRlZCBpbml0aWFsaXphdGlvbiwgd2hpY2ggd2lsbAp0aGVuIGNhdXNlIGFu
b3RoZXIgZGlzY29uZWN0LCBldGMsIGZvcmV2ZXIuKSAgVGhlIGZpeCBoZXJlIGlzIHNpbXBseQp0
byBub3QgYXR0ZW1wdCB0aGUgZGV2aWNlIHJlc2V0IChpdCB3YXMgb2YgbWFyZ2luYWwgdmFsdWUg
YW55d2F5KS4KClNpZ25lZC1vZmYtYnk6IE1pa2UgSXNlbHkgPGlzZWx5QHBvYm94LmNvbT4KU2ln
bmVkLW9mZi1ieTogTWF1cm8gQ2FydmFsaG8gQ2hlaGFiIDxtY2hlaGFiQHJlZGhhdC5jb20+ClNp
Z25lZC1vZmYtYnk6IE1pY2hhZWwgS3J1Zmt5IDxta3J1Zmt5QGxpbnV4dHYub3JnPgooY2hlcnJ5
IHBpY2tlZCBmcm9tIGNvbW1pdCBjODI3MzJhNDI4OTYzNjQyOTY1OTliMGY3M2YwMWM1ZTNmZDc4
MWFlKQotLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vcHZydXNiMi9wdnJ1c2IyLWhkdy5jIHwgICAg
NiAtLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vcHZydXNiMi9wdnJ1c2IyLWhkdy5j
IGIvZHJpdmVycy9tZWRpYS92aWRlby9wdnJ1c2IyL3B2cnVzYjItaGR3LmMKaW5kZXggZjA1MWM2
YS4uNzQxMjI1OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9wdnJ1c2IyL3B2cnVz
YjItaGR3LmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9wdnJ1c2IyL3B2cnVzYjItaGR3LmMK
QEAgLTYwLDcgKzYwLDYgQEAgc3RhdGljIHN0cnVjdCBwdnIyX2hkdyAqdW5pdF9wb2ludGVyc1tQ
VlJfTlVNXSA9IHtbIDAgLi4uIFBWUl9OVU0tMSBdID0gTlVMTH07CiBzdGF0aWMgREVGSU5FX01V
VEVYKHB2cjJfdW5pdF9tdHgpOwogCiBzdGF0aWMgaW50IGN0bGNoZzsKLXN0YXRpYyBpbnQgaW5p
dHVzYnJlc2V0ID0gMTsKIHN0YXRpYyBpbnQgcHJvY3JlbG9hZDsKIHN0YXRpYyBpbnQgdHVuZXJb
UFZSX05VTV0gPSB7IFswIC4uLiBQVlJfTlVNLTFdID0gLTEgfTsKIHN0YXRpYyBpbnQgdG9sZXJh
bmNlW1BWUl9OVU1dID0geyBbMCAuLi4gUFZSX05VTS0xXSA9IDAgfTsKQEAgLTcxLDggKzcwLDYg
QEAgbW9kdWxlX3BhcmFtKGN0bGNoZywgaW50LCBTX0lSVUdPfFNfSVdVU1IpOwogTU9EVUxFX1BB
Uk1fREVTQyhjdGxjaGcsICIwPW9wdGltaXplIGN0bCBjaGFuZ2UgMT1hbHdheXMgYWNjZXB0IG5l
dyBjdGwgdmFsdWUiKTsKIG1vZHVsZV9wYXJhbShpbml0X3BhdXNlX21zZWMsIGludCwgU19JUlVH
T3xTX0lXVVNSKTsKIE1PRFVMRV9QQVJNX0RFU0MoaW5pdF9wYXVzZV9tc2VjLCAiaGFyZHdhcmUg
aW5pdGlhbGl6YXRpb24gc2V0dGxpbmcgZGVsYXkiKTsKLW1vZHVsZV9wYXJhbShpbml0dXNicmVz
ZXQsIGludCwgU19JUlVHT3xTX0lXVVNSKTsKLU1PRFVMRV9QQVJNX0RFU0MoaW5pdHVzYnJlc2V0
LCAiRG8gVVNCIHJlc2V0IGRldmljZSBvbiBwcm9iZSIpOwogbW9kdWxlX3BhcmFtKHByb2NyZWxv
YWQsIGludCwgU19JUlVHT3xTX0lXVVNSKTsKIE1PRFVMRV9QQVJNX0RFU0MocHJvY3JlbG9hZCwK
IAkJICJBdHRlbXB0IGluaXQgZmFpbHVyZSByZWNvdmVyeSB3aXRoIGZpcm13YXJlIHJlbG9hZCIp
OwpAQCAtMTY5OCw5ICsxNjk1LDYgQEAgc3RhdGljIHZvaWQgcHZyMl9oZHdfc2V0dXBfbG93KHN0
cnVjdCBwdnIyX2hkdyAqaGR3KQogCX0KIAloZHctPmZ3MV9zdGF0ZSA9IEZXMV9TVEFURV9PSzsK
IAotCWlmIChpbml0dXNicmVzZXQpIHsKLQkJcHZyMl9oZHdfZGV2aWNlX3Jlc2V0KGhkdyk7Ci0J
fQogCWlmICghcHZyMl9oZHdfZGV2X29rKGhkdykpIHJldHVybjsKIAogCWZvciAoaWR4ID0gMDsg
aWR4IDwgaGR3LT5oZHdfZGVzYy0+Y2xpZW50X21vZHVsZXMuY250OyBpZHgrKykgewotLSAKMS41
LjQuMwoK
------=_Part_8494_9836254.1224862176401--
