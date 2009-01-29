Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZA2Kqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZA2Kqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZA2Kq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:46:27 -0500
Received: from gw.goop.org ([64.81.55.164]:39989 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbZA2Kq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:46:26 -0500
Message-ID: <498188FF.90107@goop.org>
Date: Thu, 29 Jan 2009 02:46:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 2 of 7] x86/pvops: add a paravirt_ident functions to allow
 special patching
References: <patchbomb.1233182100@abulafia.goop.org> <79ff4280c71ffeba69d2.1233182102@abulafia.goop.org> <200901291835.49251.rusty@rustcorp.com.au>
In-Reply-To: <200901291835.49251.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> I think I prefer:
>
> /* make_pte etc and pgd_val etc are identity functions. */
> #define paravirt_native_page_op \
> 	(sizeof(pte_t) == sizeof(u64) ? paravirt_ident_64 : paravirt_ident_32)
>
> Then use that everywhere rather than these defines?
>   

Hm, also I don't think that will work because paravirt_ident_32|64 
return different types.  The compiler might promote paravirt_ident_32 to 
returning a 64-bit number, which would be a bit disastrous. 

    J
