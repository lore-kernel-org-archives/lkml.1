Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZG2QHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZG2QHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZG2QHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:07:44 -0400
Received: from mx02.kabsi.at ([62.40.128.130]:41689 "EHLO mx02.kabsi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbZG2QHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:07:43 -0400
X-Greylist: delayed 3334 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 12:07:42 EDT
Date: Wed, 29 Jul 2009 17:11:07 +0200
From: Jakob Gruber <jakob.gruber@kabelnet.at>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing device IDs in rt2870
Message-Id: <20090729171107.155719b5.jakob.gruber@kabelnet.at>
In-Reply-To: <20090728211216.GA12363@suse.de>
References: <20090728230117.8fca2314.jakob.gruber@kabelnet.at>
	<20090728211216.GA12363@suse.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__29_Jul_2009_17_11_07_+0200_7i_y_oxMZEqdVCW0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__29_Jul_2009_17_11_07_+0200_7i_y_oxMZEqdVCW0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Jul 2009 14:12:16 -0700
Greg KH <gregkh@suse.de> wrote:

> On Tue, Jul 28, 2009 at 11:01:17PM +0200, Jakob Gruber wrote:
> > >From http://bugzilla.kernel.org/show_bug.cgi?id=13459#c3
> > 
> > In rt2870.h, there are 2 lists of USB devices. One is within 
> > 
> > #ifndef RT30xx
> > #endif
> > 
> > and the other in 
> > 
> > #ifdef RT30xx
> > #endif
> 
> That kind of implies that the 2870 driver should not support this
> device, right?

I think there's been a misunderstanding - I wasn't saying that the device ID is included in one block but not in another. I wanted to point out that I wasn't sure whether to add the ID to both lists or just the first one.

> 
> > 
> > Since I'm not sure whether to add the devices to both lists or only the first,
> > I'm posting a patch for both variations.
> > 
> > Patch 1, add devices only to first list:
> 
> Well, pick one :)
> 
> I'd prefer someone with one of these devices to test the patch and
> verify that it works before blindly applying.  Fair enough?

I own the Belkin device in question (0x050D,0x815C), and it worked perfectly with kernel 2.6.29 after adding the device ID to rt2870.h.
The patch is also included in the Archlinux kernel, see 
http://projects.archlinux.org/?p=linux-2.6-ARCH.git;a=tree;f=patches;hb=HEAD

I haven't tested rt2870 in 2.6.30 thoroughly because of this bug (http://bugzilla.kernel.org/show_bug.cgi?id=13638), which forces me to use the driver from the Ralink website instead of the kernel module.
However, I can confirm that - until running into the bug - the Belkin card also works in 2.6.30. 

A patch for adding the Belkin device ID is attached. I removed the other 2 IDs from http://bugzilla.kernel.org/show_bug.cgi?id=13459 since I do not own these devices and cannot verify them. The ID is only added to the "#ifndef RT30xx" block, same as the patch applied to the Archlinux kernel.

> 
> thanks,
> 
> greg k-h

Thanks for your work, it's appreciated.

-- 
Jakob Gruber <jakob.gruber@kabelnet.at>

--Multipart=_Wed__29_Jul_2009_17_11_07_+0200_7i_y_oxMZEqdVCW0
Content-Type: text/plain;
 name="rt2870_missing_id.patch"
Content-Disposition: attachment;
 filename="rt2870_missing_id.patch"
Content-Transfer-Encoding: base64

RnJvbSA5MjY4ZDIwODQ1NDgyNGQwYjVhYWZmZjY4NzU2NjIxOTFkY2VjY2ZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSmFrb2IgR3J1YmVyIDxqYWtvYi5ncnViZXJAa2FiZWxuZXQu
YXQ+DQpEYXRlOiBXZWQsIDI5IEp1bCAyMDA5IDE2OjUzOjE1ICswMjAwDQpTdWJqZWN0OiBbUEFU
Q0hdIFJUMjg3MCBtaXNzaW5nIGRldmljZSBJRA0KDQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvcnQy
ODcwL3J0Mjg3MC5oIHwgICAgMSArDQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyks
IDAgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvcnQyODcwL3J0
Mjg3MC5oIGIvZHJpdmVycy9zdGFnaW5nL3J0Mjg3MC9ydDI4NzAuaA0KaW5kZXggMjllM2I1My4u
NjJiNmVmMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy9ydDI4NzAvcnQyODcwLmgNCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy9ydDI4NzAvcnQyODcwLmgNCkBAIC05OSw2ICs5OSw3IEBADQog
CXtVU0JfREVWSUNFKDB4MTRCMiwweDNDMDcpfSwgLyogQUwgKi8JCQlcDQogCXtVU0JfREVWSUNF
KDB4MTRCMiwweDNDMTIpfSwgLyogQUwgKi8gICAgICAgICAgIFwNCiAJe1VTQl9ERVZJQ0UoMHgw
NTBELDB4ODA1Myl9LCAvKiBCZWxraW4gKi8JCVwNCisJe1VTQl9ERVZJQ0UoMHgwNTBELDB4ODE1
Qyl9LCAvKiBCZWxraW4gKi8JCVwNCiAJe1VTQl9ERVZJQ0UoMHgxNEIyLDB4M0MyMyl9LCAvKiBB
aXJsaW5rICovCQlcDQogCXtVU0JfREVWSUNFKDB4MTRCMiwweDNDMjcpfSwgLyogQWlybGluayAq
LwkJXA0KIAl7VVNCX0RFVklDRSgweDA3QUEsMHgwMDJGKX0sIC8qIENvcmVnYSAqLwkJXA0KLS0g
DQoxLjYuMy4zDQoNCg==

--Multipart=_Wed__29_Jul_2009_17_11_07_+0200_7i_y_oxMZEqdVCW0--
