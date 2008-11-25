Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYKYKzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYKYKzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYKYKz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:55:29 -0500
Received: from mga10.intel.com ([192.55.52.92]:64684 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752592AbYKYKz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:55:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="407793733"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] 8250: Eliminate compile warning of 8250.c
Date: Tue, 25 Nov 2008 18:51:44 +0800
User-Agent: KMail/1.10.3 (Linux/2.6.27-7-generic; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <1227585320-3711-1-git-send-email-sheng@linux.intel.com> <200811251831.34737.sheng@linux.intel.com> <20081125104334.351e94ee@lxorguk.ukuu.org.uk>
In-Reply-To: <20081125104334.351e94ee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251851.44768.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008 18:43:34 Alan Cox wrote:
> > Can't understand initializing got "risk hiding future ones". As I know,
> > didn't
>
> Because if you set it to NULL and later delete a line which does the
> intended assignment you will no longer get a warning.
>
> > think BUG_ON(n==null) cover this. And I don't think leave it to compiler
> > is more proper here.
>
> The BUG_ON covers it, the current gcc gets this right and works it out.
>
> NAK again

The logic here is strange...

If you used old compiler, you would get a warning, and you thought that's 
ensured we won't delete a intended assignment by mistake.

If you used new compiler, you wouldn't get a warning, and you think this time 
the compiler get it right.

So, what result did you expect? A warning to notice that we didn't delete a 
intended assignment, or a "right" result? 

OK. if you worry about "delete a line which does the intended assignment", the 
updated version with BUG_ON(i == NULL) can help. 

-- 
regards
Yang, Sheng

