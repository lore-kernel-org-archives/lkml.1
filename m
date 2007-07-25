Return-Path: <linux-kernel-owner+w=401wt.eu-S1764666AbXGYHZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764666AbXGYHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762348AbXGYHZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:25:12 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:50150 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbXGYHZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZA/20nxc9iazCARtqkA4XlvpzQamRzlzYCtmNIbeOBYknyyMw4xAs3EkUkcB5dN576isw6Zr7PM8dZk3N+4klOHXXYtwjeGt413vWpAhEIY7jH8cjVSUnc3FIEM0ennzj68uclfzaCW9JaEOc2ep8HgUKAyyDMupLbbuk8UHIpU=
Message-ID: <e9f486400707250025k163d34cdk97cf2722db739634@mail.gmail.com>
Date: Wed, 25 Jul 2007 09:25:09 +0200
From: "Henri Hunnekens" <henrihunnekens@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: TSC calibration sometimes not correct with RT patch.
Cc: mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen that the calbration of the TSC timer was not always done
correctly, which resulted in incorrect timers.

I found out that local_irq_disable is used before the calibration is
started. However with the RT patch applied this does not mean that the
interrupts are disabled and therefore the calibration may fails when
it's interrupted by an interrupt. Correct me if I'm wrong.

I think that this local_irq_disable must be replaced with the
raw_local_irq_disable which does disable the interrupts.

I'm not able to verify if this solves the problem because it is very
hard to reproduce. Maybe someone can verify if my assumption is
correcly.

Currently I'm using kernel version 2.6.20-RT8, but I've checked that
latest kernel version with the latest RT patch and they have the same
implementation.
