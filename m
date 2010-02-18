Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab0BRTlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:41:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36362 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab0BRTlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:41:36 -0500
Message-ID: <4B7D97A6.4060900@zytor.com>
Date: Thu, 18 Feb 2010 11:40:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] x86: add support for relative CALL and JMP in alternatives
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-3-git-send-email-luca@luca-barbieri.com>
In-Reply-To: <1266406962-17463-3-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 03:42 AM, Luca Barbieri wrote:
> Currently CALL and JMP cannot be used in alternatives because the
> relative offset would be wrong.
> 
> This patch uses the existing x86 instruction parser to parse the
> alternative sequence and fix up the displacements.
> 
> This allows to implement this feature with minimal code.
> 

The existing instruction parser is only present if KPROBES is configured
in... this patch would make it obligatory.  Your patch doesn't reflect
that.  Furthermore, it is ~16K of code and data which probably will make
embedded people unhappy... although perhaps isn't out of line.

A good question, though, is if we actually need support for JMP or CALL
as anything but the first instruction (usually the *only* instruction),
which would make it a lot easier...

	-hpa
