Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbZLRV1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbZLRV1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZLRV1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:27:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZLRV1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:27:46 -0500
Message-ID: <4B2BF38F.3090101@zytor.com>
Date: Fri, 18 Dec 2009 13:26:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: move range related operation to one file
References: <4B2B4C19.6010402@kernel.org> <4B2B4F85.5030901@kernel.org> <4B2BE1BF.60803@zytor.com> <4B2BE348.207@kernel.org>
In-Reply-To: <4B2BE348.207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 12:17 PM, Yinghai Lu wrote:
> 
> yes here is we have [start, end] instead of [start, end)
> 
> those range operation is used for one purpose:
> add several ranges, and subtract some other ranges, it will take out overlap between those two sets.
> and leave out the range that could be used.
> 
> and it is array based...for early stage.
> 

Yes.  We should be able to use the *exact same code* for the e820
ranges, using the e820 attribute as the attribute parameters, and a
simple boolean for the case where all you want is inclusion/exclusion.
And yes, I agree array based is the right thing to do for the early code.

Note that my array-based version only had an insert operation, no delete
operation -- that is because the delete operation is simply an insert
operation of attribute 0.

	-hpa

