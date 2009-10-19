Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbZJSOzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbZJSOzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZJSOzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:55:43 -0400
Received: from lucidpixels.com ([75.144.35.66]:51211 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbZJSOzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:55:42 -0400
Date: Mon, 19 Oct 2009 10:55:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <Pine.LNX.4.44L0.0910191016370.3899-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.0910191048000.7710@p34.internal.lan>
References: <Pine.LNX.4.44L0.0910191016370.3899-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-291428007-1255964146=:7710"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-291428007-1255964146=:7710
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed



On Mon, 19 Oct 2009, Alan Stern wrote:

> On Sun, 18 Oct 2009, Justin Piszcz wrote:
>
>> I have performed all of the steps you recommended, there is also a bug in
>> the docs, the directory seems to be different, or at least if you have
>> everything compiled into the kernel and not using modules.
>
>> Steps from the USB documentation:
>>
>> # mount -t debugfs none_debugs /sys/kernel/debug
>> #
>>
>> The kernel documentation is outdated:
>>
>> # ls /sys/kernel/debug/usbmon
>> 0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
>> #
>>
>> The directory is:
>> # ls /sys/kernel/debug/usb/usbmon
>> 0s  0u  1s  1t  1u  2s  2t  2u
>
> This has already been corrected in the 2.6.32-rc kernels.
Great to hear, I will try the latest 2.6.31-rcX kernel!

>
> However there is another respect in which the documentation is
> outdated: It mentions /proc/bus/usb/devices.  That file has moved; it
> is now named /sys/kernel/debug/usb/devices.  Would you like to submit a
> patch fixing this?
>
> Alan Stern
>

Hi,

Sure, what I meant is:

usbmon.txt states:
/sys/kernel/debug/usbmon/3u
             ^^^^^

Actual location:
/sys/kernel/debug/usb/usbmon/3u
             ^^^^^^^^^

Patch below (and attached):

diff -uprN linux-2.6.31.1/Documentation/usb/usbmon.txt linux-2.6.31.1.patch/Documentation/usb/usbmon.txt
--- linux-2.6.31.1/Documentation/usb/usbmon.txt 2009-09-24 11:45:25.000000000 -0400
+++ linux-2.6.31.1.patch/Documentation/usb/usbmon.txt   2009-10-19 10:51:06.725516874 -0400
@@ -33,7 +33,7 @@ if usbmon is built into the kernel.

  Verify that bus sockets are present.

-# ls /sys/kernel/debug/usbmon
+# ls /sys/kernel/debug/usb/usbmon
  0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
  #

@@ -58,11 +58,11 @@ Bus=03 means it's bus 3.

  3. Start 'cat'

-# cat /sys/kernel/debug/usbmon/3u > /tmp/1.mon.out
+# cat /sys/kernel/debug/usb/usbmon/3u > /tmp/1.mon.out

  to listen on a single bus, otherwise, to listen on all buses, type:

-# cat /sys/kernel/debug/usbmon/0u > /tmp/1.mon.out
+# cat /sys/kernel/debug/usb/usbmon/0u > /tmp/1.mon.out

  This process will be reading until killed. Naturally, the output can be
  redirected to a desirable location. This is preferred, because it is going

---1463747160-291428007-1255964146=:7710
Content-Type: TEXT/x-diff; name=usbmon-documentation-fix.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.0910191055460.7710@p34.internal.lan>
Content-Description: 
Content-Disposition: attachment; filename=usbmon-documentation-fix.patch

QmluYXJ5IGZpbGVzIGxpbnV4LTIuNi4zMS4xL0RvY3VtZW50YXRpb24vLlN1
Ym1pdHRpbmdQYXRjaGVzLnN3cCBhbmQgbGludXgtMi42LjMxLjEucGF0Y2gv
RG9jdW1lbnRhdGlvbi8uU3VibWl0dGluZ1BhdGNoZXMuc3dwIGRpZmZlcg0K
ZGlmZiAtdXByTiBsaW51eC0yLjYuMzEuMS9Eb2N1bWVudGF0aW9uL3VzYi91
c2Jtb24udHh0IGxpbnV4LTIuNi4zMS4xLnBhdGNoL0RvY3VtZW50YXRpb24v
dXNiL3VzYm1vbi50eHQNCi0tLSBsaW51eC0yLjYuMzEuMS9Eb2N1bWVudGF0
aW9uL3VzYi91c2Jtb24udHh0CTIwMDktMDktMjQgMTE6NDU6MjUuMDAwMDAw
MDAwIC0wNDAwDQorKysgbGludXgtMi42LjMxLjEucGF0Y2gvRG9jdW1lbnRh
dGlvbi91c2IvdXNibW9uLnR4dAkyMDA5LTEwLTE5IDEwOjUxOjA2LjcyNTUx
Njg3NCAtMDQwMA0KQEAgLTMzLDcgKzMzLDcgQEAgaWYgdXNibW9uIGlzIGJ1
aWx0IGludG8gdGhlIGtlcm5lbC4NCiANCiBWZXJpZnkgdGhhdCBidXMgc29j
a2V0cyBhcmUgcHJlc2VudC4NCiANCi0jIGxzIC9zeXMva2VybmVsL2RlYnVn
L3VzYm1vbg0KKyMgbHMgL3N5cy9rZXJuZWwvZGVidWcvdXNiL3VzYm1vbg0K
IDBzICAwdSAgMXMgIDF0ICAxdSAgMnMgIDJ0ICAydSAgM3MgIDN0ICAzdSAg
NHMgIDR0ICA0dQ0KICMNCiANCkBAIC01OCwxMSArNTgsMTEgQEAgQnVzPTAz
IG1lYW5zIGl0J3MgYnVzIDMuDQogDQogMy4gU3RhcnQgJ2NhdCcNCiANCi0j
IGNhdCAvc3lzL2tlcm5lbC9kZWJ1Zy91c2Jtb24vM3UgPiAvdG1wLzEubW9u
Lm91dA0KKyMgY2F0IC9zeXMva2VybmVsL2RlYnVnL3VzYi91c2Jtb24vM3Ug
PiAvdG1wLzEubW9uLm91dA0KIA0KIHRvIGxpc3RlbiBvbiBhIHNpbmdsZSBi
dXMsIG90aGVyd2lzZSwgdG8gbGlzdGVuIG9uIGFsbCBidXNlcywgdHlwZToN
CiANCi0jIGNhdCAvc3lzL2tlcm5lbC9kZWJ1Zy91c2Jtb24vMHUgPiAvdG1w
LzEubW9uLm91dA0KKyMgY2F0IC9zeXMva2VybmVsL2RlYnVnL3VzYi91c2Jt
b24vMHUgPiAvdG1wLzEubW9uLm91dA0KIA0KIFRoaXMgcHJvY2VzcyB3aWxs
IGJlIHJlYWRpbmcgdW50aWwga2lsbGVkLiBOYXR1cmFsbHksIHRoZSBvdXRw
dXQgY2FuIGJlDQogcmVkaXJlY3RlZCB0byBhIGRlc2lyYWJsZSBsb2NhdGlv
bi4gVGhpcyBpcyBwcmVmZXJyZWQsIGJlY2F1c2UgaXQgaXMgZ29pbmcNCg==

---1463747160-291428007-1255964146=:7710--
