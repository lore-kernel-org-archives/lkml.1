Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0BKVtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:49:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab0BKVtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:49:45 -0500
Message-ID: <4B747B6F.1090209@redhat.com>
Date: Thu, 11 Feb 2010 16:49:35 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
       Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       shak <dshaks@redhat.com>
Subject: Re: [PATCH -mm] change anon_vma linking to fix multi-process server
 scalability issue
References: <20100128002000.2bf5e365@annuminas.surriel.com> <20100211130422.f262be71.akpm@linux-foundation.org>
In-Reply-To: <20100211130422.f262be71.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 04:04 PM, Andrew Morton wrote:
> On Thu, 28 Jan 2010 00:20:00 -0500
> Rik van Riel<riel@redhat.com>  wrote:
>
>> The old anon_vma code can lead to scalability issues with heavily
>> forking workloads.  Specifically, each anon_vma will be shared
>> between the parent process and all its child processes.

Some test results:

Without the anon_vma changes, when AIM7 hits around 9.7k
users (on a test box with 16GB RAM and not quite enough IO),
the system ends up running >99% in system time, with every
CPU on the same anon_vma lock in the pageout code.

With these changes, AIM7 hits the cross-over point around
29.7k users.  This happens with ~99% IO wait time, there
never seems to be any spike in system time.  The anon_vma
lock contention appears to be resolved.

-- 
All rights reversed.
