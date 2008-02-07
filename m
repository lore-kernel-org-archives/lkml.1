Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYBGLkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYBGLkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 06:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYBGLj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 06:39:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:18163 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYBGLj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 06:39:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oYIltZogUS5LCVkOqqLcwq2KeRoJE+UutXaNDFmd17YJp/EEYAHT1sNuXaOxlcwKhD9qIo4aqcZNU+cE8EhA9zd8SphrlfuPKEwLa6ew39U77WwFkDWI5Q7iWjhxADjfZ1DoWh8FD9bvaH9DDZz7lA7dhGoZq3Z5FGo/VjB98Pc=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb mtrrs - FIX
Date: Thu, 7 Feb 2008 17:05:59 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, jesse.barnes@intel.com,
       ak@suse.de
References: <200802071257.51893.balajirrao@gmail.com> <200802071351.02763.balajirrao@gmail.com> <86802c440802070050t2566a261t50cccd649912a4a9@mail.gmail.com>
In-Reply-To: <86802c440802070050t2566a261t50cccd649912a4a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071705.59601.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 02:20:35 pm Yinghai Lu wrote:
<snip>
> > Cool! Yes, Yinghai Lu's patch indeed is the same as mine and its really
> > surprising that we've used the same variable name too! :)
>
> minor difference
> +               trim_start = highest_pfn << PAGE_SHIFT;
> +               trim_size = end_pfn << PAGE_SHIFT;
>
> could cause some problem with 32 bit kernel when mem > 4g.
> becase highest_pfn and end_pfn is unsigned long aka 32 bit ...could
> overflow.
>
> so need to assign thtem to trim_start/trim_end at first
> or
> +               trim_start = (u64)highest_pfn << PAGE_SHIFT;
> +               trim_size = (u64)end_pfn << PAGE_SHIFT;
>

Yea right.. Thanks for pointing that out.

-- 
regards,
balaji rao
