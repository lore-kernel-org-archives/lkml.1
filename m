Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbYDNNQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbYDNNQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYDNNP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:15:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:40735 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbYDNNPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=aZ6l0DgA981VZ0YxB+zw9s9fUmM5qWYNDfw69uCyq5YfvLs6A2HrugAMVZxaPeoce1/Ou3dSVlSk4WR1OByJ5esln/YuRHzsKRMtuetk8ec1qMHvX1KfPjwzs418pC/JQpfO1dslzuzoEspZgId/FO5Al6H9EzTSykVbUIbRFzQ=
Message-ID: <eb3ff54b0804140615u3dd4549fie83ae6818c33beba@mail.gmail.com>
Date: Mon, 14 Apr 2008 16:15:54 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "=?BIG5?B?WU9TSElGVUpJIEhpZGVha2kgLyCmTsPDrV6p+g==?=" 
	<yoshfuji@linux-ipv6.org>
Subject: [PATCH net-2.6.26] [IPV6] Return NET_RX_DROP when a packet is dropped in ipv6_rcv().
Cc: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_22195_930906.1208178954236"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_22195_930906.1208178954236
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
- The IPv6 handler for receiving packets is ipv6_rcv() in net/ipv6/ip6_input.c.
It is called by netif_receive_skb() (net/core/dev.c)
According to the documentation, the return value of netif_receive_skb() should
be NET_RX_DROP when the packet is dropped; though this return value
is usually not used (except maybe for congestion), this patch fixes the
ipv6_rcv() to return NET_RX_DROP when the packet is dropped (note that
NET_RX_DROP value **is not** 0 but 1; NET_RX_SUCCESS value is in fact	0).


Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_22195_930906.1208178954236
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ff12ht7t0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9pcHY2L2lwNl9pbnB1dC5jIGIvbmV0L2lwdjYvaXA2X2lucHV0LmMK
aW5kZXggNGU1Yzg2MS4uM2NhMDQxYiAxMDA2NDQKLS0tIGEvbmV0L2lwdjYvaXA2X2lucHV0LmMK
KysrIGIvbmV0L2lwdjYvaXA2X2lucHV0LmMKQEAgLTEzOCw3ICsxMzgsNyBAQCBkcm9wOgogCXJj
dV9yZWFkX3VubG9jaygpOwogCWtmcmVlX3NrYihza2IpOwogb3V0OgotCXJldHVybiAwOworCXJl
dHVybiBORVRfUlhfRFJPUDsKIH0KIAogLyoK
------=_Part_22195_930906.1208178954236--
