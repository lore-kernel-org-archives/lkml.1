Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYA0KYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYA0KYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 05:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbYA0KYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 05:24:37 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:46772
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYA0KYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 05:24:36 -0500
Message-ID: <479C5BE3.6060803@qumranet.com>
Date: Sun, 27 Jan 2008 12:24:35 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 8/8] SVM: add support for Nested Paging
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-9-git-send-email-joerg.roedel@amd.com> <479C464E.2060009@qumranet.com> <20080127094147.GA32677@8bytes.org> <479C540A.8020003@qumranet.com> <20080127100517.GC32677@8bytes.org>
In-Reply-To: <20080127100517.GC32677@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
>> On the other hand, we want to trap cr0 so the guest can't control the 
>> cache disable bits.  Also cr4.pce and cr4.mce.
>>     
>
> Is it a problem when the guest disables caching? It disables it only in
> its own context because it has its own copy of cr0. 

Some Intel processors have a mode where cache coherency is no longer 
preserved, and we need to prevent that.  However from my reading of the 
AMD manuals, cache coherency is preserved even with caching disabled, so 
no real issue with disabling the cache.


> Cr4.pce can be
> accessible for the guests because there is no way for them to access the
> performance counter MSRs. 

Yes.  This was a red herring, cr0.pce only affects userspace rdpmc.

-- 
error compiling committee.c: too many arguments to function

