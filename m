Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZBETcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZBETcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZBETcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52708 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbZBETcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:02 -0500
Date: Thu, 5 Feb 2009 20:31:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
Message-ID: <20090205193121.GA31839@elte.hu>
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu> <498B3D80.1010206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B3D80.1010206@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> But the 32-bit check does the exact same thing but via a single binary  
>> operation: it checks whether any bits outside of those bits are zero - 
>> just via a simpler test that compiles to more compact code.
>>
>> So i'd go with the 32-bit version. (unless there are some 
>> sign-extension complications i'm missing - but i think we got rid of 
>> those already.)
>
> OK, fair enough.  I wouldn't be surprised if gcc does that transform 
> anyway, but we may as well be consistent about it.

i checked and it doesnt - at least 4.3.2 inserts an extra AND instruction. 
So the 32-bit version is really better. (beyond being more readable)

	Ingo
