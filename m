Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYBJRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYBJRaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYBJRaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:30:07 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:26477 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYBJRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:30:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RhK2wyzhfmP/rR9aZjTK3PO/TUI0DgPL90vx1auCJ5orIO2h+1FMmRQKodYVIcxOBEUUSnO1NkfdGc4WztMcKxnzprAjqQ5uu4LTBeCGasOM2eA8G7OVhqWGiHeFYA+/cH2sEx2gWQrbSlWVgwIiBO4oP/KLEUcMkja38IvJBVc=
Message-ID: <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com>
Date: Sun, 10 Feb 2008 09:30:01 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] kgdb light, v5
Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jason Wessel" <jason.wessel@windriver.com>
In-Reply-To: <20080210163603.GB28201@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080210071304.GA3788@elte.hu>
	 <20080210104709.GB10790@uranus.ravnborg.org>
	 <20080210163603.GB28201@elte.hu>
X-Google-Sender-Auth: e5c7891600bb1eb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 8:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
> +#ifdef CONFIG_64BIT
> +       } else if ((count == 8) && (((long)mem & 7) == 0)) {
> +               u64 tmp_ll;
> +               if (probe_kernel_address(mem, tmp_ll))
> +                       return ERR_PTR(-EINVAL);
> +
> +               mem += 8;
> +#ifdef __BIG_ENDIAN
> +               *buf++ = hexchars[(tmp_ll >> 60) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 56) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 52) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 48) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 44) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 40) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 36) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 32) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 28) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 24) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 20) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 16) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 12) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 8) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 4) & 0xf];
> +               *buf++ = hexchars[tmp_ll & 0xf];
> +#else
> +               *buf++ = hexchars[(tmp_ll >> 4) & 0xf];
> +               *buf++ = hexchars[tmp_ll & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 12) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 8) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 20) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 16) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 28) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 24) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 36) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 32) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 44) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 40) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 52) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 48) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 60) & 0xf];
> +               *buf++ = hexchars[(tmp_ll >> 56) & 0xf];
> +#endif

Am I missing something? (I'm due, so it's not really a rhetorical
question :-) .) Wouldn't

unsigned int void u64_to_hex(u64 val, unsigned char *buf)
{
         int i;
         for (i=15; i>=0; i--) {
                  buf[i] = hexchars[ val & 0x0f ];
                  val >>= 4;
         }
         return 16;
}
...
         buf += u64_to_hex(cpu_to_be64(tmp_ll), buf);

be clearer both visually, and code-as-intent? (And equivalent helpers
for u32, u16 -- though they could all be rolled into one.)
