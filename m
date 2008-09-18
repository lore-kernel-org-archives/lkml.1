Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYIRPEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYIRPEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYIRPEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:04:24 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:13522 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbYIRPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v0m4hxCZeXdLrgdaAr2R6gLiHAbuLBu/B4vlVmrbQO2rBNuT913AbImxekL+/By80N
         2BbdLWgaiZWLongRFiNi6OlRGRsJcjtx12PrqUMZbP0oQyQ9mLTTuPAtxIaKyC86Otk/
         HGzL27logHVNxa+Wt0YykgWgiDeak4fiJp1/Y=
Date: Thu, 18 Sep 2008 19:06:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement
	ARRAY_SIZE().
Message-ID: <20080918150624.GA3421@x200.localdomain>
References: <20080918132447.516309749@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918132447.516309749@fluff.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 02:24:47PM +0100, Ben Dooks wrote:
> Move the ARRAY_AND_SIZE() macro from arch/arm/mach-pxa/generic.h
> to a more useful position in include/linux/kernel.h. This macro
> is very useful to registration functions that take an array and
> the number of array elements in it as consecutive arguments.
> 
> The macro also should ensure that mistakes where the wrong array
> is used to the ARRAY_SIZE() macro is passed. It also makes it
> easier to avoid wrapping registration function arguments.

> --- linux-2.6.27-rc6-quilt4.orig/include/linux/kernel.h
> +++ linux-2.6.27-rc6-quilt4/include/linux/kernel.h
> @@ -43,6 +43,7 @@ extern const char linux_proc_banner[];
>  #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
>  
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> +#define ARRAY_AND_SIZE(arr) (arr), ARRAY_SIZE(arr)

Just like ARRAY_SIZE, it is misnamed.

And it isn't obvious to what it expands. Hopefully arm people will
remove it. :-)
