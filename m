Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbYE2Qjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbYE2Qjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYE2Qjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:39:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:27882 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbYE2Qjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MicLgCfOfbOMVP0R+RVgAPVfP14liRSxvvHNTOKd2dQJD3a8/q2u6nV4sqvIbxQdrFFbcwERnQkJlQsUzQ6hk/PzNTxlj3MRjtZLtJelIEySi088YtiilBx0BKBTShDMWbShVgkH3z2ISC4imx59Eh7U7mdVwEJyY/tedJvgJUY=
Message-ID: <524f69650805290939v65f9f5b8m65fd1ba23acd08d8@mail.gmail.com>
Date: Thu, 29 May 2008 11:39:32 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: optimizing out inline functions
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080528200057.GA7300@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650805281251r1b1d99a1tc3223d15e3aeb50c@mail.gmail.com>
	 <20080528200057.GA7300@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ran into one loosely related question, printk takes a variable
argument list, so the calling function in this case would also need to
be able to handle thos variable arguments.  With macros, we are able
to do things like with variable arguments easily

#define function_to_print_some_warning(format, arg...)
printk(KERN_WARNING ": " format "\n" , ## arg)

Are there style rules (or nicely written examples) for doing this
(variable argument lists) with (inline) functions

On Wed, May 28, 2008 at 3:00 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, May 28, 2008 at 02:51:02PM -0500, Steve French wrote:
>> In trying to remove some macros, I ran across another kernel style
>> question.  I see two ways that people try to let the compiler optimize
>> out unused code and would like to know which is preferred.  The first
>> example uses an empty inline function and trusts the compiler will
>> optimize it out.
>>
>> #ifdef CONFIG_DEBUG_SOMETHING
>> static inline void some_debug_function(var1)
>> {
>>     something = var1;
>>     printk(some debug text);
>> }
>> #else
>> static inline void some_debug_function(var1)
>> {
>>    /* empty function */
>> }
>> #endif
>
> With reference to a recent thread about kconfig
> I would prefer:
> static inline void some_debug_function(var1)
> {
>        if (KCONFIG_DEBUG_SOMETHING) {
>                something = var1;
>                printk(some debug text);
>        }
> }
>
>
> But we do not have KCONFIG_DEBUG_SOMETHING available
> so the second best is to use an empty function
> to keep the typechecking in place.
>
> IIRC gcc optimize both away.
>
>        Sam
>



-- 
Thanks,

Steve
