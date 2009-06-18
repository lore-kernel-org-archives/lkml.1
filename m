Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbZFRLQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbZFRLQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZFRLQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:16:00 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:38550 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZFRLQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mCauhyDit40YMvP2lG9p4iFG0IQG4JuuU9YKlbgXpYgQbA1nKR45uxue9431TKmwV7
         Tlyxe4VyNAyx+wtnUqonCqtgWZ8RGAVCgstScD1xVqql64oPkU+GlN9ud4ZE4Lz2K6Ls
         TV9mxavRm57Nu5jPtdE1aUDhhwMDhhjV5mikA=
MIME-Version: 1.0
Date: Thu, 18 Jun 2009 13:16:01 +0200
Message-ID: <b08bcbf50906180416l5268bcf9waba28763def7387a@mail.gmail.com>
Subject: Is hard_start_xmit synchronized when using different interfaces?
From: Gallus <gall.cwpl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm trying to sent packets to different interfaces handled by the same
network driver (Intel e1000e). The interfaces are located on the same
card as well as on different cards.

Each interface has its own instance of my additional custom driver
designed to just send packets. The custom driver just allocs the
packets by:
skb = dev_alloc_skb(packet->len);

and then them sends by:
result = dev->hard_start_xmit(skb,dev);

The problem is that I cant obtain full bandwidth offered by the 1GB
interfaces.

For one interface I get: 120435948 bytes/sec.
For two interfaces I get: 61080233 bytes/sec and 60515294 bytes/sec.
For three interfaces I get: 28564020 bytes/sec, 27111184 bytes/sec,
27118907 bytes/sec.

Is the hard_start_xmit function synchronized even if interfaces are distinct?

Please CC me.
-- 
Regards,
Adam
