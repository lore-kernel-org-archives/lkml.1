Return-Path: <linux-kernel-owner+w=401wt.eu-S1762292AbYEGPIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762292AbYEGPIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYEGPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:08:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:55938 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYEGPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DLdjJ8Vs5vPzdz3cUb36HGB7jCV01A0yblCEyXggtTRa28qq5SgaQ6fSVwJ5iGOTNBe6bGY+zCqfFS4TSqKcs6Lpa/Gr8d79XyIyi7YpdGEjK26rn/aKHVQUwbq8SWe06LDMtL0EXMbZ9wSiLem2dCPwy3TpnkFe3qnFB0SbsOs=
Message-ID: <2c0942db0805070808t663eafffic5e78c9d1ba8bc68@mail.gmail.com>
Date: Wed, 7 May 2008 08:08:09 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: It's time to hack on dentry_stat?
Cc: "rae l" <crquan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080507145116.GV19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310805070726k7eb1384ex7d557b5dca4b567@mail.gmail.com>
	 <20080507145116.GV19219@parisc-linux.org>
X-Google-Sender-Auth: 1e79be238150983c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 7:51 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, May 07, 2008 at 10:26:58PM +0800, rae l wrote:
>  > I have noticed that struct dentry_stat_t dentry_stat is a struct with
>  > six fields,
>  > but only 2 of them are used, other 4 have never been used since v2.6.11,
>  >
>  > from include/linux/dcache.h:
>  >
>  > struct dentry_stat_t {
>  >         int nr_dentry;
>  >         int nr_unused;
>  >         int age_limit;          /* age in seconds */
>  >         int want_pages;         /* pages requested by system */
>  >         int dummy[2];
>  > };
>
>  You have to not break:
>
>  $ cat /proc/sys/fs/dentry-state
>  122104  115846  45      0       0       0

One could hardcode the output of the last three (four?) fields, yes?
Slightly grotty, but if it comes with a decent memory savings...
