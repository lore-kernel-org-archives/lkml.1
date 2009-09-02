Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbZIBM4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbZIBM4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 08:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZIBM4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 08:56:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZIBM4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 08:56:16 -0400
Message-ID: <4A9E6B70.2080707@redhat.com>
Date: Wed, 02 Sep 2009 15:56:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] keep guest wallclock in sync with host clock
References: <1251805848-17451-1-git-send-email-glommer@redhat.com> <1251805848-17451-2-git-send-email-glommer@redhat.com> <4A9E5A8B.4060804@redhat.com> <20090902122144.GL30340@mothafucka.localdomain> <4A9E63FA.8040808@redhat.com> <20090902124839.GM30340@mothafucka.localdomain>
In-Reply-To: <20090902124839.GM30340@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2009 03:48 PM, Glauber Costa wrote:
>
>> You can't prevent host preemption.  You might read kvmclock again and
>> repeat if too much time has passed.
>>      
> But then you can be scheduled after you did settimeofday, but before reading
> kvmclock again. Since we're aiming for periodic adjustments here,
> any discrepancies should not last long, so we can maybe live with it.
>    

do {
     read_kvmclock
     settimeofday
     read_kvmclock
} while the_difference_between_the_two_reads_is_too_large


-- 
error compiling committee.c: too many arguments to function

