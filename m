Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbYAXTqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbYAXTqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYAXTqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:46:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYAXTqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:46:30 -0500
Message-ID: <4798EB07.50002@zytor.com>
Date: Thu, 24 Jan 2008 11:46:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 10/26] mount options: fix devpts
References: <20080124193341.166753833@szeredi.hu> <20080124193429.480166399@szeredi.hu>
In-Reply-To: <20080124193429.480166399@szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Also add minor fix: when parsing the "mode" option, mask with
> S_IALLUGO instead of ~S_IFMT, which could leave unsed bits in the
> mask.

umode_t is 16 bits, so it doesn't.  The change is still good, of course.

> +	if (config.mode != DEVPTS_DEFAULT_MODE)
> +		seq_printf(seq, ",mode=%03o", config.mode);

I would rather this be unconditional, than that it be conditional on 
something other than the user having specified it in the first place.

Other than that,

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

