Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZHZNbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZHZNbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZHZNbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:31:40 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:55931 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbZHZNbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:31:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ImdKNZnj18WeSbFrK3oCfd/lwZW2p8nWyJULDm50Y/ihh+hrfcjUvouvkL+y+s5nu1
         vRWbPIysTVrmXZ3gHByIqshH/K9nOCHVlKhF/kdurE7osFeyb2JXxS/mgWWBuWcTTTlx
         fbeDQvTpSfPdb7Rt83SRZYKDWkAUokCBdBy18=
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 10:25:47 -0300
Message-ID: <d970ff420908260625q2d34bc10p62241218f022b5c2@mail.gmail.com>
Subject: PPC driver - generic bus width
From: Alemao <xcarandiru@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-embedded@ozlabs.org, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Im trying to develop a driver for my device, and its data bus can be 8, 16
or 32 bits. This information is passed through the device tree source.
My code is like this:

struct device_info_t {
	void (*read)();
	void (*write)();
};

static int __devinit device_probe()
{
	prop = of_get_property(ofdev->node, "bus-width", &size);

	device->bus_width = *prop;

	switch (device->bus_width) {
	case 8:
		device->read  = in_8;
		device->write = out_8;
		break;
	case 16:
		device->read  = in_be16;
		device->write = out_be16;
		break;
	case 32:
		device->read  = in_be32;
		device->write = out_be32;
		break;
	default:
		break;
	}
}

Can someone point me some driver that is doing something similar to the
ideia shown above?

Or what Im doing wrong in my code? Cause Im getting erros (warnings) like:

cc1: warnings being treated as errors
drivers/dev_test.c:37: warning: function declaration isn't a prototype
drivers/dev_test.c:38: warning: function declaration isn't a prototype
drivers/dev_test.c: In function 'device_probe':
drivers/dev_test.c:113: warning: assignment from incompatible pointer
type

PS: Im using a MPC8349, linux kernel 2.6.26

Cheers,

--
Alemao
