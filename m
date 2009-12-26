Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZLZBge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZLZBge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 20:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbZLZBgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 20:36:33 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:62281 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbZLZBgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 20:36:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jDg9+wr/SoYu+FY7G5Rd57MRcGfkI3vebo7+pT5QJ6eWH9/Ncd8Jow6gzJ8UcXbFTR
         Np+kUtYllc7xugzcAN0CdvSJ0vr5Sjh5WbiooQogVZy50MH2yNYUoEZfqthmVbP4LY4c
         J2oFEBdWbGvUynujX6XW1Fqt6Bccc/syUqy3U=
Date: Fri, 25 Dec 2009 17:36:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: Regression in module wmi since 2.6.32 (bisected to commit
	1caab3c)
Message-ID: <20091226013618.GB23802@core.coreip.homeip.net>
References: <4B352513.90302@lwfinger.net> <200912252158.31127.carlos@strangeworlds.co.uk> <4B353818.1020308@lwfinger.net> <200912260118.26391.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912260118.26391.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlos,

On Sat, Dec 26, 2009 at 01:18:26AM +0000, Carlos Corbacho wrote:
> @@ -747,6 +763,16 @@ static __init acpi_status parse_wdg(acpi_handle handle)
>  	memcpy(gblock, obj->buffer.pointer, obj->buffer.length);
>  
>  	for (i = 0; i < total; i++) {
> +		/*
> +		  Some WMI devices, like those for nVidia hooks, have a
> +		  duplicate GUID. It's not clear what we should do in this
> +		  case yet, so for now, we'll just ignore the duplicate.
> +		  Anyone who wants to add support for that device can come
> +		  up with a better workaround for the mess then.
> +		*/
> +		if (guid_already_parsed(gblock[i].guid) == true) {

A warning message is probably warranted here.

> +			continue;
> +		}
>  		wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
>  		if (!wblock)
>  			return AE_NO_MEMORY;

-- 
Dmitry
