Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZFYN5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZFYN5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZFYN4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:56:55 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:33056 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZFYN4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:56:55 -0400
Message-ID: <4A4381F5.5010405@linux.vnet.ibm.com>
Date: Thu, 25 Jun 2009 15:56:05 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcov: fix __ctors_start alignment
References: <20090625101147.GB5051@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090625101147.GB5051@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> The ctors section for each object file is eight byte aligned (on 64 bit).
> However the __ctors_start symbol starts at an arbitrary address dependent
> on the size of the previous sections.
> Therefore the linker may add some zeroes after __ctors_start to make sure
> the ctors contents are properly aligned. However the extra zeroes at the
> beginning aren't expected by the code. When walking the functions pointers
> contained in there and extra zeroes are added this may result in random
> jumps.
> So make sure that the __ctors_start symbol is always aligned as well.

Ack. And good find! :) Also with this patch applied, the x86_64 boot 
problem reported by Ingo Molnar no longer occurs.

