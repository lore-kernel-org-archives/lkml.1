Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZLITE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZLITE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZLITEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:04:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbZLITEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:04:44 -0500
Message-ID: <4B1FF48B.4020202@zytor.com>
Date: Wed, 09 Dec 2009 11:03:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Micha? Miros?aw <mirq-linux@rere.qmqm.pl>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH 3/7] mtrr: Remove use_intel()
References: <1-1000-25639-1260344705-9533@rere.qmqm.pl>	 <4-1000-25639-1260344705-9533@rere.qmqm.pl>	 <86802c440912090010q3aa9c701u75fbba19d43308e0@mail.gmail.com>	 <20091209085224.GB5129@elte.hu> <86802c440912091032q5fabe27ag9a699e484828a0e6@mail.gmail.com>
In-Reply-To: <86802c440912091032q5fabe27ag9a699e484828a0e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 10:32 AM, Yinghai Lu wrote:
> /*
>  * Generic structure...
>  */
> struct mtrr_ops generic_mtrr_ops = {
>         .use_intel_if           = 1,
>         .set_all                = generic_set_all,
> 
> so all cpus that cpuid tell us that there is mtrr support, will all
> have use_intel() == 1

Yes, because the right thing to check isn't the CPU vendor bit but the
CPU feature bits -- all CPUs that have the MTRR feature bit are using
the "Intel interface" -- regardless of if they are made by Intel, AMD,
VIA, or Transmeta.  The older AMD, Cyrix etc. interfaces use different bits.

	-hpa

