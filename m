Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbXHaLMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbXHaLMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbXHaLLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:11:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:24835 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbXHaLLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OPPELGg6FjMWxKNMhLqqJl7IATp1wnVtPEO62CabwlhOUnzIhfRSZOmoVDW2ckRzRubGFxd9ZUCA3MP5fxpLHKefwYDkyk4UkMczwBVwCBbWI7afv14OYz0JFxiPDT3a6PlbWCojoaLxglW+0gaJP/OQQbJlWhvGnrt25+gV4G0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
Date: Fri, 31 Aug 2007 12:11:25 +0100
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <46D5F462.9010401@redhat.com>
In-Reply-To: <46D5F462.9010401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311211.25143.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007 23:34, Eric Sandeen wrote:
> Noticed today that the combination of 4KSTACKS and DEBUG_STACKOVERFLOW
> config options is a bit deadly.
>
> DEBUG_STACKOVERFLOW warns in do_IRQ if we're within THREAD_SIZE/8 of the
> end of useable stack space, or 512 bytes on a 4k stack.
...
> The large stack usage in those 2 functions is due to big char arrays, of
> size KSYM_NAME_LEN (128 bytes) and KSYM_SYMBOL_LEN (223 bytes).
>
> IOW, the stack warning effectively reduces useful stack left in our itty
> bitty 4k stacks by over 10%.

KSYM_NAME_LEN = 128 sounds stupid. The name which is wider than 80 chars??
Kernel shouldn't have names that long.
Say, 50 chars ought to be enough.
--
vda
