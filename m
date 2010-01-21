Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831Ab0AUSJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0AUSJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 13:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610Ab0AUSJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 13:09:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58364 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab0AUSJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 13:09:12 -0500
Message-ID: <4B5897F7.5000008@zytor.com>
Date: Thu, 21 Jan 2010 10:07:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] x86, smp: Adjust native_wbinvd for smp_call_function-helpers
References: <1264092093-13739-1-git-send-email-bp@amd64.org> <1264092093-13739-3-git-send-email-bp@amd64.org>
In-Reply-To: <1264092093-13739-3-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 08:41 AM, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add a wbinvd_on_cpu() helper and fold the void * arg in the wbinvd macro
> definition so that native_wbinvd can be used in the smp_call_function_*
> helpers as a pointed-to function.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

This patch is a lot of extra uglification just to avoid a simple jump
stub -- and even then only with PV enabled -- for an operation which is
then going to perform an IPI and WBINVD.  That doesn't exactly seem like
the right tradeoff.

As such, I'm going to request that you just put a simple stub function
in lib/smp.c rather than this whole patchset (well, the smp.h bit
obviously needs to stay.)

	-hpa
