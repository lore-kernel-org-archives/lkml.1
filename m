Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYEYE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYEYE1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYEYE1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:27:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYEYE1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:27:05 -0400
Date: Sun, 25 May 2008 00:25:27 -0400
From: Kristian =?utf-8?B?SMO4Z3NiZXJn?= <krh@bitplanet.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rik van Riel <riel@redhat.com>,
       Kristian =?utf-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Use structs instead of hardcoded offsets in x86
	boot decompressor.
Message-ID: <20080525042527.GA12989@bitplanet.net>
References: <1211579968-15227-1-git-send-email-krh@redhat.com> <20080523210744.52fe7fde@bree.surriel.com> <4837B2DD.908@zytor.com> <20080525000330.3eedd788@riellaptop.surriel.com> <4838E5D4.4050708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4838E5D4.4050708@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 09:06:44PM -0700, H. Peter Anvin wrote:
> Rik van Riel wrote:
>> On Fri, 23 May 2008 23:17:01 -0700
>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>>> Uhm... except it doesn't live at address zero, at all.
>>>
>>> It's called "zeropage" because we used to recycle it into 
>>> empty_zero_page, a long long time ago.
>>>
>>> The bootparms structure is pointed to by %esi being passed from the setup 
>>> code to the decompressor to the kernel.
>>
>> Then why does dereferencing the uninitialized
>> pointer work, both in the code before and after
>> the patch?
>>
>> What am I misssing?
>
> Heck if I know.  It definitely *shouldn't* work...

Damn, I lost a chunk of the patch.  There's supposed to be a

        rm_screen_info = &real_mode->screen_info;

after the real_mode = rmode assignment.  In the code before,
RM_SCREEN_INFO was a macro that just referenced the real_mode pointer:

	#define RM_SCREEN_INFO (*(struct screen_info *)(real_mode+0))

Thanks, wil resend.
Kristian


