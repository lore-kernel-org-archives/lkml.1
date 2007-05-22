Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbXEVAGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbXEVAGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbXEVAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:05:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:29375 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbXEVAF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hcr1AsiSkUvJnG0RZD+H8YvYFxcEFP4t7XrQl/vxwcYAcMimJyk2cpSpaIFjvVFNORcjjveYjsam38zUugpYnuuUBFg1rE5+tG8LvfZDzJkUarib9Ajei6OeedMCNaK2infyTovqKWn7QezVjrZ4GczYUuueqqt4MvgxQfYScao=
Message-ID: <86802c440705211705t295ba3efqa4ea6eb94cc509a0@mail.gmail.com>
Date: Mon, 21 May 2007 17:05:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH]serial: make early_uart to use early_param instead of console_initcall
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705211642.05620.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705211336h76a3f41ag4847860ea6837485@mail.gmail.com>
	 <200705211642.05620.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> I don't want to add asm-ia64/fixmap.h with dummy definitions
> just for this.
>
> Can we add this:
>
>   asm-ia64/io.h:   #define bt_ioremap ioremap
>   asm-x86_64/io.h: #define bt_ioremap early_ioremap
>
> and use bt_ioremap instead?
>
I can not use early_ioremap in x86_64. it is need to place after
init_memory_mapping in setup_arch. and parse_early_param is before
that.

YH
