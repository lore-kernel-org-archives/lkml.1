Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbXJZIFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbXJZIFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 04:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXJZIFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 04:05:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:33861 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXJZIFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 04:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ine755LOqJWZwaPsV0QAmvgbsk9XEw/f9oZMtIgENTRTYaj6YFxeIdiOc9BqHF2CU0BtB/5AnWfAPu3w1VCXVPaS0suoH3GI+1S8QXKVIV/IXhasyRRv9Cm7cAKnmpy5ctdjxXHIqfRjebAGxwFPGpKo9kmqPqKiqJv6cj5yvQ0=
Message-ID: <84144f020710260105w358bf6f0m6c373108b9aab9a8@mail.gmail.com>
Date: Fri, 26 Oct 2007 11:05:14 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       cjwatson@ubuntu.com, linux-mm@kvack.org, neilb@suse.de
In-Reply-To: <Pine.LNX.4.64.0710251556300.1521@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>
	 <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
	 <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
	 <Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
	 <84144f020710221348x297795c0qda61046ec69a7178@mail.gmail.com>
	 <Pine.LNX.4.64.0710251556300.1521@blonde.wat.veritas.com>
X-Google-Sender-Auth: fd1aa3ae1e54fc2b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On 10/25/07, Hugh Dickins <hugh@veritas.com> wrote:
> @@ -349,10 +349,6 @@ static pageout_t pageout(struct page *pa
>                 res = mapping->a_ops->writepage(page, &wbc);
>                 if (res < 0)
>                         handle_write_error(mapping, page, res);
> -               if (res == AOP_WRITEPAGE_ACTIVATE) {
> -                       ClearPageReclaim(page);
> -                       return PAGE_ACTIVATE;
> -               }

I don't see ClearPageReclaim added anywhere. Is that done on purpose?
Other than that, the patch looks good to me and I think we should
stick it into -mm to punish Andrew for his secret hack ;-).

                                          Pekka
