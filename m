Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXEFDQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXEFDQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 23:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXEFDQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 23:16:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:30016 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbXEFDQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 23:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LrNLQuw/GGQyd1ZWvAlEmVordgd3Ynx0y3KZ7iBnQe0jiXUXfHHYZL8a0g6jiOv/+P19MT4N0D6Y3n1b7MmdY5PC0YFY9Z1d3gjmc7298FHVIh2czJW5ctvJ/8KzSRQ4WxgxC8GP8l6GpdQV6jwJXwEhR1FHkELZTXWSO0Aqh44=
Message-ID: <787b0d920705052016o2d7e36ffsdc80302228b0ee1e@mail.gmail.com>
Date: Sat, 5 May 2007 23:16:25 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: johnstul@us.ibm.com, tjanouse@redhat.com, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com
Subject: Re: Broken process startup times after suspend (regression)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz writes:

> Indeed. The monotonic clock's behavior around suspend and resume
> is poorly defined. When we increased it, folks didn't like the
> fact that uptime would increase while a system was suspended.

The uptime really does need to increase during suspend. Otherwise,
things get really weird with devices like the OLPC XO which will be
sleeping between keystrokes. You could run the device for hours,
yet get an uptime of only a few minutes. Suspended time should get
counted as stolen time, same as when a hypervisor takes away time.
