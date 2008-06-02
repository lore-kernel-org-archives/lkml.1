Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYFBJip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYFBJip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYFBJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:38:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:32784 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYFBJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aonBDDhke5ZgFQKV6/AFHv3zkgemi5Zj3VNTOkqQoYQ1JpdvFgv6BLucqsFl4/2rTuxB2fbJ8FnDxnzokyxeDpwYqWuMag2SlXRsXmxiUZCCYAF3ZSRfZhL5bgZvZ+12fh+mqZ7zxNsLPRnIP6gPMzBl2VCyXbzgYazis5y5T/E=
Message-ID: <19f34abd0806020238h2eba8765la3764b15211a205@mail.gmail.com>
Date: Mon, 2 Jun 2008 11:38:36 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Steve French" <smfrench@gmail.com>
Subject: Re: optimizing out inline functions
Cc: "Sam Ravnborg" <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <524f69650805290939v65f9f5b8m65fd1ba23acd08d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com>
	 <20080528200057.GA7300@uranus.ravnborg.org>
	 <524f69650805290939v65f9f5b8m65fd1ba23acd08d8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 6:39 PM, Steve French <smfrench@gmail.com> wrote:
> Ran into one loosely related question, printk takes a variable
> argument list, so the calling function in this case would also need to
> be able to handle thos variable arguments.  With macros, we are able
> to do things like with variable arguments easily
>
> #define function_to_print_some_warning(format, arg...)
> printk(KERN_WARNING ": " format "\n" , ## arg)
>
> Are there style rules (or nicely written examples) for doing this
> (variable argument lists) with (inline) functions
>

Hm, are you referring to making a proxy inline function that takes a
variable number of arguments and calls another function with the same
(also variable number of) variables?

I don't think this is possible unless you want to use va_lists. And
that might not be desirable in an inline function, I don't know how
well gcc can optimize this away.

The canonical example, although not an inline function, is printk()
itself from kernel/printk.c, which simply calls vprintk().


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
