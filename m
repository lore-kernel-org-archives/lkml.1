Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZFFHZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZFFHZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 03:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZFFHZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 03:25:34 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65134 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZFFHZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 03:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F/uD2dZdsGmBUf4/L2062FuzA6fWIyoIk5O9XHAroRZpCJaStAHi+gR+IHIyIVNfQ8
         iWKRvibT8nxsliMvGya5+CoXlKao52zsHbYjUJxjZMEe6Z/VT0O8TR8ZlUf9t3a+6Jck
         Baot1+mS0r+zNRwgMgd57e/6aGZOr/9/Po6mw=
MIME-Version: 1.0
In-Reply-To: <20090605130835.e21eaf37.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <20090605130835.e21eaf37.akpm@linux-foundation.org>
Date: Sat, 6 Jun 2009 09:25:34 +0200
Message-ID: <71cd59b00906060025w66d770f7he34f9172cd720c8c@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Corentin Chary <corentin.chary@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 10:08 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Fri, 5 Jun 2009 11:59:41 +0300 (EEST)
> Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>
>>  /*
>> + * Camera helpers
>> + */
>> +
>> +static void eeepc_enable_camera(void)
>> +{
>> +     int err;
>> +
>> +     err = set_acpi(CM_ASL_CAMERA, 1);
>> +     if (err)
>> +             printk(EEEPC_WARNING "Unable to enable camera %d\n", err);
>> +}
>> +
>> +/*
>>   * Sys helpers
>>   */
>>  static int parse_arg(const char *buf, unsigned long count, int *val)
>> @@ -996,6 +1009,9 @@ static int __init eeepc_laptop_init(void)
>
> We can do this:
>
> --- a/drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-enable-camera-by-default-fix
> +++ a/drivers/platform/x86/eeepc-laptop.c
> @@ -334,7 +334,7 @@ static const struct rfkill_ops eeepc_rfk
>  * Camera helpers
>  */
>
> -static void eeepc_enable_camera(void)
> +static void __init eeepc_enable_camera(void)
>  {
>        int err;
>
> _
>
> if we're so inclined?
>

Right, thanks, fixed patch pushed into acpi4asus.

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
