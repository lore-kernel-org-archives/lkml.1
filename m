Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXITOCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXITOCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXITOB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:01:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:20151 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXITOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IS5aTT1FLzZE+DbBMuo/yq7ZpX3Iv9MLR9g4IoGqlniYTh8WpGe+rvW4g34/ftQhm5TI6IZdtzTQVRloh4lnlcEOLOf2YjTT7/KGVt4sUSY5YV08iWhA7XWNjDk/32OrktkAk+gdLqY1VqvYueNTzpcxCJ/C/L4crLfHqrjUshM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: arch/x86_64/kernel/Makefile: why EXTRA_AFLAGS := -traditional
Date: Thu, 20 Sep 2007 15:01:43 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201501.44009.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

arch/x86_64/kernel/Makefile has 

EXTRA_AFLAGS := -traditional

and this is causing me trouble with #define MACRO(a,b) a.b
(defined in one of included header file).
It expands incorrectly, as "a. b" - extra space.

If I use a.##b, all other .S files suffer - I am getting
a.##b expansion in them.

Can I remove EXTRA_AFLAGS := -traditional?
--
vda
