Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYH2RHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYH2RHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbYH2RHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:07:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbYH2RHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:07:35 -0400
Message-ID: <48B82BFD.5030807@zytor.com>
Date: Fri, 29 Aug 2008 10:03:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org> <Pine.LNX.4.64.0808290817190.21494@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808290817190.21494@blonde.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> 
> hpa introduced the 64k idea, and we've all been repeating it;
> but I've not heard the reasoning behind it.  Is it a fundamental
> addressing limitation within the BIOS memory model?  Or a case
> that Windows treats the bottom 64k as scratch, so BIOS testers
> won't notice if they corrupt it?
> 

I should point out that I have seen one particular bug quite a few times 
poking around with boot loaders: the BIOS accesses memory at an 
otherwise valid address, but with the segment base set to either zero or 
0x400 instead of whatever it should have been.

	-hpa
