Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZIKG2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZIKG2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZIKG2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:28:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:56237 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZIKG2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ao3Kthzh+19hLCWB5g0y7H8GlGOsxHjPYl6RDSfN+muVTKv3lOzcoixnBpDzaSnS5N
         e5NacWD+HLvcKBnr5v1zlEYMQWX8eWxODWUMroIFl2LnefHIzdoC9JsxsdoS5u9k6POg
         I3VzdkYYKrBpecGmqODe0v5SLMiJUX6pQDA/M=
Message-ID: <4AA9EE21.5040007@gmail.com>
Date: Fri, 11 Sep 2009 08:28:49 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: peterz@infradead.org, rjw@sisk.pl, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] sched: fix cpu_down deadlock
References: <4AA0FEBF.7040104@gmail.com> <1252496510-11898-1-git-send-email-jirislaby@gmail.com> <4AA9E9B3.8060901@cn.fujitsu.com>
In-Reply-To: <4AA9E9B3.8060901@cn.fujitsu.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2009 08:09 AM, Lai Jiangshan wrote:
> Does this bug occur when a cpu is being offlined or
> when the system is being suspended?
> Or Both?

Hi, I tried echo 0/1 > /sys/devices/system/cpu/cpu1/online in a loop,
but it didn't trigger the bug. It happened only on suspend/resume cycle
(in the end I found even swsusp in qemu suffers from this).
