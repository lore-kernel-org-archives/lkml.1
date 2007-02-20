Return-Path: <linux-kernel-owner+w=401wt.eu-S1030337AbXBTR2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337AbXBTR2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030330AbXBTR2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:28:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50172 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030328AbXBTR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:28:06 -0500
Subject: Re: [PATCH 2.6.21-rc1] ibmebus: Support dynamic addition
	and	removal of adapters
From: John Rose <johnrose@austin.ibm.com>
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       Me Notes <johnrose@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       External List <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>
In-Reply-To: <OFF5C27801.F7BCD37B-ON85257285.0001F062-85257285.00028E7E@de.ibm.com>
References: <OFF5C27801.F7BCD37B-ON85257285.0001F062-85257285.00028E7E@de.ibm.com>
Content-Type: text/plain
Message-Id: <1171992306.22669.5.camel@sinatra.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.6 (1.4.6-2) 
Date: Tue, 20 Feb 2007 11:25:06 -0600
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If the probe operation succeeds, the respective device will show up 
> beneath
> /sys/bus/ibmebus/devices.

This approach is not particularly synchronous.  Take the case of an add
failure: how long would an application wait before deciding that the new
device is not going to appear?

It might be preferable to have the write to the probe function fail. 
For example, if we can't find the device node, return -EINVAL or
something.

> This is already taken care of by of_device_register().

If we are scrapping the use of of_device for ibmebus devices, can we
still create a devspec file for OF correlation purposes?

Thanks-
John

