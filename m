Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYA3HeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYA3HeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYA3Hdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:33:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYA3Hdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:33:55 -0500
Message-ID: <47A02845.8030709@zytor.com>
Date: Tue, 29 Jan 2008 23:33:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yi.y.yang@intel.com
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>	 <479F4B99.4060701@zytor.com>	 <1201643817.12722.30.camel@yangyi-dev.bj.intel.com>	 <47A02483.5000606@zytor.com> <1201644793.12722.34.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1201644793.12722.34.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yi Yang wrote:
> Function cpuid has reset ecx to 0 immediate before calling to __cpuid,
> so this shouldn't be a problem now.

Unless, of course, you want to get to the information for the higher 
CPUID levels.

The easiest way to fix that would be to use cpuid_count() and let 
/dev/cpu/*/cpuid take the %ecx value in the high half of the offset. 
That would have minimal impact on the interface.

	-hpa
