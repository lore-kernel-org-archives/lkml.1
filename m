Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZGUUmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZGUUmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZGUUmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:42:52 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:40027 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZGUUmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:42:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=MburSHc4QorP5NZQCCId/gsDQhMDlqu+efMFgMxUH0/wQxEqy9TGzLUY5Yu3f9vyoO
         1bovBFSlfhZsim/irryyVHKFqv9PUhl628DEuXejf3Ob/RnGf5RFQ+VuQDyUlWNPo51a
         OTBnJHUAfnKROE6mu1oMW1YLKU9xcgu0E9xiA=
Date: Tue, 21 Jul 2009 23:42:43 +0300
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: Do cpu-endian MMIO accessors exist?
Message-ID: <20090721234243.1928d9e2@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is for Nouveau, where the hardware is configured to have the
same endianess as the cpu. Well, it's configured BE for PPC and
LE otherwise.

I'm looking for to drop the following kind of #ifdefs:

#if defined(__powerpc__)
static inline u32 nv_rd32(struct drm_device *dev, unsigned reg)
{
        struct drm_nouveau_private *dev_priv = dev->dev_private;
        return in_be32((void __force __iomem *)dev_priv->mmio->handle + reg);
}
#else
static inline u32 nv_rd32(struct drm_device *dev, unsigned reg)
{
        struct drm_nouveau_private *dev_priv = dev->dev_private;
        return readl((void __force __iomem *)dev_priv->mmio->handle + reg);
}
#endif

Please, don't mind about the other ugliness, that will be fixed.

Do cpu-endian MMIO accessors exist? What should I use, or do I just
have to use #ifdef __BIG_ENDIAN?


Thanks.
Please, Cc me.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
