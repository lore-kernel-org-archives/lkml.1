Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968Ab0ATGa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0ATGa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755Ab0ATGa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:30:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36184 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab0ATGa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:30:26 -0500
Date: Wed, 20 Jan 2010 15:30:24 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: The use_count problem of regulator
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Cc: kyungmin.park@samsung.com, mk7.kang@samsung.com,
       linux-kernel@vger.kernel.org
Message-id: <4B56A300.7000907@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 20 Jan 2010 06:30:23.0861 (UTC)
 FILETIME=[0BFCCA50:01CA999A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.

I have one simple question.

In the regulator framework, if the regulator is enabled for example by 
boot_on constraint, when regulator_get is called at the driver probe 
function, the use_count of struct regulator_dev is zero. But if 
regulator_has_full_constraints() is used, even though above the 
regulator is using, it is disabled by regulator_init_complete() because
the use_count is zero.

Of course, we can use regulator_get_exclusive instead of regulator_get,
but if the regulator can be shared, i think this will be a problem.

Thanks.
