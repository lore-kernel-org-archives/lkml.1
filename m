Return-Path: <linux-kernel-owner+w=401wt.eu-S965349AbXBLTnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbXBLTnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965338AbXBLTnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:43:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43201 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345AbXBLTnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:43:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p6pmnubbg5vVCDQLAtmWeybawBpzVqz8282Kgks82XLhpsz8G6LtSCqfrQlhlW1xbu9LepSrJssYy7x0qWMHeNSwWcTaMGH/+DTWmjPkxH0v4vGI/T6wgXw6/63vqIZn5QFCBXZBxpLRD+8LlMX7TzdEDA/2GdYim0GH2RA/bto=
Message-ID: <ef1cd66f0702121143i765ccd1ere8ecb28eeaab5759@mail.gmail.com>
Date: Mon, 12 Feb 2007 19:43:36 +0000
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH x86 for review III] [1/29] i386: avoid gcc extension
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Segher Boessenkool" <segher@kernel.crashing.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070212551.664370000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212551.664370000@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/02/07, Andi Kleen <ak@suse.de> wrote:
> setcc() in math-emu is written as a gcc extension statement expression
> macro that returns a value.  However, it's not used that way and it's not
> needed like that, so just make it a do-while non-extension macro so that we
> don't use an extension when it's not needed.

This description ...

> -#define setcc(cc) ({ \
> -  partial_status &= ~(SW_C0|SW_C1|SW_C2|SW_C3); \
> -  partial_status |= (cc) & (SW_C0|SW_C1|SW_C2|SW_C3); })
> +static inline void setcc(int cc)
> +{
> +       partial_status &= ~(SW_C0|SW_C1|SW_C2|SW_C3);
> +       partial_status |= (cc) & (SW_C0|SW_C1|SW_C2|SW_C3);
> +}

... seems to contradict the implementation.  No "do-while" here.

I hope this helps,
Jochen
-- 
http://seehuhn.de/
