Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZGKMnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZGKMnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 08:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbZGKMnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 08:43:03 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:53596 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZGKMnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 08:43:02 -0400
Date: Sat, 11 Jul 2009 08:40:45 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Paul Bolle <pebolle@tiscali.nl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what means "module_param(channel_mask, channel_mask, 0644)"?
In-Reply-To: <1247316097.7262.11.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0907110840100.6142@localhost>
References: <alpine.LFD.2.00.0907110658370.4257@localhost> <1247316097.7262.11.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Paul Bolle wrote:

> On Sat, 2009-07-11 at 07:01 -0400, Robert P. J. Day wrote:
> > researching my next newbie column about module parameters and i ran
> > across the following:
> >
> > drivers/input/misc/ati_remote2.c:module_param(channel_mask, channel_mask, 0644);
> > drivers/input/misc/ati_remote2.c:module_param(mode_mask, mode_mask, 0644);
> >
> > i have no idea what it means to have the second (type) field of
> > module_param() simply repeat the name of the parameter.  is this some
> > strange magic?  those two names don't *appear* to be typedef'ed
> > anywhere i can see.
>
> See include/linux/moduleparam.h:
>     /* Helper functions: type is byte, short, ushort, int, uint, long,
>        ulong, charp, bool or invbool, or XXX if you define param_get_XXX,
>        param_set_XXX and param_check_XXX. */
>     #define module_param_named(name, value, type, perm)                        \
>             param_check_##type(name, &(value));                                \
>             module_param_call(name, param_set_##type, param_get_##type, &value, perm); \
>             __MODULE_PARM_TYPE(name, #type)
>
>     #define module_param(name, type, perm)                          \
>             module_param_named(name, name, type, perm)
>
> And in drivers/input/misc/ati_remote2.c we find:
>     #define param_check_channel_mask(name, p) __param_check(name, p, unsigned in
>     #define param_set_channel_mask ati_remote2_set_channel_mask
>     #define param_get_channel_mask ati_remote2_get_channel_mask
>     module_param(channel_mask, channel_mask, 0644);
>     [...]
>     #define param_check_mode_mask(name, p) __param_check(name, p, unsigned int)
>     #define param_set_mode_mask ati_remote2_set_mode_mask
>     #define param_get_mode_mask ati_remote2_get_mode_mask
>     module_param(mode_mask, mode_mask, 0644);
>
> To me that looks like two implementations of the three param_*_XXX
> functions described in the comment quoted above.
>
> Does that answer your question?

  yup.  i was looking for something like that, i guess i just missed
it.  thanks.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
