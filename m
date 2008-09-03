Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYICJfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYICJfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYICJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:35:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:41595 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYICJfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ce73H45TLs95eWODuPvpYnPPJoMPRMLZG8Y0ECZDdBVq34jeIu/Me/6fKpSA7eqksn
         OPBMN4/amPatP0lgcRLtWVO4UW7+8GdminZ+sXotcke0JE6q3NTYg7CQtasSoqzhy8yr
         ImOM94iZ+6PzB9ci8kxhp0XS3yMQAHqiN1LNw=
Message-ID: <84144f020809030235p14f71915v355102005add6c5a@mail.gmail.com>
Date: Wed, 3 Sep 2008 12:35:43 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Steve VanDeBogart" <vandebo-lkml@nerdbox.net>
Subject: Re: [uml-devel] [PATCH 4/6] VM: Annotate pagealloc
Cc: jiayingz@google.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, dkegel@google.com,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <alpine.DEB.1.00.0809022209100.15543@abydos.NerdBox.Net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
	 <alpine.DEB.1.00.0808291616170.15543@abydos.NerdBox.Net>
	 <84144f020808300357l9dddda4y726622641ac7f592@mail.gmail.com>
	 <alpine.DEB.1.00.0809022209100.15543@abydos.NerdBox.Net>
X-Google-Sender-Auth: d3d81a5ae08d2894
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, Sep 3, 2008 at 8:25 AM, Steve VanDeBogart
<vandebo-lkml@nerdbox.net> wrote:
>>> Index: linux-2.6.27-rc5/mm/page_alloc.c
>>> @@ -1080,6 +1081,7 @@
>>>               if (!page)
>>>                       goto failed;
>>>       }
>>> +       VALGRIND_MAKE_MEM_UNDEFINED(page_address(page), PAGE_SIZE <<
>>> order);
>>
>> No SHOUTING macros please, and I think you should just pass page and
>> order here and do the calculation elsewhere.
>
> Valgrind provides a header file that defines these annotation functions.
> For the ease of tracking changes to this header file, I've made minimal
> changes to it (just a couple lines to integrate with Kconfig).  If the
> interfaces and/or style is objectionable to the kernel community at
> large, than we will have to decide to either wrap the interface that
> Valgrind provides or modify the header and track changes manually.

That's trivially fixable by adding a wrapper for the ugly valgrind
macros and hiding that in some header file. Preferably something
similar to what the kmemcheck hooks look like so that we can also use
them in the future if we implement tracking at page allocator level
too.

                                 Pekka
