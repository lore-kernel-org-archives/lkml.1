Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZGBXZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZGBXZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZGBXZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:25:36 -0400
Received: from mga07.intel.com ([143.182.124.22]:59200 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752684AbZGBXZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:25:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,337,1243839600"; 
   d="scan'208";a="161105819"
Message-ID: <4A4D41F2.8070507@linux.intel.com>
Date: Thu, 02 Jul 2009 16:25:38 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com> <20090630063230.GD1351@ucw.cz> <43F901BD926A4E43B106BF17856F07556428B555@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F07556428B555@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pan, Jacob jun wrote:
>>> +#define platform_has(bit) \
>>> +	test_bit(bit, (unsigned long *)platform_feature)
>> test_bit and friends imply synchronization you probably  don't want or
>> need...
>>
> [[JPAN]] could you explain a little more? The disassembly shows the test_bit
> ends up as a testb instruction and a jump. Why there is synchronization
>  involved?
> Perhaps on some architectures?

test_bit() doesn't imply synchronization; set_bit() and clear_bit() do
(but not __set_bit() and __clear_bit(), just to really be confusing.)

	-hpa
