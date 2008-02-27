Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbYB0Gv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbYB0Gv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 01:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYB0GvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 01:51:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40092 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYB0GvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 01:51:16 -0500
Message-ID: <47C50860.2050108@zytor.com>
Date: Tue, 26 Feb 2008 22:51:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dan Upton <upton.dan.linux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: rdmsr_safe_on_cpu hangs?
References: <ba7d8f720802261358h31e30308ob4d99e05a34cf584@mail.gmail.com>
In-Reply-To: <ba7d8f720802261358h31e30308ob4d99e05a34cf584@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Upton wrote:
> 
> I guess the question is, am I just misunderstanding the use of
> rdmsr_safe_on_cpu, or is it an issue with that particular MSR (some of
> the stuff I've read indicates that rdmsr_safe was really only
> implemented as a prequel to the coretemp driver), or is it something
> wrong with rdmsr_safe_on_cpu?
> 

*msr_safe_*() can only trap #GP's, which would be manifest as oopses if 
you used the unsafe versions.  If the CPU *hangs* when touching an MSR, 
nothing we can do in software will help.

	-hpa
